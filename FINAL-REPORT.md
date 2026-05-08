# FINAL-REPORT — ch07-18 深度扩写第一轮

> Generated 2026-05-08
> Spec: `specs/2026-05-08-deepen-thin-chapters-design.md`
> Plan: `plans/2026-05-08-deepen-thin-chapters.md`
> 锁包 tag:`lock-pack-v1`
> Phase 1 author 提交链:a069359..643436b(12 个 commit)
> Phase 1 reviewer 报告:REVIEW-ch07.md ... REVIEW-ch18.md(12 份)

---

## 1. 一句话结论

12 章全部草稿落盘,字数全部达标,引用 hygiene 干净,跨章锚点完整 — 但 **AI-tells-blocklist 第 5 条(「不是 X 而是 Y」对仗)在 11/12 章系统性超限**,源头是锁包 grep 命令未覆盖「并非...而是」变体(设计 bug)。**ch10 还有破折号 + 加粗严重超限**,**ch12 抽象空词暴增 43 次**(上限 5)。其余基本可用。

---

## 2. 章节字数 + Verdict 一览

| 章 | 字节 | 下限 | 真实引用 | TODO 占位 | reviewer Verdict |
|---|---|---|---|---|---|
| 07 AI 编程与数据分析 | 41 773 | 35 K | 12 | 6 | PASS |
| 08 AI 辅助写作 | 36 125 | 35 K | 14 | 5 | NEEDS_TARGETED_FIX |
| 09 AI Agent 与工作流 | 50 566 | 35 K | 23(17 unique)| 5 | NEEDS_TARGETED_FIX |
| 10 图像生成与多模态 | 35 622 | 35 K | 12(9 unique) | 9 | **NEEDS_REWRITE** |
| 11 AI 作为研究助理 | 48 735 | 40 K | 16 | 5 BibTeX + 4 HTML | PASS |
| 12 AI 辅助项目管理 | 40 595 | 40 K | 10 | 9 | NEEDS_TARGETED_FIX |
| 13 AI 作为领域专家 | 55 413 | 40 K | 13 | 4 | NEEDS_TARGETED_FIX |
| 14 AI 作为独立行动者 | 43 835 | 40 K | 14 | 7 | PASS |
| 15 伦理与治理 | 45 511 | 40 K | 14(15 occ) | 4 HTML | NEEDS_TARGETED_FIX |
| 16 完整科研工作流 | 37 102 | 30 K | 13 | 5 HTML(无 BibTeX TODO) | PASS |
| 17 终章 | 32 662 | 30 K | 13 | 6 | NEEDS_TARGETED_FIX |
| 18 附录 | 53 274 | 25 K | 23(39 occ) | 14 HTML | PASS |
| **合计** | **521 213** | — | **177** unique cites | **74** TODO | 5 PASS / 6 FIX / 1 REWRITE |

字数全部达标,体量约为 ch04 基线(36.9K)的 14 倍,新增约 339K 字符的学术深论。

---

## 3. 全 12 章 Blocklist 实测

```
章   字节   破折号 加粗  你   让我们 不是XY  抽象  元评  就像
配额  -      ≤5    ≤10  ≤20  =0    ≤1     ≤5   ≤1   ≤1
07   41773  4     0    0    0     14*    4    1    0
08   36125  0     0    0    0     1      3    0    0
09   50566  0     4    0    0     6*     2    0    0
10   35622  41**  65** 3    0     2*     8*   1    0
11   48735  0     2    1    0     17*    3    1    0
12   40595  0     7    2    0     8*     43** 0    0  + 这正是×2
13   55413  0     9    0    0     5*     4    0    0
14   43835  0     7    1    0     1      2    1    0
15   45511  2     7    0    0     11*    2    0    0
16   37102  0     10   0    0     4*     2    0    0  + 这正是×3
17   32662  4     5    0    0     11*    3    0    0
18   53274  3     0    1    0     1      2    0    0

* = 单条违规;** = 严重违规(实测 > 上限 ×3,触发 NEEDS_REWRITE)
```

### 系统性违规(全章批量,需要锁包级修补)

**问题 A — 「不是/并非 X,而是 Y」对仗超限(11/12 章违规)**

锁包 blocklist 第 5 条要求 ≤ 1/章。reviewer 单独扫时只查到部分(因为 grep 只用「不是」原文,未覆盖「并非」变体)。完整 grep `(并非|不是)[^,。;]+[,,]而是` 实测:

| 等级 | 章 | 倍数 |
|---|---|---|
| 极重 | ch11 (17×), ch07 (14×), ch15 (11×), ch17 (11×) | 11-17× |
| 重 | ch12 (8×), ch09 (6×), ch13 (5×), ch16 (4×) | 4-8× |
| 中 | ch10 (2×) | 2× |
| at limit | ch08, ch14, ch18 | 1× |

**根因**:锁包 AI-tells-blocklist.md §A 第 5 条的 `检测` 命令是 `grep -oE "不是[^,。]+[,,]而是"`,没匹配「并非」开头变体。author agent 在 Phase 3 e2 self-check 时用了同一个命令,所以全部漏检。

**问题 B — ch10 破折号 + 加粗严重超限**

