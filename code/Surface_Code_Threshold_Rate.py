import stim
import pymatching
import numpy as np
import matplotlib.pyplot as plt
import time
import json # 导入json库用于数据导出

# --- 全局参数和配置 ---
CODE_DISTANCES = [3, 5, 7, 9, 11] # 要模拟的码距列表
PHYSICAL_ERROR_RATES = np.logspace(-3.1, -1.5, 28) # 物理错误率 (p) 的范围
SHOTS = 100000 # 每个模拟点的采样次数
FILTER_PL_THRESHOLD = 9e-3 # P_L过滤阈值，用于绘图 (不再用于阈值计算)

# --- 辅助函数定义 ---
def create_noisy_circuit(d: int, p_physical: float, rounds: int) -> stim.Circuit:
    """
    创建带噪声的表面码线路。
    """
    if p_physical < 0: p_physical = 0
    if p_physical > 1: p_physical = 1
    return stim.Circuit.generated(
        code_task="surface_code:rotated_memory_z",
        rounds=rounds, distance=d,
        after_clifford_depolarization=p_physical,
        after_reset_flip_probability=p_physical,
        before_measure_flip_probability=p_physical,
        before_round_data_depolarization=p_physical
    )

# --- 主模拟循环 ---
logical_error_rates_all = {d: np.zeros(len(PHYSICAL_ERROR_RATES)) for d in CODE_DISTANCES}
RUN_SIMULATION = True # !! 改为 True 来运行完整模拟, False 则使用占位数据 !!

if RUN_SIMULATION:
    print(f"Starting simulation: shots = {SHOTS}")
    print(f"Scanning physical error rates (p): {len(PHYSICAL_ERROR_RATES)} points from {PHYSICAL_ERROR_RATES[0]:.2e} to {PHYSICAL_ERROR_RATES[-1]:.2e}")
    print(f"Scanning code distances (d): {CODE_DISTANCES}\n")
    start_time_total = time.time()

    for p_phys_idx, p_phys in enumerate(PHYSICAL_ERROR_RATES):
        start_time_p_phys = time.time()
        print(f"Simulating p = {p_phys:.3e} ({p_phys_idx+1}/{len(PHYSICAL_ERROR_RATES)})")
        for d_idx, d in enumerate(CODE_DISTANCES):
            num_rounds = d
            noisy_circuit = create_noisy_circuit(d, p_phys, num_rounds)
            model = noisy_circuit.detector_error_model(decompose_errors=True)
            matching = pymatching.Matching.from_detector_error_model(model)
            sampler = noisy_circuit.compile_detector_sampler()
            detection_events, observable_flips = sampler.sample(
                shots=SHOTS, separate_observables=True
            )
            predicted_observables = matching.decode_batch(detection_events)
            num_errors = 0
            if observable_flips.shape[1] > 0:
                num_errors = np.sum(np.any(predicted_observables != observable_flips, axis=1))
            logical_error_rate = num_errors / SHOTS
            logical_error_rates_all[d][p_phys_idx] = logical_error_rate
        
        end_time_p_phys = time.time()
        time_taken_p_phys = end_time_p_phys - start_time_p_phys
        remaining_points = len(PHYSICAL_ERROR_RATES) - (p_phys_idx + 1)
        estimated_remaining_time = time_taken_p_phys * remaining_points if p_phys_idx > 0 else (time_taken_p_phys * remaining_points if len(PHYSICAL_ERROR_RATES)>1 else 0)
        summary_pl_str = ", ".join([f"d{dist}={logical_error_rates_all[dist][p_phys_idx]:.1e}" for dist in CODE_DISTANCES])
        print(f"  Finished p={p_phys:.3e} in {time_taken_p_phys:.1f}s. Est. remaining: {estimated_remaining_time/60:.1f}min. P_L's: {summary_pl_str}")

    end_time_total = time.time()
    print(f"\nTotal simulation time: {(end_time_total - start_time_total)/60:.2f} minutes.")
