#import "template.typ": *
#import "@preview/physica:0.9.4": *
#show: doc => conf(doc)
#set text(
    font: ("Times New Roman", "STSong")
)
#show emph: set text(font: ("Times New Roman", "LXGW WenKai"), weight: "medium")
#show strong: set text(font: ("Times New Roman", "Noto Sans CJK HK"))
#show smallcaps: set text(font: "Latin Modern Roman Caps")

#let cp = $cal(P)$
#let cc = $cal(C)$
#let cs = $cal(S)$
#let ct = $cal(T)$
#let pm = $plus.minus$
#let ii = $upright(i)$
#let tensor = $times.circle$

= 表面码数学原理
== 稳定子码
=== 泡利群、稳定子群、编码空间
泡利群(Pauli group) $cp_n$ 为泡利算子 $angle.l X, Y, Z angle.r$ 的 $n$ 次张量积：$ cp_n = {pm 1, pm ii} dot {pm upright(I), pm ii I, pm X, pm Y, pm Z}^(tensor n). $
其满足：1. $cp_n$ 中的任意两个元素是对易(commute)或反对易的(anticommute)；2. $cp_n$ 中的任意元素是厄米(Hermitian)或反厄米的(anti-Hermitian)；3. $cp_n$ 中的任意元素是幺正的(unitary)。

稳定子群(stabilizer group) $cs$ 是泡利群的一个阿贝尔子群(abelian subgroup)，即 $cs$ 中的任意两个元素是对易的。注意我们定义 $-I in.not cs$。

#def(supplement:"编码空间")[
    编码空间(codespace) $ct(cs)$ 是 $cs$ 中特征值为 $+1$ 的特征向量构成的空间：$ ct(cs) = {ket(psi) | S ket(psi) = ket(psi), forall S in cs}. $
]

=== 中心化子、正规化子
中心化子(centralizer) $cc(cs)$ 是泡利群中与 $cs$ 中的所有元素对易的元素构成的子群：$ cc(cs) = {E in cp_n | [E, S] = 0, forall S in cs}. $
正规化子(normalizer) $cal(N)(cs)$ 是泡利群中与 $cs$ 中的所有元素通过共轭保持不变的元素构成的子群：$ cal(N)(cs) = {E in cp_n | E^dagger S E in cs, forall S in cs}. $
#thm(
    [在泡利群中，$cc(cs)=cal(N)(cs)$。],
    proof: [
        泡利群中任意两个元素是对易或反对易的，则有
        $ E^dagger S E = pm E^dagger E S = pm S, $
        又 $-I in.not cs$，即 $-S in.not cs$，有 
        $ E^dagger S E &= S \ arrow.double S E &= E S. $
        因此 $cc(cs)=cal(N)(cs)$ 得证。
    ]
)

对于任意 $E in cc(cs)-S$，其为一个无法检测的逻辑错误(logical error)，即 $E$ 作用在编码空间 $ct(cs)$ 上的结果仍然在编码空间中，但是又会改变当前的态。因此可称之为一个逻辑算子(logical operator)，能进行逻辑 $angle.l X, Y, Z angle.r$ 操作。
#def(supplement: "码距")[
    泡利算子 $P in cp_n$ 的权 $|P|$ 是它产生非平凡作用（即并非 $I$ 算子）的量子比特的个数。该稳定子码的码距(code distance)定义为 $cc(cs)-cs$ 中元素的最小权的大小。
]<code-distance>

=== 生成元与错误症候
稳定子群 $cs$ 的生成元 ${S_1, S_2, ..., S_r}$ 被称为校验算子(check operators)。
#def(supplement: "错误症候")[
    给定一个泡利错误 $E in cp_n$，其症候(syndrome) $sigma(E)$ 定义如下：
    $ 
    sigma_(S)(E) &= cases(
        0 space "if" [S,E] = 0 &("commute"),
        1 space "if" {S,E} = 0 space&("anticommute"),
    ) \
    sigma(E) &= (
        sigma_(S_1)(E), sigma_(S_2)(E), ..., sigma_(S_r)(E)
    )
    $
]<syndrome>
=== 纠错理论
给定一个错误症候 $sigma(E)$，解码器根据它来选择一个纠错算子 $R in cp_n$，若 $R E in cs$，就有 $R E ket(psi) = ket(psi)$，纠错成功；若 $R E in cp_n - cc(cs)$，就有 $R E ket(psi)$ 不处于 $ct(cs)$ 编码空间中，不是一个正确编码，纠错失败。
#thm(
    [当 $R$ 和 $E$ 的症候相同时，$R E in cc(cs)$。],
    proof: [
        对于任意一个稳定子 $S in cs$，有 
        $  
        R E S &= R (E S) = (-1)^(sigma_S (E)) R S E \
        S R E &= (S R) E = (-1)^(sigma_S (R)) R S E.
        $
        由于症候相同，即 $sigma_S (E) = sigma_S (R)$，因此 
        $ 
        (R E) S &= S (R E), forall S in cs \
        arrow.double R E &in cc(cs)
        $
        得证。

        此时若 $R E in cc(cs) - cs$，则发生一个逻辑错误(logical error)，逻辑比特的逻辑态被改变。
    ]
)


