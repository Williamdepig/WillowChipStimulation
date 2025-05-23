# 谷歌 Willow Chip 实验模拟

## 环境

` pip install -r requirements.txt `

## 指导

docs 当中为一些使用说明，包括:

- 关于 Stim 的基本了解
- 重复码与检测子
- PyMatching 检错与评估物理错误率阈值
- 表面码的代码集成实现

## 待办

- 尝试模拟 Willow Chip 芯片相关实验
  1. 检错周期与逻辑错误率的关系
  2. 码距增加与逻辑错误率的关系
  3. 模拟重复码码距提高后产生的“毁灭性错误”
  4. ...
- PyMatching 如何实现纠错
- 表面码原理分析与电路实现细节
- 尝试使用 **Blossom** 算法实现检错和纠错，以及进阶版本 Sparse Blossom、Fusion Blossom 等等
- 尝试增加 **数据比特泄露** 的错误机制
