# 谷歌 Willow Chip 实验模拟

## 环境

` pip install -r requirements.txt `

## 文件

文件结构:

```sh
├── code
│   ├── A_surface_code_memory_below_threshold.ipynb
│   ├── Real-time_decoding.ipynb
│   └── Surface_Code_Threshold_Rate.py
├── docs
│   ├── getting_started.ipynb
│   └── guidance.ipynb
├── note
├── └── surface-code-theory.pdf
└── GoogleWillowChipSimulation.pdf
```

1. _A\_surface\_code\_memory\_below\_threshold.ipynb_
   - 逻辑比特逻辑错误率随表面码码距变化折线图（d=3至d=21，步进为2）
   - 探测概率随表面码码距变化柱状图（d=3至d=21，步进为2）
   - 逻辑比特逻辑错误率与表面码码距半对数坐标系拟合图（d=3至d=11，步进为2）
   - 拟合参数 $\Lambda$ 的计算结果
2. _Real-time\_decoding.ipynb_
   - 表面码版图（可在源代码中更改码距，推荐码距为3、5、7）
   - 探测器激活图
   - 症状以及匹配图
   - 所设定码距下的逻辑错误率
3. _Surface\_Code\_Threshold\_Rate.py_
   - 不同码距表面码逻辑错误率随物理错误率变化折线图（d=3至d=11，步进为2）
4. _getting\_started.ipynb_: Stim 官方文档
5. _guidance.ipynb_ 为使用说明，包括
   - 关于 Stim 的基本了解
   - 重复码与检测子
   - PyMatching 检错与评估物理错误率阈值
   - 表面码的代码集成实现
6. _surface-code-theory.pdf_: 表面码理论部分
7. _GoogleWillowChipSimulation.pdf_: 本实验报告

## 未来探索

1. 为电路增加更多的错误机制，包括泄露错误等等。
2. 使用更先进或者更综合的解码工具，尝试联合查找、张量网络、神经网络等其他解码工具。