== 表面码
#rm[
你可能见过以下几种表面码的图示：
#figure(
    grid(
        columns: 3,
        gutter: 1em,
        align: horizon,
        grid.cell[#image("img/img1.png", width: 80%) (a)],
        grid.cell[#image("img/img2.png", width: 80%) (b)],
        grid.cell[#image("img/img3.png", width: 80%) (c)]
    ),
    caption: "Different surface code representations",
) <surface-code-represent>
实际上三者是一致的，只是进行了一些旋转以及边和顶点的交换，我们会在之后展示。这里使用#ref(<surface-code-represent>)中的图(a)来介绍表面码的基本概念。
]
=== 表面码的构成
在图(a)当中，我们将 *数据比特放置在每条边* 上；在每个顶点处放置 $Z$ 型稳定子，称之为 *顶点稳定子(vertex stabilizers)*；在每个面心处放置 $X$ 型稳定子，称之为 *面稳定子(plaquette stabilizers)*。在后面的检错与纠错阶段，我们将看到这样定义的方便之处。

下图是两种稳定子的示意，红色意味着 $X$ 型稳定子，其作用在该面的四条边上；蓝色则为 $Z$ 型稳定子，作用在顶点相连的四条边上。
#figure(
    image("img/img4.png", width: 60%),
    caption: "Examples of vertex and plaquette stabilizers"
)
接下来分析两种稳定子的具体电路构造。在#ref(<stab-circuit>)a 中可以看到 $Z$ 型稳定子的实现，在中心会有一个辅助比特(ancilla qubit)用于测量，该投影测量会强迫临近四个数据比特进入该稳定子 $Z_a Z_b Z_c Z_d$ 的本征态中，即 $Z_a Z_b Z_c Z_d ket(psi)=Z_(a b c d)ket(psi), Z_(a b c d)=pm 1$，显然当辅助比特的测量结果为 $ket(0)$ 时，表征本征值为$+1$，反之为 $-1$。在#ref(<stab-circuit>)b 中可以看到 $X$ 型稳定子的类似实现，以将数据比特投影到 $X_a X_b X_c X_d$ 的本征态中。

注意到#ref(<stab-circuit>)a 中额外施加了一个 $I$ 门，这是为了与#ref(<stab-circuit>)b 中施加的 Hadamard 门保持同步，减少测量时间不匹配导致的误差。
#figure(
    image("img/img5.png", width: 60%),
    caption: [$X \& Z$ stabilizers quantum circuit construction]
)<stab-circuit>

根据定义，要构成一个稳定子群，这些稳定子必须相互对易。显然 $X$ 型稳定子之间是对易的，$Z$ 型稳定子之间也是对易的。而 $X$ 型稳定子与 $Z$ 型稳定子之间总是有零或两个重合的边。
#thm(
    [在上述表面码结构中，$X$ 型稳定子与 $Z$ 型稳定子总是对易的。],
    proof: [
        若二者没有重合边，则它们的作用在数据比特上是完全独立的，显然对易；若二者有两个重合边，即测量同样两个数据比特，假设 $a,c$ 为重合边，则有
        $ 
        (X_a X_b X_c X_d)(Z_a Z_e Z_c Z_f) &= (X_a Z_a) tensor X_b tensor Z_e tensor (X_c Z_c) tensor X_d tensor Z_f \
        &= -(Z_a X_a) tensor Z_e tensor X_b tensor -(Z_c X_c) tensor Z_f tensor X_d \
        &= (Z_a Z_e Z_c Z_f)(X_a X_b X_c X_d). \
        $
        简单来看，$X_a, Z_a$ 与 $X_c, Z_c$ 两对反对易算子相互抵消，结果是 $X$ 型稳定子与 $Z$ 型稳定子相互对易。
    ]
) 