else:
    print("WARNING: Simulation skipped. Plotting and export will use placeholder or pre-loaded data.")
    for d_val in CODE_DISTANCES: # 使用占位数据进行测试
        logical_error_rates_all[d_val] = (0.0001 + np.random.rand(len(PHYSICAL_ERROR_RATES)) * 0.5) * \
                                         (1 / (d_val/3.0)) * \
                                         (PHYSICAL_ERROR_RATES / PHYSICAL_ERROR_RATES[int(len(PHYSICAL_ERROR_RATES)*0.7)] )** (d_val/2.0)
        logical_error_rates_all[d_val] = np.clip(logical_error_rates_all[d_val], 1e-7, 1.0)


# --- 绘图部分 ---
plt.figure(figsize=(12, 8)) # 设置图像大小

for d_plot in CODE_DISTANCES:
    y_values_original = np.array(logical_error_rates_all[d_plot])
    # 过滤条件：只绘制 P_L >= FILTER_PL_THRESHOLD 的点
    plot_mask = y_values_original >= FILTER_PL_THRESHOLD
    
    p_values_for_plot = PHYSICAL_ERROR_RATES[plot_mask]
    pl_values_for_plot = y_values_original[plot_mask]
    
    if len(p_values_for_plot) > 0:
        plt.plot(p_values_for_plot, pl_values_for_plot, 'o-', label=f'd={d_plot}', markersize=4, linewidth=1.5)
    else:
        # 如果一个码距的所有点都被过滤掉了，打印一条提示消息
        print(f"Note: All data points for d={d_plot} were filtered out for plotting (P_L < {FILTER_PL_THRESHOLD:.1e}).")

plt.xscale('log') # X轴使用对数刻度
plt.yscale('log') # Y轴使用对数刻度

# 英文图表标签和标题
plt.xlabel("Physical error rate (p)")
plt.ylabel(f"Logical error rate (P_L)")
plt.title(f"Surface Code Logical Error Rate vs. Physical Error Rate ({SHOTS:,} shots)")

# 绘制论文中提及的参考阈值线
plt.axvline(0.0057, color='pink', linestyle=':', linewidth=1.2, label=f'Reference Threshold ({0.0057:.2%})')

plt.legend(fontsize=9, loc='best') # 显示图例
plt.grid(True, which="both", linestyle='--') # 显示网格线

min_pl_detectable = 1.0 / SHOTS
# Y轴下限的设定，确保能良好显示过滤后的数据起点
plt.ylim(bottom=max(min_pl_detectable / 20, 1e-7, FILTER_PL_THRESHOLD * 0.5), top=1.2) 
plt.xlim(left=min(PHYSICAL_ERROR_RATES), right=max(PHYSICAL_ERROR_RATES)) # X轴范围

plt.tight_layout() # 自动调整图像参数
plt.show() # 显示图像

# --- 数据导出部分 (导出完整的原始数据) ---
data_to_save = {
    'simulation_parameters': {
        'shots': SHOTS,
        'code_distances': CODE_DISTANCES,
        'physical_error_rates_config': { # 记录logspace的参数，方便复现
            'log_start': -3.2, 
            'log_end': -1.5,
            'num_points': len(PHYSICAL_ERROR_RATES)
        },
        'plotting_filter_pl_threshold': FILTER_PL_THRESHOLD # 记录用于绘图的过滤P_L值
    },
    'physical_error_rates': PHYSICAL_ERROR_RATES.tolist(),
    # 保存所有原始的逻辑错误率数据
    'logical_error_rates_all_ORIGINAL': {str(d): np.array(logical_error_rates_all[d]).tolist() for d in CODE_DISTANCES}
}

output_filename = "simulated_surface_code_data_ref_threshold_only.json" # 新的文件名以反映更改

try:
    with open(output_filename, 'w', encoding='utf-8') as f:
        json.dump(data_to_save, f, indent=4, ensure_ascii=False)
    print(f"\nSimulation data successfully exported to: {output_filename}")
except IOError:
    print(f"\nError: Could not write data to file {output_filename}. Check permissions or path.")
except Exception as e:
    print(f"\nAn unknown error occurred during data export: {e}")

print(f"\nNote: With {SHOTS:,} shots, the smallest non-zero P_L reliably measurable is ~{min_pl_detectable:.1e}.")
print(f"For plotting, data points with P_L < {FILTER_PL_THRESHOLD:.1e} were not displayed.")