破折号 41(8.2×)+ 加粗 65(6.5×)。**唯一被 reviewer 判 NEEDS_REWRITE 的章**。VOICE-academic 表述里允许加粗用于「首次术语 + 全章核心论断 ≤ 3」,实际是用作「金句锚定」滥用。

**问题 C — ch12 抽象空词暴增**

「关键 14 + 真正 12 + 核心 6 + 本质 6 + 根本 5 = 43」(8.6×)。属单章 voice 病。

**问题 D — 「这正是」自指元话**(锁包 blocklist 第 15 条,上限 0)

- ch12:2 处
- ch16:3 处

### 其他单章 voice 偏离(reviewer 已具体定位)

- ch08:「在/当」开头句 15 处(上限 5),中英对照在 5 段超限
- ch09:cross-reference-contract.md 写「ch04 §自动化偏见」,但 ch04 实际没这个节(契约表本身错)
- ch17:章首 / 结构复述里写「part 2 = ch07-10、part 3 = ch11-15」,与 _quarto.yml 实际 part 2 = ch05-10 / part 3 = ch11-16 不符
- ch11:callout-warning 标题「## 训练窗口期一旦关闭,补救成本极高」是命题句而非名词短语
- ch13/ch16/ch18:术语漂移「认知卸载」(应为「认知外包」)

---

## 4. 引用 Hygiene

- **真实引用**:全 12 章共 177 处引用,涉及约 25 个 unique BibTeX key,**全部存在于 references.bib**
- **TODO 占位**:74 处(BibTeX `[@TODO-...]` + HTML `<!-- TODO -->` 合计),分布合理
- **references.bib 改动**:**0**(全程未被任何章节 commit 触动 — citation-policy 硬约束生效 ✓)
- **可疑伪造**:**0**

引用 hygiene 是本次工作最干净的维度。

---

## 5. 跨章 Coherence

- 锚点声明数:35(全 12 章合计,`{#sec-...}`)
- 锚点引用数:33(全 12 章合计,`@sec-...`)
- **broken cross-refs:0**(comm -23 实测无引用未声明的锚点)
- 未被引用的孤立锚点:2(`#sec-ra-training-cost`、`#sec-actor-concept-boundary` — 合法,reserved 待将来引用)

跨章一致性是本次工作另一个干净的维度,锁包 + 契约表机制有效。

---

## 6. 待人工补的内容(给作者)

74 处 TODO 占位待作者后续手工填,分类:

- **BibTeX 占位**(约 50 处):需作者核实文献后追加到 references.bib
  - 高频缺失:Argyle 2023、Horton 2023、Aher 2023、Park 2023(硅样本经典文献)
  - Polanyi 1958/1966、Schön 1983、Vlastos 1991(经典哲学/教育学)
  - 期刊政策原文(NeurIPS / ICML / NSF / NIH 2024-2025)
  - 中文学界政策(教育部、各大学)
- **作者亲身经验**(约 24 处 HTML TODO):需作者填具体研究项目案例
  - 「让 AI 帮你写代码后悔」「跨学科入门」「基金申请 AI 边界」「硅样本反例」「课题组规范」等

---

## 7. 修补建议(可选下一轮工作)

如果决定再做一轮 fix:

### Wave A:全 12 章 systematic fix(15-20 分钟并行)
- 修锁包 grep 命令(把「不是」改为「(并非|不是)」)
- 12 个 author 各 dispatch 一次,任务为「按 reviewer 报告 + 全 12 章 blocklist 实测表,定向修复」
- 修复目标:全 12 章「不是/并非 X 而是 Y」≤ 1;ch12 抽象词 ≤ 5;ch12+ch16 「这正是」= 0;ch10 破折号 ≤ 5、加粗 ≤ 10
- 顺修:契约表 ch04 节名错(ch09 涉及)、ch17 part 框架错、4 章「认知卸载」统一

### Wave B:ch10 重写(30 分钟单 author)
- ch10 只有 NEEDS_REWRITE,需要更深的整改 — 单 author 重做 Phase 3 整章

### Wave C:留给作者
- 74 处 TODO 占位由作者填

---

## 8. Phase 0 锁包修订建议(如再用)

- AI-tells-blocklist.md §A 第 5 条 grep 命令改为 `grep -oE "(并非|不是)[^,。;]+[,,]而是"`
- 增加「这种 / 那种 X 不在于 ... 而在于 ...」变体检测
- chapter-author.md Phase 3 e2 self-check:跑 grep 后,若 ≥80% 配额触发,自动调用 applying-voice 做该节修订;不只是「停下不进下一节」
- cross-reference-contract.md 第 1 行 ch07 必须呼应栏:「ch04 §自动化偏见」改为「ch04 §AI 辅助 vs AI 替代」(line 168-173)— 节名实际错,且全书无「§自动化偏见」节

---

## 9. 决策点

请你决定下一步:

- **(a) Wave A + Wave B**:再做一轮 systematic fix + ch10 重写,然后再 review。预计 30-45 分钟并行。
- **(b) 只做 Wave B(只重写 ch10)**:其余 11 章接受为「v0.2 草稿」,后续手改。
- **(c) 全部接受为 v0.2,锁定**:把 74 处 TODO 留给作者手工补,本次工作结束;blocklist 系统性违规留作 known issue。
- **(d) 你具体指明要修哪几条**:我按你的指令选择性修。