当然，$X$ 型稳定子与 $Z$ 型稳定子是完全对称的。在#ref(<dual-lattice>)左可以看到，$X$ 型稳定子的组合会构成格(lattice)中的环(loops)；对于 $Z$ 型稳定子，我们以每条边的中点为心将每条边旋转90°（灰色虚线表征旋转后的结果），这样就将面和顶点进行了交换，紫色实线即为三个 $Z$ 型稳定子的组合结果，显然与左图结构是一致的。形式上，这被称作在对偶格(dual lattice)中表示算子。
#figure(
    grid(
        columns: 2,
        column-gutter: -5em,
        align: horizon,
        [#image("img/img6.png", width: 60%)],
        [#image("img/img7.png", width: 60%)]
    ),
    caption: "Dual Lattice"
) <dual-lattice>

=== 错误检测
往表面码中插入一些泡利 $X$ 错误，症候图和相应的错误如下：
#figure(
    image("img/img8.png", width: 40%),
    caption: [Syndrome and $X$ Error]
)
黄色顶点是与错误反对易的一些 $Z$ 型稳定子，他们是错误症候的一部分，依照#ref(<syndrome>)，其满足 $sigma_(S_i)(E) = 1$，它们通常被称为 *激励(excitations)* 或者 *缺陷(defects)*。

我们把这些相连的错误称为一条 *错误链(error chain)*。可以发现缺陷通常存在于错误链的端点处，因此当错误链成环时，缺陷消失，此时该错误与所有稳定子对易，即 $E in cc(cs)$。

== 逻辑比特与逻辑算子
我们如果从流形和拓扑的角度来考量表面码，就能发现它其实可以转换成一个环面，这样就能更轻易地判断一个环是平凡的（即 $M in cs$）还是非平凡的（即 $M in cc(cs)-cs$），不过在此不表。

将所有数据比特用一个逻辑态 $ket(u)_L$ 表征，辅助比特的状态 $ket(v)$ 表征症候，整个阵列的量子态即为 $ ket(psi) = ket(u)_L tensor ket(v) . $

比如对于#ref(<dual-lattice>)的左图，如果我们把红色边视作一整条错误链，其成环之后，就相当于三个 $X$ 型稳定子的组合，作用在当前的量子态上不改变任何东西。

而对于#ref(<logical-X>)左图，可以发现它不能由任何稳定子生成，并且也与所有稳定子对易，作用之后，会翻转逻辑态 $ket(u)_L$ 而不改变稳定子测量结果，其被称为一个 *逻辑 $X$ 算子($X_L$)*。右图与左图相比只是增加一些 $X$ 型稳定子，依然是一个 $X_L$。可以发现，联通左右边界或者上下边界的一条链即为一个非平凡的逻辑算子。
#figure(
    grid(
        columns: 2,
        column-gutter: -5em,
        align: horizon,
        [#image("img/img9.png", width: 60%)],
        [#image("img/img10.png", width: 60%)]
    ),
    caption: [Logical $X$ Operator]
)<logical-X>

可以发现对于图中的表面码，水平和垂直分别有两个逻辑算子 $X_(1L), Z_(1L)$ 和 $X_(2L), Z_(2L)$，因此可以编码 2 个逻辑比特；又根据#ref(<code-distance>)可知该表面码的码距为 4（因为上下联通，左右联通）。

== 具有开放边界的表面码
考虑以下版本的表面码#ref(<open-bound-sq>)，其中顶部和底部边界上的 $Z$ 型稳定子以及左侧和右侧边界上的 $X$ 稳定子现在仅作用在三个数据比特上。

我们将上下边界称为平滑边界(smooth boundaries)，将左右边界称为粗糙边界(rough boundaries)。可以看出，该表面码的码距为 5；水平方向仅有一个逻辑 $X$ 算子 $X_(L)$，垂直方向仅有一个逻辑 $Z$ 算子 $Z_(L)$，因此可以编码 1 个逻辑比特。此时 $X_L$ 必须连接粗糙边界，而 $Z_L$ 必须连接平滑边界。
#figure(
    image("img/img18.png", width: 60%),
    caption: "Surface Code with Open Boundaries"
)<open-bound-sq>

= 表面码解码
根据前文纠错理论，稳定子测量后给出一个错误症候 $sigma(E)$，解码器需要根据该症候来选择一个纠错算子 $R$，使得 $R E in cs$。

假设观察到症候如下#ref(<syndrome-ex>)，并想找到一个合适的纠错算子。
#figure(
    image("img/img11.png", width: 60%),
    caption: "A Syndrome Example"
)<syndrome-ex>

产生这种症候的错误链可能有很多种，比如以下三张图
#figure(
    image("img/img12.png", width: 80%),
    caption: "Possible Errors"
)
假设真实错误是第一张图，而我们选择纠错算子为第二张图，作用结果相当于一个稳定子，纠错成功。但如果选择第三张图做纠错，作用结果如#ref(<fail-correct>)，黄色边代表纠错算子。显然这是一个逻辑 $X$ 算子，纠错失败，将产生一个逻辑错误。
#figure(
    image("img/img13.png", width: 45%),
    caption: "Failed Correction"
)<fail-correct>

因此解码就是找到概率最高的错误，其等价于找到符合症候的最小错误（错误链越短，发生概率越高）。对于表面码，这相当于将缺陷与最小权重链进行匹配，这完全等同于解决 _最小权重完美匹配(minimum-weight perfect matching, MWPM)_ 问题。

