#import "@preview/physica:0.9.4": *

三种泄漏移除策略：
1. _No Reset_
2. _Multi-Level Reset(MLR) gates_#footnote[McEwen, M., D. Kafri, Z. Chen, J. Atalaya, K. J. Satzinger, C. Quintana, P. V. Klimov, et al. 'Removing Leakage-Induced Correlated Errors in Superconducting Quantum Error Correction'. Nature Communications 12, no. 1 (19 March 2021): 1761. https://doi.org/10.1038/s41467-021-21982-y.
]
1. _Data Qubit Leakage Remove(DQLR)_#footnote[Miao, Kevin C., Matt McEwen, Juan Atalaya, Dvir Kafri, Leonid P. Pryadko, Andreas Bengtsson, Alex Opremcak, et al. 'Overcoming Leakage in Quantum Error Correction'. Nature Physics 19, no. 12 (December 2023): 1780-86. https://doi.org/10.1038/s41567-023-02226-w.

]

/ MLR gate: 一种特殊的 reset 门，通过 *Swap, Hold, Return* 操作，将处于激发态($ket(1), ket(2), ket(3)...$)的量子比特的能量转移到谐振器中，以恢复到基态能量，完成复位。

/ DQLR: 首先使用 MLR 门将测量比特复位，然后使用 _LeakageISWAP_ 门，其耦合 $ket(20)$ 态与 $ket(11)$ 态，作用结果为 $"LeakageISWAP"ket(20) = i ket(11)$，之后再对测量比特进行一次复位操作。