== MWPM 解码器
可以把解码过程分解为两个部分：
1. 使用 _Local Dijkstra_ 算法找到连接各个缺陷的最短路径，构建完全图。
2. 使用 _Blossom_ 算法或者其他更优化版本得到一组完美匹配，根据第一部分获得相应错误链构建纠错算子。

例如考虑以下解码问题：
#figure(
    image("img/img14.png", width: 50%),
    caption: "Decode Example"
)
假设噪声独立同分布，即每条边发生错误的概率相同，则两个缺陷之间的边的权重可以由二者的曼哈顿距离表征，如#ref(<mini-match>)左图所示，构建完全图并枚举所有可能的匹配以找到最小匹配。右图为对应的错误链或者纠错算子。
#figure(
    grid(
        columns: 2,
        column-gutter: -5em,
        align: horizon,
        [#image("img/img15.png", width: 60%)],
        [#image("img/img16.png", width: 50%)]
    ),
    caption: [Minimum-Weight Matching]
)<mini-match>
另外，如果数据比特发生错误的概率并不相同，例如发生 $X$ error 的概率为 $p_i$，则在图中相应边的权重应写为 $w_i = log((1-p_i)/p_i)$#footnote[Dennis, Eric, Alexei Kitaev, Andrew Landahl, and John Preskill. 'Topological Quantum Memory', 24 October 2001. https://doi.org/10.1063/1.1499754.
]。

== 旋转表面码
从解码过程可以发现，将数据比特放置在边上，而将稳定子放置在顶点和面上，非常方便将缺陷连接为完全图来做解码。现在我们可以来看一开始提及的，关于表面码的其他两种图示。

对于#ref(<another-repr>)左图，数据比特位于顶点，稳定子位于面上，这种表示被称为校正晶格(rectified lattice)。从右图可以看出二者等价。这种表示方法的优点之一是，表面码排列更为紧凑。
#figure(
    grid(
        columns: 2,
        column-gutter: -5em,
        align: horizon,
        [#image("img/img2.png", width: 60%)],
        [#image("img/img17.png", width: 75%)]
    ),
    caption: "Rectified Lattice"
)<another-repr>

取其中心部分并添加一些边界稳定子，就能得到第三种表示如#ref(<rotate-sq>)，称为旋转表面码(rotated surface code)。
#figure(
    image("img/img3.png", width: 45%),
    caption: "Rotated Surface Code"
)<rotate-sq>

== 逻辑错误率的统计模型
#def(supplement: "阈值")[
    表面码的 *阈值(threshold)* 是其物理错误率的一个临界点。当超过该阈值时，逻辑错误率随着码距增加而增大；否则，码距增加能够降低逻辑错误率，以实现容错量子计算。
]
首先需要注意的是，表面码没有单一的阈值：它很大程度上取决于我们使用的噪声通道和解码器。

通常分为三类噪声模型：
#enum(indent: 0em)[
    *代码容量模型(code-capacity model)*，其中代码的所有物理量子位都可能出现错误，但测量被认为是准确的。
][
    *现象学噪声模型(phenomenological noise model)*，每个稳定子测量存在固定的失败概率。
][
    *电路级噪声模型(circuit-level noise model)*，其中考虑了表面码的初始化和症候提取过程的电路，并假设每个量子门之后存在一定的错误概率。
]
代码容量模型的对应阈值是最容易估计的，并且可以用来粗略地了解给定表面码或解码器的性能。

当得到阈值后，也可以估计相应的逻辑错误率。
#thm(
    [对于使用 MWPM 解码器，码距为 $d$ 的表面码，其逻辑错误率近似为 $ P_L prop (p/p_("thr"))^(d_e), $ 其中 $p_("thr")$ 为阈值，$d_e = ceil(d/2)$。],
    proof: [
        考虑#ref(<logic-error-model>)中的症候，其最可能与次可能错误链如图左与图右所示，若实际发生的错误是右图，使用 MWPM 解码器总会给出如图左的纠错算子，此时发生逻辑错误。该错误链的链长就为 $d_e$。

        当然可能对更长的错误链发生错误识别，由于发生概率与链长成指数关系，因此是小量可以暂不考虑。

        则将求出该类型错误链的发生概率即可得到逻辑错误率
        $ P_L prop d dot upright(C)^(d_e)_d dot p^(d_e) = d dot (d!)/((d-d_e)!dot d_e !) dot p^(d_e). $

        #figure(
            grid(
                columns: 2,
                column-gutter: -6em,
                align: horizon,
                [#image("img/img19.png", width: 55%)],
                [#image("img/img20.png", width: 55%)]
            ),
            caption: "Logical Error Model"
        )<logic-error-model>
    ]
)
