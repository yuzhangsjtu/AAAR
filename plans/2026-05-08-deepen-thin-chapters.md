# 深度扩写 ch07-18 — 实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 把 ch07-18 共 12 章从 9-16K 的 AI 起草薄稿扩写为 35K+ 的学术深论稿,产出 5 件锁包 + 12 章新稿,系统性剥离 18 项 AI 文本特征。

**Architecture:** Phase 0 主线顺序产 5 件锁包 + 改造 2 个 agent + 1 个 skill;Phase 1-3 按"4+5+3"分批,每批以单条主线消息并行调用 N 个 chapter-author agent,完成后并行触发 N 个 chapter-reviewer agent;每批后主线汇总 REVIEW + 跑 grep 验证 + Quarto check + 用户签字门;Final pass 全书 coherence 扫。

**Tech Stack:** Claude Code 原生 (Agent / Skill 工具),Quarto,Git,既有 chapter-author + chapter-reviewer agent + chapter-template / applying-voice / finding-citations / checking-coherence skill,无新增运行时依赖。

**Spec:** `specs/2026-05-08-deepen-thin-chapters-design.md`

---

## 任务总览

### Phase 0:锁包 + 工具改造(主线顺序)

1. Task 0.1:写 `VOICE-academic.md`
2. Task 0.2:写 `AI-tells-blocklist.md`
3. Task 0.3:写 `chapter-template-academic.md`
4. Task 0.4:写 `citation-policy.md`
5. Task 0.5:写 `cross-reference-contract.md`(读全 12 个 ideas 文件后建表)
6. Task 0.6:改造 `chapter-author` + `chapter-reviewer` agent + `applying-voice` skill,让它们识别学术模式
7. Task 0.7:锁包整体集成校验 + git tag `lock-pack-v1`

### Phase 1:ch07-10 并行扩写(4 章)

8. Task 1.1:并行 dispatch 4 个 chapter-author + 4 个 chapter-reviewer
9. Task 1.2:汇总 REVIEW + grep blocklist + Quarto check + 跨章 coherence
10. Task 1.3:用户验收门 → 通过 / 锁包微调重做

### Phase 2:ch11-15 并行扩写(5 章)

11. Task 2.1:并行 dispatch 5 个 author + 5 个 reviewer
12. Task 2.2:汇总 + grep + Quarto + coherence
13. Task 2.3:用户验收门

### Phase 3:ch16-18 并行扩写(3 章)

14. Task 3.1:并行 dispatch 3 个 author + 3 个 reviewer
15. Task 3.2:汇总 + grep + Quarto + coherence
16. Task 3.3:用户验收门

### Final Pass

17. Task F.1:全书 12 章 checking-coherence 扫 + 综合 grep 报告
18. Task F.2:项目完成签字 + git tag `ch07-18-deepened-v1`

---

## Phase 0 — 锁包 + 工具改造

### Task 0.1:写 VOICE-academic.md

**Files:**
- Create: `/Users/guliufang/MiniMax/AAAR/VOICE-academic.md`

- [ ] **Step 1:写 VOICE-academic.md**

文件完整内容(直接 Write):

```markdown
# 学术写作风格指南(VOICE-academic)

> 适用于 ch07-18。优先级高于 VOICE.md。
> 设计依据:specs/2026-05-08-deepen-thin-chapters-design.md
> 日期:2026-05-08

## 0. 适用范围与与 VOICE.md 的关系

VOICE.md 描述 ch01-04 的对话式叙述体,该风格已确认为 AI 起草而非作者真实写作声音。本文件不继承 VOICE.md 的具体频次配额,在所有数值约束上独立设置,且普遍比 VOICE.md 收紧。

ch07-18 的章节 author / reviewer agent 必须以本文件为风格唯一裁判;VOICE.md 仅作为"应避免延续的对话式特征清单"参考。

## 1. 主语人称

- **第三人称为主**:研究者 / 学者 / 作者 / 读者 / 学生 / 教师 / 评议人,根据语境选择
- **"你"上限 ≤ 20/章**(ch04 = 241,VOICE.md 默认极高)
- **"我"上限 ≤ 5/章**,仅在表达明确的作者主张时用
- **"我们"召唤式禁用**:不出现"让我们……""我们一起……""下面我们要……"
- **被动语态合理使用**,但不刻意堆砌(避免行文僵硬)

## 2. 句长与节奏

- 以**长复合句**为主,通过主从从句、并列结构、修饰短语展开论证
- 单句平均长度 50-80 字(中文计),长句(>80 字)允许占 40%
- 短句仅在结论性命题处使用,作为论证段的收束
- **禁排比堆砌**:"不仅……更……还……"三联禁;两项并列(A 与 B)允许
- **禁短促对仗**:"A 不是 X,而是 Y"上限 1/章

## 3. 标点与排版

- **破折号 ——** 上限 5/章。仅用于真正的插入语中断(打断当前句意);并列扩展用顿号;解释关系用"即""亦即""也就是";独立观点改用独立句
- **加粗 `**...**`** 上限 10/章。仅用于:首次出现的关键术语(每章 ≤ 7);全章核心论断锚定(≤ 3)
- **省略号 `……`** 仅在引用截断处使用
- **括号** 中文圆括号「(……)」用于附加说明;英文括号 `(…)` 仅用于引用文献(如`[@key, p. 12]`)
- **引号** 「」(中文方角)用于术语首次提示;""(中文弯引)用于直接引用

## 4. 学术腔标记的克制

- "需要指出的是 / 应当注意 / 可以认为 / 不难看出"等学术腔标配合计 ≤ 2/章
- "这意味着 / 换句话说 / 值得注意的是 / 事实上 / 实际上"等元评论合计 ≤ 1/章
- "总而言之 / 综上所述 / 简而言之"封闭式总结仅在章末出现 1 次,正文章节内禁用
- "首先 / 其次 / 再次 / 最后"枚举式过渡禁用,改写成嵌入式过渡

## 5. 抽象与具体的平衡

- "核心 / 关键 / 本质 / 根本 / 真正"等空抽象词合计 ≤ 5/章。能用具体名词替代时优先具体
- 任何抽象论断后必须紧跟具体支撑(真实研究 / 真实事件 / 具体场景三选一)
- 比喻类比慎用:全章比喻 ≤ 2 处,且应直接服务于专业概念解释,不堆叠
- "就像 X 一样"整齐比喻句式上限 1/章

## 6. 段落结构

- 段落平均 4-7 句;论证段允许 8-12 句
- **不写"无 anchoring"的纯定义段**:任何抽象命题段后必须有具体段紧跟
- 段间过渡用嵌入式连接(在新段第一句中带出与上段的关系),不用元话过渡词

## 7. 章节结构

- **章首**:研究问题陈述 / 经验观察陈述 / 理论性引入。**不再用"年份+真实事件"叙事开篇**(那是 VOICE.md 的对话体习惯)
- **章末**:论证性收束。把本章核心命题、它在全书脉络中的位置、它留下的开放问题三件事说清。**不用"原则清单"列表收束**;**不用"下一章我们要……"召唤过渡**(可以提一句下章主题,但作为论证延伸,不作为转场广告)
- 章末节字数 ≥ 800
- 二级节数 ∈ [4, 6];每章三级节(`### 标题`)总数 ≥ 8

## 8. Callout 使用

- 全章 callout 总数 ≤ 2(VOICE.md 是 4-7,差异巨大)
- callout 标题改名词短语:"认知外包的隐性成本"✓;"警惕认知外包"✗
- callout 内容应是独立的概念框 / 数据表 / 测试模板,不是"提醒读者注意"的口语化插入
- 类型:`callout-note`(术语澄清 / 侧栏定义)与 `callout-tip`(可操作模板)优先;`callout-warning` 慎用

## 9. 学术密度硬性下限

- 真实学术引用(BibTeX 已存在 key)≥ 8/章
- TODO 引用占位 ≥ 4/章(留给作者后续手动核实补充)
- 每个二级节具体案例(真实研究 / 真实事件 / 具体场景三选一)≥ 2 个
- 每个二级节内三级节(`### 标题`)≥ 1 个

## 10. 字数下限

- ch07-10:≥ 35K 字节
- ch11-15(part 3 核心):≥ 40K 字节
- ch16-18:≥ 30K 字节(整合 / 终章 / 附录,允许略短)

## 11. 风格判定 checklist(给 reviewer 用)

判断 ch07-18 的某段是否符合学术体,优先检查:

- [ ] 第三人称为主,"你""我们"未越上限
- [ ] 破折号、加粗、空抽象词均在配额内
- [ ] 论证段后紧跟具体例子(无悬空抽象段)
- [ ] 学术腔元评论(应当注意 / 这意味着 / ……)未超上限
- [ ] callout 标题为名词短语,callout 总数 ≤ 2
- [ ] 章首未用"年份+故事"开篇
- [ ] 章末未用"原则清单 + 引下章"收束,改为论证性收束
- [ ] 真实引用 + TODO 占位均达下限
- [ ] 二级节数 ∈ [4, 6],三级节 ≥ 8
- [ ] 字数达下限
- [ ] 与 AI-tells-blocklist.md 18 条无冲突
```

- [ ] **Step 2:验证文件已落盘**

Run: `wc -l /Users/guliufang/MiniMax/AAAR/VOICE-academic.md`
Expected: ≥ 100 lines

- [ ] **Step 3:Commit**

```bash
git add /Users/guliufang/MiniMax/AAAR/VOICE-academic.md
git commit -m "lock: VOICE-academic.md (ch07-18 学术体风格指南)"
```

---

### Task 0.2:写 AI-tells-blocklist.md

**Files:**
- Create: `/Users/guliufang/MiniMax/AAAR/AI-tells-blocklist.md`

- [ ] **Step 1:写 AI-tells-blocklist.md**

文件完整内容(直接 Write):

```markdown
# AI 文本特征禁忌清单(AI-tells-blocklist)

> 适用于 ch07-18。reviewer agent 必须逐条扫描并报告每条违规。
> 设计依据:specs/2026-05-08-deepen-thin-chapters-design.md
> 日期:2026-05-08

每条结构化为:`{编号. 模式名}` / `反例` / `改写示范` / `每章上限 / 检测命令`

---

## A. 数据驱动 8 条(基于 ch04 + ch07-17 实测频次)

### 1. 破折号 —— 滥用

- **反例**:「AI 替你做的——可以是思考本身。这意味着——你失去的不只是文字。」
- **改写示范**:「AI 替你做的可以是思考本身。这一替代意味着,作者失去的不只是文字。」
- **上限**:≤ 5/章
- **检测**:`grep -o "——" outline/XX-*.md | wc -l`

### 2. 加粗 `**...**` 滥用

- **反例**:每节末用 `**……**` 升华一句金句
- **改写示范**:首次术语出现时加粗(如 `**认知外包(cognitive offloading)**`),全章核心论断 ≤ 3 处加粗,其余去粗
- **上限**:≤ 10/章
- **检测**:`grep -o '\*\*[^*]*\*\*' outline/XX-*.md | wc -l`

### 3. "你"频率过高

- **反例**:「你需要……你应该……你会发现……」(每段至少一次)
- **改写示范**:替换为"研究者""作者""学者""读者";被动语态;泛指主语("一个 PI 在……时,常常需要……")
- **上限**:≤ 20/章
- **检测**:`grep -o "你" outline/XX-*.md | wc -l`

### 4. "让我们"召唤式

- **反例**:「让我们看一下……」「让我们回到本章开头……」「让我们一起来探索……」
- **改写示范**:删去召唤词;直接进入论述,如「本章开头的场景值得回顾」
- **上限**:0(禁用)
- **检测**:`grep "让我们" outline/XX-*.md | wc -l`

### 5. "A 不是 X,而是 Y" 对仗

- **反例**:「关键不在效率,而在判断。」
- **改写示范**:「效率并非关键所在,真正紧要的是判断。」或独立两句:「效率提升当然存在。但判断力的退化是更值得忧虑的事。」
- **上限**:≤ 1/章
- **检测**:`grep -oE "不是[^,。]+[,,]而是" outline/XX-*.md | wc -l`

### 6. "核心 / 关键 / 本质 / 根本 / 真正"空抽象

- **反例**:「这件事的核心在于,关键的本质是,真正的根本要点……」
- **改写示范**:替换为具体名词(如「这一现象的机制在于……」「这种判断的边界条件是……」);整章合计 ≤ 5 次
- **上限**:合计 ≤ 5/章
- **检测**:`grep -oE "(核心|关键|本质|根本|真正)" outline/XX-*.md | wc -l`

### 7. 元评论标记

- **反例**:「这意味着……」「换句话说……」「值得注意的是……」「事实上,……」「实际上,……」
- **改写示范**:删去元评论引导,直接给出后半句的内容
- **上限**:合计 ≤ 1/章
- **检测**:`grep -oE "(这意味着|换句话说|值得注意的是|事实上|实际上)" outline/XX-*.md | wc -l`

### 8. "就像 X 一样" 整齐比喻

- **反例**:「就像运动员每次累了让别人替他跑一样,研究者每次想不出来让 AI 替他想……」
- **改写示范**:把比喻嵌入论证,不用 "就像 X 一样" 结构;或干脆删去比喻直接论证
- **上限**:≤ 1/章
- **检测**:`grep -oE "就像[^,。]+一样" outline/XX-*.md | wc -l`

---

## B. 经验补充 10 条

### 9. 中英对照术语过密

- **反例**:「嵌入(embedding)、注意力(attention)、上下文(context)三个概念……」(三词联缀加双语)
- **改写示范**:同一术语首次出现给 1 次中英对照,后续单用中文或英文均可
- **上限**:同一段内中英对照次数 ≤ 1
- **检测**:reviewer 人工扫描

### 10. 学术腔元评论标配

- **反例**:「需要指出的是……」「应当注意……」「可以认为……」「不难看出……」
- **改写示范**:删去引导,直接陈述;若必须引导,优先用学术化的"研究表明""现有证据显示"
- **上限**:合计 ≤ 2/章
- **检测**:`grep -oE "(需要指出的是|应当注意|可以认为|不难看出)" outline/XX-*.md | wc -l`

### 11. 时间状语过频前置

- **反例**:「在 X 时,Y。当 Z 时,W。在……过程中,……」(连续 3+ 段以"在/当 X 时"开头)
- **改写示范**:把时间状语后置或嵌入句中
- **上限**:以"在""当"开头的句子 ≤ 5/章
- **检测**:reviewer 抽样扫描

### 12. "首先 / 其次 / 再次 / 最后"枚举

- **反例**:「首先,……;其次,……;再次,……;最后,……」
- **改写示范**:嵌入式过渡。第二点用"另一方面",第三点用"除此之外",第四点用"还需要补充的是"
- **上限**:0(禁用)
- **检测**:`grep -E "(首先|其次|再次)" outline/XX-*.md | wc -l`

### 13. 封闭式总结

- **反例**:「总而言之,……;综上所述,……;简而言之,……」
- **改写示范**:章节内部不出现;章末仅允许 1 次,且优先用"本章的论证可归结为"等更具体的引导
- **上限**:章节内 0;章末 ≤ 1
- **检测**:`grep -E "(总而言之|综上所述|简而言之)" outline/XX-*.md | wc -l`

### 14. 节末加粗"金句"收尾

- **反例**:节末用 `**……**` 升华一句作金句
- **改写示范**:节末用普通陈述句结束,把论证重心放在内容而非视觉强调
- **上限**:0(禁用)
- **检测**:reviewer 检查每个 `## ` 节末段是否含 `**...**` 收尾

### 15. 自指元话

- **反例**:「这正是 X 想说的」「这正是 X 的意义所在」「这就是为什么 X」
- **改写示范**:删去自指元话,直接陈述
- **上限**:0(禁用)
- **检测**:`grep -E "(这正是|这就是为什么)" outline/XX-*.md | wc -l`

### 16. 公式化转折

- **反例**:「真正的 X 在于……」「问题的关键是……」「事情的关键就在这里」
- **改写示范**:把转折嵌入论述的具体内容,不用公式化引导
- **上限**:0(禁用)
- **检测**:`grep -E "(真正的[^,。]{0,8}在于|问题的关键)" outline/XX-*.md | wc -l`

### 17. 整齐 N 项枚举(为对称凑数)

- **反例**:「三个特征:特征一……特征二……特征三……」(明明两点能讲清,凑成三)
- **改写示范**:点数随论述实际需要,2 项就 2 项,7 项就 7 项;不为对称凑数
- **上限**:reviewer 主观判断,凡疑似为对称凑数的 N 项枚举均报告
- **检测**:reviewer 抽样判断

### 18. callout 标题用祈使式

- **反例**:`## 警惕认知外包` / `## 注意:AI 不是万能的`
- **改写示范**:`## 认知外包的隐性成本` / `## AI 能力边界的若干误解`
- **上限**:0(祈使式标题禁用)
- **检测**:reviewer 检查每个 callout 标题

---

## C. reviewer 使用方式

reviewer agent 在 REVIEW-chXX.md 的 `§ B Blocklist` 部分须包含:

```
| 编号 | 模式 | 实测次数 | 上限 | 通过 | 违规位置(file:line + 原文) |
| 1 | 破折号 —— | N | 5 | ✓/✗ | ... |
| 2 | 加粗 ** | N | 10 | ✓/✗ | ... |
... 全 18 条
```

任意一条 ✗ → 章节 NEEDS_TARGETED_FIX(局部超限可修)
多条 ✗(≥ 3 条)或单条严重超限(实测 > 上限 ×3)→ NEEDS_REWRITE
```

- [ ] **Step 2:验证文件已落盘**

Run: `wc -l /Users/guliufang/MiniMax/AAAR/AI-tells-blocklist.md`
Expected: ≥ 150 lines

- [ ] **Step 3:Commit**

```bash
git add /Users/guliufang/MiniMax/AAAR/AI-tells-blocklist.md
git commit -m "lock: AI-tells-blocklist.md (18 条 AI 文本特征禁忌)"
```

---

### Task 0.3:写 chapter-template-academic.md

**Files:**
- Create: `/Users/guliufang/MiniMax/AAAR/chapter-template-academic.md`

- [ ] **Step 1:写 chapter-template-academic.md**

文件完整内容:

```markdown
# 学术章节结构骨架(chapter-template-academic)

> 适用于 ch07-18。author agent 必须按此结构组织章节。
> 设计依据:specs/2026-05-08-deepen-thin-chapters-design.md

## 1. 整体结构

```
# {章节标题}

{无标题引入段:1-2 段,提出本章要回答的研究问题或核心命题}

## {二级节 1:概念框架 / 定义性引入}
### {三级节 1.1}
### {三级节 1.2}

## {二级节 2:核心论证}
### {三级节 2.1}
### {三级节 2.2}
### {三级节 2.3}

## {二级节 3:扩展应用 / 反例}
### {三级节 3.1}
### {三级节 3.2}

## {二级节 4:边界条件 / 局限性}
### {三级节 4.1}
### {三级节 4.2}

## {二级节 5:论证性收束}
{800+ 字的收束节,把本章命题与全书脉络的关系说清}
```

## 2. 硬性下限

- 二级节数 ∈ [4, 6](过少会让单节过长,过多会让结构碎)
- 三级节总数 ≥ 8
- 章末收束节字数 ≥ 800
- 章节总字数(中文 + 标点 + 空白)≥ 35000 字节(part 3 核心 11-15 ≥ 40000)

## 3. 章首

**禁用**(均为 VOICE.md 习惯,与学术体冲突):

- "1978 年,心理学家 X 和 Y 发表了……"(年份+真实事件叙事)
- "上一章我们讨论了 X,本章要讨论 Y"(过渡式开篇)
- "假设你正在做一项跨国比较研究"(场景代入式)

**采用**:

- 研究问题陈述:"X 与 Y 的关系如何?这一问题在……"
- 经验观察:"在 AI 工具普及之后,Z 现象在……开始出现"
- 定义性引入:"本章讨论的 X,在文献中通常指……"

引入段后直接进入二级节 1。无需"本章结构如下:第一节……"式的章节内目录。

## 4. 二级节标题

- 用名词短语,不用问句、不用祈使句
- 不用"AI 在 X 中的应用 / AI 与 X 的关系"等模板化标题
- 优先用具体的概念命名(如"硅样本作为方法论假设""AI 同行评议的失败模式")

## 5. 章末收束节

收束节是论证性的,不是清单式的。需要包括:

1. **本章核心命题再陈述**(以更精炼形式重复一次)
2. **在全书脉络中的位置**(引用前置章节的对应论点 + 后续章节将如何延伸)
3. **本章未解决 / 留待开放的问题**(以学术诚实的态度承认本章论证的边界)

**禁用**:

- "回顾本章原则:1. ……2. ……"(数字编号清单)
- "下一章我们要讨论……"(召唤式过渡)
- "如果你只从本章带走一个认知,……"(对话式提示)

## 6. Callout 配额

- 全章 ≤ 2 个 callout
- 类型优先级:`callout-note` > `callout-tip` > `callout-warning`(后者慎用)
- 标题为名词短语(见 AI-tells-blocklist 第 18 条)
- 内容应是独立的概念框 / 数据表 / 测试模板;不是"提醒读者注意"的对话式插入

## 7. 引用与交叉引用

- 章内引用其他章节用 `@sec-{anchor-id}` 语法
- 引用 BibTeX 用 `[@key]`,key 必须存在于 references.bib;不存在用 `[@TODO-描述性 slug]`
- 章节首次出现的关键术语在标题或正文中加 `{#sec-{anchor-id}}` 锚点
- 详见 cross-reference-contract.md
```

- [ ] **Step 2:验证文件已落盘**

Run: `wc -l /Users/guliufang/MiniMax/AAAR/chapter-template-academic.md`
Expected: ≥ 80 lines

- [ ] **Step 3:Commit**

```bash
git add /Users/guliufang/MiniMax/AAAR/chapter-template-academic.md
git commit -m "lock: chapter-template-academic.md (ch07-18 结构骨架)"
```

---

### Task 0.4:写 citation-policy.md

**Files:**
- Create: `/Users/guliufang/MiniMax/AAAR/citation-policy.md`

- [ ] **Step 1:写 citation-policy.md**

文件完整内容:

```markdown
# 引用政策(citation-policy)

> 适用于 ch07-18。author agent 必须遵守;reviewer agent 必须验证。
> 设计依据:specs/2026-05-08-deepen-thin-chapters-design.md

## 1. 硬约束

1. 所有引用语法只能是 `[@key]` 或 `[@key, p. NN]` 形式
2. key 必须存在于 `references.bib`(可由 finding-citations skill 验证)
3. 找不到合适已有 key 时,使用 `[@TODO-描述性 slug]` 占位(例:`[@TODO-llm-peer-review-2024]`)
4. **严禁伪造**:作者、年份、DOI、期刊名、页码、卷期号、章节标题。任何上述字段无法核实即用 TODO 占位
5. **严禁向 references.bib 添加任何新条目**(本期工作的引用占位由作者后续手动核实补充)

## 2. 数量下限

- **真实引用**(已存在于 BibTeX 的 key)≥ 8/章
- **TODO 占位** ≥ 4/章
- 引用应分布在多个二级节,不集中在某一节凑数

## 3. 引用质量

- 优先引用一手研究(原始论文 / 实证研究),不优先引用综述或 textbook
- 同一论点尽量引用 ≥ 2 个来源(单点引用易被质疑)
- 跨学科引用应来自该学科公认的核心期刊或著作

## 4. TODO 占位规范

TODO slug 应描述性,便于作者后续核实定位:

- ✓ `[@TODO-cognitive-offloading-meta-analysis-2023]`
- ✓ `[@TODO-llm-peer-review-empirical-2024]`
- ✗ `[@TODO]`(无信息)
- ✗ `[@TODO-1]`(无意义编号)

## 5. finding-citations skill 调用契约

author agent 在写每段需要证据的论点时:

1. 调用 `finding-citations` skill,提供论点描述
2. skill 在 references.bib 中搜索;返回:
   - `[@key]` 若找到合适已有 key
   - `[@TODO-slug]` 若未找到
3. author 直接把返回值嵌入 prose
4. **不允许** author 跳过 skill 自行编造 BibTeX key 或新增条目

## 6. reviewer 检查项

reviewer agent 在 REVIEW-chXX.md 的 `§ D 引用 hygiene` 须包含:

1. 真实引用计数 + 列出所有 key
2. TODO 占位计数 + 列出所有 slug
3. 对每个真实引用 key:`grep "@{key}" references.bib` 验证存在
4. 启发式扫:本次 commit 是否动了 references.bib(应为 0,违反第 1 节第 5 条)
5. 数量下限合规判定:真实 ≥ 8 + TODO ≥ 4 → ✓;否则 ✗
```

- [ ] **Step 2:验证文件已落盘**

Run: `wc -l /Users/guliufang/MiniMax/AAAR/citation-policy.md`
Expected: ≥ 60 lines

- [ ] **Step 3:Commit**

```bash
git add /Users/guliufang/MiniMax/AAAR/citation-policy.md
git commit -m "lock: citation-policy.md (引用政策与 TODO 规范)"
```

---

### Task 0.5:写 cross-reference-contract.md

**Files:**
- Read: `/Users/guliufang/MiniMax/AAAR/ideas/07-AI编程与数据分析.md` 至 `/Users/guliufang/MiniMax/AAAR/ideas/18-附录.md`(共 12 个文件)
- Read: `/Users/guliufang/MiniMax/AAAR/outline/07-*.md` 至 `/Users/guliufang/MiniMax/AAAR/outline/18-*.md`(已有薄稿,作为术语提取的参考)
- Create: `/Users/guliufang/MiniMax/AAAR/cross-reference-contract.md`

- [ ] **Step 1:读全 12 个 ideas 文件**

```bash
for f in 07 08 09 10 11 12 13 14 15 16 17 18; do
  echo "=== ideas/${f} ==="
  cat /Users/guliufang/MiniMax/AAAR/ideas/${f}-*.md
done
```

提取每章承诺定义的术语 / 框架 / 锚点。

- [ ] **Step 2:读全 12 个现有薄稿,补充术语提取**

```bash
for f in 07 08 09 10 11 12 13 14 15 16 17 18; do
  echo "=== outline/${f} ==="
  grep "^##" /Users/guliufang/MiniMax/AAAR/outline/${f}-*.md
done
```

- [ ] **Step 3:写 cross-reference-contract.md**

文件结构(直接 Write,table 内容根据 Step 1-2 提取的真实术语填充):

```markdown
# 章际交叉引用契约(cross-reference-contract)

> 适用于 ch07-18。author agent 跨章引用必须依此契约;reviewer agent 验证锚点存在性。
> 设计依据:specs/2026-05-08-deepen-thin-chapters-design.md

## 1. 契约表

| 章 | 标题 | 本章承诺定义的术语与锚点 ID | 允许引用的章节范围 | 必须呼应的前置 |
|---|---|---|---|---|
| 07 | AI 编程与数据分析 | "AI 编程三角色:补全员/对话员/Agent" `#sec-ai-coding-roles`;"prompt / skill / tool / MCP 抽象层级" `#sec-coding-abstraction-levels` | ch01-06 | ch04 §认知外包 |
| 08 | AI 辅助写作 | "AI 介入三层次:词句级/段落级/结构级" `#sec-writing-three-levels`;"先自己写差版再让 AI 改"原则 `#sec-write-first-then-ai` | ch01-07 | ch04 §写作认知过程 |
| 09 | AI Agent 与工作流自动化 | "Chatbot vs Agent 自主程度区分" `#sec-chatbot-vs-agent`;"Agent 失败模式:漂移/循环/截断/丢弃/级联" `#sec-agent-failure-modes` | ch01-08 | ch07 §AI 编程角色升级路径 |
| 10 | 图像生成与多模态 | "多模态三类任务:理解/生成/转换" `#sec-multimodal-three-tasks`;"图像生成四类合理场景" `#sec-image-gen-legitimate-uses` | ch01-09 | ch02 §锯齿 |
| 11 | AI 作为研究助理(RA Level) | "RA Level 三档信任校准" `#sec-ra-three-tiers`;"硅样本作为方法论假设" `#sec-silicon-sample-as-method` | ch01-10 | ch02 锯齿 / ch04 外包 |
| 12 | AI 辅助项目管理(Supervisor Level) | "Supervisor Level 三特征" `#sec-supervisor-three-features`;"苏格拉底问/对抗辩论/周期复盘"三种用法 `#sec-supervisor-three-modes` | ch01-11 | ch11 §RA Level 与本章对比 |
| 13 | AI 作为领域专家(Domain Expert) | "域专家任务三特征" `#sec-domain-expert-task-features`;"5 题测试模板" `#sec-five-question-test` | ch01-12 | ch02 锯齿 / ch11-12 角色递进 |
| 14 | AI 作为独立行动者(Agent Level) | "LLM-as-tool / -as-agent / -as-subject 三身份" `#sec-llm-three-identities`;"硅样本研究的论文写作底线" `#sec-silicon-paper-rules` | ch01-13 | ch11 §硅样本 / ch13 §AI 同行评议 |
| 15 | 伦理与治理(Governance Level) | "论文三种功能(总结/交流/发现)" `#sec-paper-three-functions`;"评价体系 proxy hacking" `#sec-proxy-hacking`;"个人能做/必须做清单" `#sec-individual-action-lists` | ch01-14 | ch04 / ch11-14 五级角色 |
| 16 | 一个完整的 AI 科研工作流 | "研究项目五阶段:酝酿/构建/执行/写作/传播" `#sec-five-phase-workflow`;"三种工作流模板(本科/博士/资深)" `#sec-three-workflow-templates` | ch01-15(全书) | ch07-15 工具+角色全栈 |
| 17 | 终章·AI 时代的研究者 | "GenAI 三定律:去用/思考不能外包/为产出负全责" `#sec-three-laws`;"五阶段研究者价值观清单" | ch01-16(全书) | 全书所有章 |
| 18 | 附录 | (附录类章节,主要承接,不承诺新术语) | ch01-17 | 全书所有章 |

## 2. 硬约束

- 章节中所有跨章引用必须使用契约表中已声明的锚点 ID
- 严禁前向引用未在表中声明的内容(防止 ch12 引用 ch15 还没定义的概念)
- 章节首次出现承诺锚点的标题必须加 `{#sec-{anchor-id}}` 后缀
  例:`## RA Level 三档信任校准 {#sec-ra-three-tiers}`
- 跨章引用语法:`@sec-ra-three-tiers`(Quarto 自动转跳转)

## 3. 跨章呼应密度

- 每章 ≥ 2 处具体的跨章呼应("第 X 章 §Y 提出的 Z 概念,在本章场景下……")
- 不允许笼统的"前面章节已讨论过"

## 4. reviewer 检查项

在 REVIEW-chXX.md 的 `§ C 跨章节连贯` 须包含:

1. 本章定义的所有锚点是否按契约表落地(grep `{#sec-` 验证)
2. 本章引用的所有 `@sec-` 标记是否在契约表中已被声明定义
3. 是否有前向引用违规(引用了表中尚未定义的锚点)
4. 跨章呼应数量(≥ 2 处)
```

- [ ] **Step 4:验证文件已落盘**

Run: `wc -l /Users/guliufang/MiniMax/AAAR/cross-reference-contract.md`
Expected: ≥ 50 lines

- [ ] **Step 5:Commit**

```bash
git add /Users/guliufang/MiniMax/AAAR/cross-reference-contract.md
git commit -m "lock: cross-reference-contract.md (ch07-18 章际锚点契约)"
```

---

### Task 0.6:改造 chapter-author + chapter-reviewer agent + applying-voice skill

**Files:**
- Modify: `/Users/guliufang/MiniMax/AAAR/.claude/agents/chapter-author.md`
- Modify: `/Users/guliufang/MiniMax/AAAR/.claude/agents/chapter-reviewer.md`
- Modify: `/Users/guliufang/MiniMax/AAAR/.claude/skills/applying-voice/SKILL.md`(若存在)

- [ ] **Step 1:读现有 applying-voice skill 定义**

```bash
ls /Users/guliufang/MiniMax/AAAR/.claude/skills/applying-voice/
cat /Users/guliufang/MiniMax/AAAR/.claude/skills/applying-voice/SKILL.md
```

记录其当前对 VOICE.md 的硬编码,以便正确替换为可参数化版本。

- [ ] **Step 2:改造 chapter-author agent — 在 Phase 1 加入"学术模式判定 + 锁包加载"**

在 `chapter-author.md` 的 `### Phase 1:Context 装配` 段(目前是 4 步)之后、Phase 1 checkpoint 之前,插入以下新步:

```markdown
4.5 **判定章节模式**:
   - 若章节编号 ∈ [01, 06] → `voice_mode = "narrative"`,主风格指南 = `VOICE.md`
   - 若章节编号 ∈ [07, 18] → `voice_mode = "academic"`,主风格指南 = `VOICE-academic.md`,且必须额外读取以下锁包文件:
     - Read 仓库根 `VOICE-academic.md`(若不存在 → abort)
     - Read 仓库根 `AI-tells-blocklist.md`(若不存在 → abort)
     - Read 仓库根 `chapter-template-academic.md`(若不存在 → abort)
     - Read 仓库根 `citation-policy.md`(若不存在 → abort)
     - Read 仓库根 `cross-reference-contract.md`(若不存在 → abort)
   - 把 `voice_mode` 与所有读到的锁包内容存入工作记忆,后续 phase 持续参照

Phase 1 checkpoint 增加一项:
- [ ] 若 academic 模式,所有 5 件锁包文件已读到内容
```

在 `### Phase 3:逐节扩写` 的 b 步("用 Skill 工具调用 applying-voice")改为:

```markdown
b. 用 Skill 工具调用 `applying-voice`,传入 `voice_file = $主风格指南`(narrative 模式传 VOICE.md;academic 模式传 VOICE-academic.md)
```

在 `### Phase 3:逐节扩写` 的 e 步增加 academic 模式专用 checkpoint:

```markdown
e2. **(academic 模式专用)每写完 2 节,做 blocklist 自查**:
   - Bash 跑 AI-tells-blocklist.md §A 8 条数据驱动检测命令(每个 grep 命令的目标文件设为 target)
   - 对超过 80% 配额的项,立即返回该节做 voice 调整,不进下一节
```

把 Phase 4 的 checking-coherence 步骤前增加引用契约校验:

```markdown
9.5 (academic 模式专用)**交叉引用契约校验**:
   - Grep target 中所有 `@sec-` 标记
   - 对每个标记,在 cross-reference-contract.md 中验证已被声明
   - 任一未声明 → Edit 修正(或改用普通文字描述,不强行链接)
```

在 Phase 5 commit message 模板调整:academic 模式 commit message 用 `draft: ch{编号} 学术深稿(v0.X)`。

- [ ] **Step 3:改造 chapter-reviewer agent — 加入 academic 模式扩展检查**

在 `chapter-reviewer.md` 的 `### Phase 1:独立读` 末尾增加:

```markdown
4.5 **判定章节模式**:
   - 若章节编号 ∈ [07, 18],额外 Read:VOICE-academic.md / AI-tells-blocklist.md / chapter-template-academic.md / citation-policy.md / cross-reference-contract.md
   - 任一缺失 → abort,提示锁包未就位
```

在 `### Phase 2:五项检查` 之后增加新节(成为六项):

```markdown
#### F. (academic 模式专用)Blocklist 18 条扫描

按 AI-tells-blocklist.md §C 给出的表格格式,逐条检测:

```
| 编号 | 模式 | 实测次数 | 上限 | 通过 | 违规位置 |
| 1 | 破折号 —— | N | 5 | ✓/✗ | 例:outline/13-...:42 「……——你失去……」 |
| 2 | 加粗 ** | N | 10 | ✓/✗ | ... |
... 全 18 条
```

8 条数据驱动用 grep 实测;10 条经验补充按 blocklist §B 中 reviewer 操作说明执行。

判定:
- 0 条违规 → blocklist PASS
- 1-2 条小幅超(≤ 上限 ×1.5)→ NEEDS_TARGETED_FIX
- 3+ 条违规或单条严重超(> 上限 ×3)→ NEEDS_REWRITE

#### G. (academic 模式专用)结构与字数

按 chapter-template-academic.md §2 验证:
- 二级节数 ∈ [4, 6]
- 三级节总数 ≥ 8
- 章末收束节字数 ≥ 800
- 章节字节数 ≥ 35000(part 3 核心 11-15 ≥ 40000)

任一项未达 → NEEDS_REWRITE

#### H. (academic 模式专用)引用与契约

按 citation-policy.md §6 + cross-reference-contract.md §4 验证:
- 真实引用数 ≥ 8 + TODO ≥ 4
- 本次 commit 未动 references.bib
- 所有 `@sec-` 引用在契约表中已声明
- 章节定义的锚点已落 `{#sec-...}`

任一未达 → NEEDS_TARGETED_FIX 或 NEEDS_REWRITE(看严重度)
```

把现有 `## 输出回调用方` 一行简报扩展为:

```
Reviewed ch<编号> ({mode}) — {N} issues ({M} blocking) — Verdict: {PASS|NEEDS_TARGETED_FIX|NEEDS_REWRITE}
```

- [ ] **Step 4:改造 applying-voice skill,接受 voice_file 参数**

修改 `applying-voice/SKILL.md`:

- 把所有硬编码 `VOICE.md` 路径替换为参数 `${voice_file}`
- 在 SKILL.md 顶部加入"Input parameters: voice_file (path to voice guide; default: VOICE.md)"
- 调用时若 voice_file 不存在 → abort,提示调用方传错路径

(具体改动取决于现有 SKILL.md 内容;Step 1 已读到内容后据实修改)

- [ ] **Step 5:验证 agent / skill 文件结构未损坏**

```bash
head -10 /Users/guliufang/MiniMax/AAAR/.claude/agents/chapter-author.md
head -10 /Users/guliufang/MiniMax/AAAR/.claude/agents/chapter-reviewer.md
head -10 /Users/guliufang/MiniMax/AAAR/.claude/skills/applying-voice/SKILL.md
```

Expected: 三个文件 frontmatter(`---` 分隔的 yaml 头)完整无破损。

- [ ] **Step 6:Commit**

```bash
git add /Users/guliufang/MiniMax/AAAR/.claude/agents/chapter-author.md \
        /Users/guliufang/MiniMax/AAAR/.claude/agents/chapter-reviewer.md \
        /Users/guliufang/MiniMax/AAAR/.claude/skills/applying-voice/
git commit -m "feat(agents): chapter-author + chapter-reviewer 支持 academic 模式;applying-voice 接受 voice_file 参数"
```

---

### Task 0.7:锁包整体集成校验 + git tag

**Files:**
- Read: 5 件锁包 + 2 个改造后的 agent + 1 个改造后的 skill

- [ ] **Step 1:校验所有锁包文件存在**

```bash
ls -la /Users/guliufang/MiniMax/AAAR/{VOICE-academic.md,AI-tells-blocklist.md,chapter-template-academic.md,citation-policy.md,cross-reference-contract.md}
```

Expected: 5 个文件全部 exists,大小 > 1KB。

- [ ] **Step 2:校验 agent 文件完整**

```bash
grep -c "^### Phase" /Users/guliufang/MiniMax/AAAR/.claude/agents/chapter-author.md
grep -c "^#### " /Users/guliufang/MiniMax/AAAR/.claude/agents/chapter-reviewer.md
```

Expected: chapter-author Phase 数 ≥ 5;chapter-reviewer 检查项数 ≥ 5(原 5 个 + 新增 3 个 academic 模式专用 = 8)。

- [ ] **Step 3:校验跨锁包一致性**

主线 Claude 自查(无命令,人工对照):

- VOICE-academic.md 的所有数值上限是否与 AI-tells-blocklist.md 完全一致(破折号 ≤ 5、加粗 ≤ 10、"你" ≤ 20 等)
- chapter-template-academic.md §2 字数下限是否与 VOICE-academic.md §10 一致
- cross-reference-contract.md 表中术语是否与 ideas/ 中的实际意图匹配

发现不一致 → 直接 Edit 修正不一致的那一份。

- [ ] **Step 4:Quarto check 现有项目是否仍能解析**

```bash
cd /Users/guliufang/MiniMax/AAAR && quarto check 2>&1 | tail -20
```

Expected: 不报错(因为我们没动 outline/ 中的内容,只新增了根目录的锁包文件,且 _quarto.yml 未变)。若报错,排查 .gitignore / _quarto.yml 是否需要把锁包文件标为非 chapter 内容。

- [ ] **Step 5:Git tag**

```bash
cd /Users/guliufang/MiniMax/AAAR && git tag lock-pack-v1
git log --oneline -10
```

Expected: 看到 lock-pack-v1 在最新 commit。

---

## Phase 1 — ch07-10 并行扩写(4 章)

### Task 1.1:并行 dispatch 4 个 chapter-author + 4 个 chapter-reviewer

**Files:**
- Modify: `/Users/guliufang/MiniMax/AAAR/outline/07-AI编程与数据分析.md`
- Modify: `/Users/guliufang/MiniMax/AAAR/outline/08-AI辅助写作.md`
- Modify: `/Users/guliufang/MiniMax/AAAR/outline/09-AI-Agent与工作流自动化.md`
- Modify: `/Users/guliufang/MiniMax/AAAR/outline/10-图像生成与多模态.md`
- Create: `/Users/guliufang/MiniMax/AAAR/REVIEW-ch07.md`
- Create: `/Users/guliufang/MiniMax/AAAR/REVIEW-ch08.md`
- Create: `/Users/guliufang/MiniMax/AAAR/REVIEW-ch09.md`
- Create: `/Users/guliufang/MiniMax/AAAR/REVIEW-ch10.md`

- [ ] **Step 1:为每章准备 author dispatch 提示**

提示模板(每章替换章号 / 标题 / ideas 路径 / target 路径):

```
任务:把 outline/{编号}-{标题}.md 改写为深度学术论述稿。

章节编号:{编号}
章节标题:{标题}
ideas 文件:ideas/{编号}-{标题}.md
target 文件:outline/{编号}-{标题}.md(覆写,不新建)
模式:academic

强制读取顺序:
1. ideas/{编号}-{标题}.md
2. VOICE-academic.md
3. AI-tells-blocklist.md
4. chapter-template-academic.md
5. citation-policy.md
6. cross-reference-contract.md
7. outline/{编号}-{标题}.md(既有薄稿,作为意图参考,不照抄)
8. outline/01-04 + outline/05-06(作为承上参考)

字数下限:35000 字节(若是 ch11-15 则 40000)
真实引用下限:8/章
TODO 占位下限:4/章

依次跑你的 5 个 phase。每个 phase 严守 checkpoint。完成后输出一行简报:
Drafted ch{编号} ({总行数} 行,{真实引用数} 真实引用,{TODO 数} 占位)
Commit: {hash 前 7 位}
```

- [ ] **Step 2:在单条主线消息中并行 dispatch 4 个 chapter-author agent**

主线 Claude 在一条 assistant message 里同时发出 4 个 Agent tool call:

```
Agent({subagent_type: "chapter-author", description: "draft ch07 academic", prompt: "<ch07 提示>"})
Agent({subagent_type: "chapter-author", description: "draft ch08 academic", prompt: "<ch08 提示>"})
Agent({subagent_type: "chapter-author", description: "draft ch09 academic", prompt: "<ch09 提示>"})
Agent({subagent_type: "chapter-author", description: "draft ch10 academic", prompt: "<ch10 提示>"})
```

- [ ] **Step 3:等 4 个 author 全部返回简报**

每个 author 的简报应包含:总行数、真实引用数、TODO 数、commit hash。
任一 author abort → 单独排查那一章(读 author 报错日志 → 或单独 retry,或绕开继续后 3 章先)。

- [ ] **Step 4:为每章准备 reviewer dispatch 提示**

提示模板:

```
任务:复核 outline/{编号}-{标题}.md 是否符合学术模式锁包要求。

章节编号:{编号}
draft 路径:outline/{编号}-{标题}.md
ideas 路径:ideas/{编号}-{标题}.md
模式:academic

按你的 Phase 1-3 流程跑。第二阶段必须包含 academic 模式专用的 §F (blocklist) / §G (结构字数) / §H (引用契约)。

输出 REVIEW-ch{编号}.md 到仓库根。完成后输出一行简报:
Reviewed ch{编号} (academic) — {N} issues ({M} blocking) — Verdict: {PASS|NEEDS_TARGETED_FIX|NEEDS_REWRITE}
```

- [ ] **Step 5:在单条主线消息中并行 dispatch 4 个 chapter-reviewer agent**

```
Agent({subagent_type: "chapter-reviewer", description: "review ch07", prompt: "<ch07 reviewer 提示>"})
Agent({subagent_type: "chapter-reviewer", description: "review ch08", prompt: "<ch08 reviewer 提示>"})
Agent({subagent_type: "chapter-reviewer", description: "review ch09", prompt: "<ch09 reviewer 提示>"})
Agent({subagent_type: "chapter-reviewer", description: "review ch10", prompt: "<ch10 reviewer 提示>"})
```

- [ ] **Step 6:等 4 个 reviewer 全部返回简报 + 验证 4 份 REVIEW 文件落盘**

```bash
ls -la /Users/guliufang/MiniMax/AAAR/REVIEW-ch{07,08,09,10}.md
```

Expected: 4 个 REVIEW 文件 exists,大小 > 2KB。

---

### Task 1.2:汇总 REVIEW + grep blocklist + Quarto check + 跨章 coherence

**Files:**
- Read: `REVIEW-ch07.md`, `REVIEW-ch08.md`, `REVIEW-ch09.md`, `REVIEW-ch10.md`

- [ ] **Step 1:读完 4 份 REVIEW**

主线 Claude 逐份读;为每章记录 verdict(PASS / NEEDS_TARGETED_FIX / NEEDS_REWRITE)。

- [ ] **Step 2:综合 grep blocklist 8 条数据驱动验证**

```bash
cd /Users/guliufang/MiniMax/AAAR/outline
echo "==== 破折号 ===="; for f in 07 08 09 10; do c=$(grep -o "——" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 5)"; done
echo "==== 加粗 ===="; for f in 07 08 09 10; do c=$(grep -o '\*\*[^*]*\*\*' ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 10)"; done
echo "==== 你 ===="; for f in 07 08 09 10; do c=$(grep -o "你" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 20)"; done
echo "==== 让我们 ===="; for f in 07 08 09 10; do c=$(grep -o "让我们" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 0)"; done
echo "==== A 不是 X 而是 Y ===="; for f in 07 08 09 10; do c=$(grep -oE "不是[^,。]+[,,]而是" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 1)"; done
echo "==== 核心/关键/本质/根本/真正 ===="; for f in 07 08 09 10; do c=$(grep -oE "(核心|关键|本质|根本|真正)" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 5)"; done
echo "==== 元评论 ===="; for f in 07 08 09 10; do c=$(grep -oE "(这意味着|换句话说|值得注意的是|事实上|实际上)" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 1)"; done
echo "==== 就像X一样 ===="; for f in 07 08 09 10; do c=$(grep -oE "就像[^,。]+一样" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 1)"; done
echo "==== 字节数 ===="; wc -c 07-*.md 08-*.md 09-*.md 10-*.md
```

任一章某项超上限,记录为该章的额外 fix 项(可能 reviewer 已发现,也可能未发现 → reviewer 漏检要在 reviewer 逻辑里反思)。

- [ ] **Step 3:Quarto check**

```bash
cd /Users/guliufang/MiniMax/AAAR && quarto render --to html 2>&1 | tail -50
```

Expected: 渲染无 error;warning 可记录但不阻塞。

- [ ] **Step 4:跨章 coherence 扫(主线主导,不调 sub-agent)**

```bash
cd /Users/guliufang/MiniMax/AAAR
echo "==== 锚点声明 ===="; grep -n "{#sec-" outline/0[7-9]*.md outline/10*.md
echo "==== 锚点引用 ===="; grep -n "@sec-" outline/0[7-9]*.md outline/10*.md
```

主线核对每个 `@sec-` 引用对应的 `{#sec-…}` 是否真的存在(在本批 4 章 + 既有 ch01-06 中)。
未匹配的引用记为跨章 coherence 问题。

- [ ] **Step 5:写汇总报告 PHASE1-SUMMARY.md**

```bash
cat > /Users/guliufang/MiniMax/AAAR/PHASE1-SUMMARY.md
```

内容:每章 verdict / 字数 / 真实引用数 / TODO 数 / blocklist 8 条实测 / 跨章问题清单 / 主线建议(全过 / 局部修补 / 整章重做)。

- [ ] **Step 6:Commit 汇总报告**

```bash
git add /Users/guliufang/MiniMax/AAAR/PHASE1-SUMMARY.md
git commit -m "review: Phase 1 (ch07-10) 汇总报告"
```

---

### Task 1.3:用户验收门 → 通过 / 锁包微调重做

- [ ] **Step 1:把 PHASE1-SUMMARY.md 提交给用户**

主线对话中告知:Phase 1 已完成,4 章新稿 commit 在 git log,REVIEW + 汇总在仓库根。请用户:
- 抽样读 1-2 章全文(建议:从 verdict NEEDS_TARGETED_FIX 中挑一章 + PASS 中挑一章)
- 给出最终判定:全过 / 锁包微调后重做 / 整批拒收

- [ ] **Step 2:根据用户判定分支处理**

- 用户"全过":进入 Phase 2
- 用户"锁包微调":主线根据用户具体调整指令 Edit 锁包,git tag `lock-pack-v2`,然后回到 Task 1.1 重做 Phase 1
- 用户"整批拒收":回到主对话,深入诊断锁包根本问题,可能需要返回 spec 阶段

---

## Phase 2 — ch11-15 并行扩写(5 章)

### Task 2.1:并行 dispatch 5 个 author + 5 个 reviewer

**Files:**
- Modify: `outline/11-AI作为研究助理.md` 至 `outline/15-伦理与治理.md`(共 5 个)
- Create: `REVIEW-ch11.md` 至 `REVIEW-ch15.md`(共 5 个)

- [ ] **Step 1:为 ch11-15 准备 author 提示**

按 Task 1.1 Step 1 模板,为 ch11-15 各产出一份。注意:

- ch11-15 字数下限为 40000(part 3 核心)
- ch11-15 必须按 cross-reference-contract.md 表中"必须呼应的前置"章节做 ≥ 2 处具体跨章呼应

- [ ] **Step 2:在单条主线消息中并行 dispatch 5 个 chapter-author**

```
Agent({subagent_type: "chapter-author", description: "draft ch11 academic", prompt: "<ch11 提示>"})
Agent({subagent_type: "chapter-author", description: "draft ch12 academic", prompt: "<ch12 提示>"})
Agent({subagent_type: "chapter-author", description: "draft ch13 academic", prompt: "<ch13 提示>"})
Agent({subagent_type: "chapter-author", description: "draft ch14 academic", prompt: "<ch14 提示>"})
Agent({subagent_type: "chapter-author", description: "draft ch15 academic", prompt: "<ch15 提示>"})
```

- [ ] **Step 3:等 5 个 author 简报 → 在单条主线消息中并行 dispatch 5 个 reviewer**

按 Task 1.1 Step 4-5 模板,五并行 dispatch reviewer。

- [ ] **Step 4:验证 5 份 REVIEW 落盘**

```bash
ls -la /Users/guliufang/MiniMax/AAAR/REVIEW-ch{11,12,13,14,15}.md
```

Expected: 5 个 REVIEW 文件 exists。

---

### Task 2.2:汇总 + grep + Quarto + coherence

**Files:**
- Read: `REVIEW-ch11.md` 至 `REVIEW-ch15.md`

- [ ] **Step 1:读完 5 份 REVIEW**

主线 Claude 逐份读;为每章记录 verdict(PASS / NEEDS_TARGETED_FIX / NEEDS_REWRITE)。

- [ ] **Step 2:综合 grep blocklist 8 条数据驱动验证(ch11-15)**

```bash
cd /Users/guliufang/MiniMax/AAAR/outline
echo "==== 破折号 ===="; for f in 11 12 13 14 15; do c=$(grep -o "——" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 5)"; done
echo "==== 加粗 ===="; for f in 11 12 13 14 15; do c=$(grep -o '\*\*[^*]*\*\*' ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 10)"; done
echo "==== 你 ===="; for f in 11 12 13 14 15; do c=$(grep -o "你" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 20)"; done
echo "==== 让我们 ===="; for f in 11 12 13 14 15; do c=$(grep -o "让我们" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 0)"; done
echo "==== A 不是 X 而是 Y ===="; for f in 11 12 13 14 15; do c=$(grep -oE "不是[^,。]+[,,]而是" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 1)"; done
echo "==== 核心/关键/本质/根本/真正 ===="; for f in 11 12 13 14 15; do c=$(grep -oE "(核心|关键|本质|根本|真正)" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 5)"; done
echo "==== 元评论 ===="; for f in 11 12 13 14 15; do c=$(grep -oE "(这意味着|换句话说|值得注意的是|事实上|实际上)" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 1)"; done
echo "==== 就像X一样 ===="; for f in 11 12 13 14 15; do c=$(grep -oE "就像[^,。]+一样" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 1)"; done
echo "==== 字节数 ===="; wc -c 11-*.md 12-*.md 13-*.md 14-*.md 15-*.md
```

ch11-15 字数下限为 40000(part 3 核心)。任一章某项超上限,记录为该章的额外 fix 项。

- [ ] **Step 3:Quarto check**

```bash
cd /Users/guliufang/MiniMax/AAAR && quarto render --to html 2>&1 | tail -50
```

Expected: 渲染无 error。

- [ ] **Step 4:跨章 coherence 扫(扩展到 ch07-15)**

```bash
cd /Users/guliufang/MiniMax/AAAR
echo "==== 锚点声明(ch07-15)===="; grep -n "{#sec-" outline/0[7-9]*.md outline/1[0-5]*.md
echo "==== 锚点引用(ch07-15)===="; grep -n "@sec-" outline/0[7-9]*.md outline/1[0-5]*.md
```

主线核对每个 `@sec-` 引用对应的 `{#sec-…}` 是否真的存在(在 ch07-15 + ch01-06 中)。

- [ ] **Step 2:特别校验:ch11-15 五级角色框架的内部一致性**

ch11(RA) → ch12(Supervisor) → ch13(Domain Expert) → ch14(Agent) → ch15(Governance) 是层级递进,各章对前一级别的呼应应密集且具体。

```bash
cd /Users/guliufang/MiniMax/AAAR/outline
echo "==== ch12 对 ch11 的呼应 ===="; grep -nE "(@sec-ra-|RA Level|研究助理)" 12-*.md
echo "==== ch13 对 ch11/12 的呼应 ===="; grep -nE "(@sec-ra-|@sec-supervisor-|RA Level|Supervisor)" 13-*.md
echo "==== ch14 对 ch11/12/13 的呼应 ===="; grep -nE "(@sec-ra-|@sec-supervisor-|@sec-domain-expert-)" 14-*.md
echo "==== ch15 对 ch11-14 的呼应 ===="; grep -nE "(@sec-ra-|@sec-supervisor-|@sec-domain-expert-|@sec-llm-three-identities)" 15-*.md
```

每章对前置至少 1 处具体引用 → ✓;否则记为跨章问题。

- [ ] **Step 3:写 PHASE2-SUMMARY.md**

按 Task 1.2 Step 5 模板,内容覆盖 5 章。

- [ ] **Step 4:Commit 汇总**

```bash
git add /Users/guliufang/MiniMax/AAAR/PHASE2-SUMMARY.md
git commit -m "review: Phase 2 (ch11-15) 汇总报告"
```

---

### Task 2.3:用户验收门

按 Task 1.3 同流程。建议用户从 ch13(全书最危险章 / 域专家) + ch15(治理 / 全书理论收束)中各抽 1 章细读。

---

## Phase 3 — ch16-18 并行扩写(3 章)

### Task 3.1:并行 dispatch 3 个 author + 3 个 reviewer

**Files:**
- Modify: `outline/16-一个完整的AI科研工作流.md`, `outline/17-终章-AI时代的研究者.md`, `outline/18-附录.md`
- Create: `REVIEW-ch16.md`, `REVIEW-ch17.md`, `REVIEW-ch18.md`

- [ ] **Step 1:为 ch16-18 准备 author 提示**

按 Task 1.1 Step 1 模板。注意特殊性:

- ch16(整合章):必须在论述中具体呼应 ch07-15 全部 9 章。每章 ≥ 1 处具体引用。字数下限 35000。
- ch17(终章):全书的理论性收束。必须呼应 ch01-04 的核心概念 + ch11-15 五级角色框架。字数下限 30000(允许略短,因为是终章性质)。
- ch18(附录):工具索引 / 资源 / 模板。允许使用列表和表格;字数下限 25000(附录性质,允许更短)。
- ch18 的 callout 上限放宽到 5(因为附录本身是参考性内容)。

- [ ] **Step 2:在单条主线消息中并行 dispatch 3 个 chapter-author**

- [ ] **Step 3:等简报 → 并行 dispatch 3 个 reviewer**

- [ ] **Step 4:验证 3 份 REVIEW 落盘**

```bash
ls -la /Users/guliufang/MiniMax/AAAR/REVIEW-ch{16,17,18}.md
```

---

### Task 3.2:汇总 + grep + Quarto + coherence

**Files:**
- Read: `REVIEW-ch16.md` 至 `REVIEW-ch18.md`

- [ ] **Step 1:读完 3 份 REVIEW**

主线 Claude 逐份读;为每章记录 verdict(PASS / NEEDS_TARGETED_FIX / NEEDS_REWRITE)。

- [ ] **Step 1b:综合 grep blocklist 8 条数据驱动验证(ch16-18)**

```bash
cd /Users/guliufang/MiniMax/AAAR/outline
echo "==== 破折号 ===="; for f in 16 17 18; do c=$(grep -o "——" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 5)"; done
echo "==== 加粗 ===="; for f in 16 17 18; do c=$(grep -o '\*\*[^*]*\*\*' ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 10)"; done
echo "==== 你 ===="; for f in 16 17 18; do c=$(grep -o "你" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 20)"; done
echo "==== 让我们 ===="; for f in 16 17 18; do c=$(grep -o "让我们" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 0)"; done
echo "==== A 不是 X 而是 Y ===="; for f in 16 17 18; do c=$(grep -oE "不是[^,。]+[,,]而是" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 1)"; done
echo "==== 核心/关键/本质/根本/真正 ===="; for f in 16 17 18; do c=$(grep -oE "(核心|关键|本质|根本|真正)" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 5)"; done
echo "==== 元评论 ===="; for f in 16 17 18; do c=$(grep -oE "(这意味着|换句话说|值得注意的是|事实上|实际上)" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 1)"; done
echo "==== 就像X一样 ===="; for f in 16 17 18; do c=$(grep -oE "就像[^,。]+一样" ${f}-*.md | wc -l | tr -d ' '); echo "ch${f}: ${c} (上限 1)"; done
echo "==== 字节数 ===="; wc -c 16-*.md 17-*.md 18-*.md
```

ch16 下限 35000;ch17 下限 30000;ch18 下限 25000(附录性质允许更短)。

- [ ] **Step 1c:Quarto check**

```bash
cd /Users/guliufang/MiniMax/AAAR && quarto render --to html 2>&1 | tail -50
```

Expected: 渲染无 error。

- [ ] **Step 1d:跨章 coherence 扫(扩展到全 12 章 ch07-18)**

```bash
cd /Users/guliufang/MiniMax/AAAR
echo "==== 锚点声明(ch07-18)===="; grep -n "{#sec-" outline/0[7-9]*.md outline/1[0-8]*.md
echo "==== 锚点引用(ch07-18)===="; grep -n "@sec-" outline/0[7-9]*.md outline/1[0-8]*.md
```

主线核对每个 `@sec-` 引用对应的 `{#sec-…}` 是否真的存在(在全 12 章 + ch01-06 中)。

- [ ] **Step 2:特别校验 ch16 整合章 — 是否呼应 ch07-15 全 9 章**

```bash
cd /Users/guliufang/MiniMax/AAAR/outline
for ref in 07 08 09 10 11 12 13 14 15; do
  c=$(grep -E "(第\s*${ref}\s*章|ch${ref}|@sec-)" 16-*.md | grep -v "^#" | wc -l | tr -d ' ')
  echo "ch16 引用 ch${ref}: ${c} 处"
done
```

每个 ${ref} 至少 1 处 → ✓;否则在 PHASE3-SUMMARY.md 标记。

- [ ] **Step 3:写 PHASE3-SUMMARY.md + commit**

```bash
git add /Users/guliufang/MiniMax/AAAR/PHASE3-SUMMARY.md
git commit -m "review: Phase 3 (ch16-18) 汇总报告"
```

---

### Task 3.3:用户验收门

按 Task 1.3 同流程。建议用户重点读 ch16(整合质量决定全书是否成体系) + ch17(终章是给读者的最后印象)。

---

## Final Pass

### Task F.1:全书 12 章 checking-coherence + 综合 grep

- [ ] **Step 1:全书一致性扫**

调用 checking-coherence skill 一次,target = 全 12 章:

```
Skill({skill: "checking-coherence", args: "outline/0[7-9]*.md outline/1[0-8]*.md"})
```

(skill 接受多文件需 verify;若不支持多文件,改为对每章单独跑,主线汇总。)

- [ ] **Step 2:综合 grep blocklist 全 12 章**

```bash
cd /Users/guliufang/MiniMax/AAAR/outline
echo "==== blocklist 18 条全章合规扫 ===="
for f in 07 08 09 10 11 12 13 14 15 16 17 18; do
  echo "--- ch${f} ---"
  bash -c "
    破折号=\$(grep -o '——' ${f}-*.md | wc -l | tr -d ' ')
    加粗=\$(grep -o '\*\*[^*]*\*\*' ${f}-*.md | wc -l | tr -d ' ')
    你=\$(grep -o '你' ${f}-*.md | wc -l | tr -d ' ')
    让我们=\$(grep -o '让我们' ${f}-*.md | wc -l | tr -d ' ')
    not_X_but_Y=\$(grep -oE '不是[^,。]+[,,]而是' ${f}-*.md | wc -l | tr -d ' ')
    abstract=\$(grep -oE '(核心|关键|本质|根本|真正)' ${f}-*.md | wc -l | tr -d ' ')
    meta=\$(grep -oE '(这意味着|换句话说|值得注意的是|事实上|实际上)' ${f}-*.md | wc -l | tr -d ' ')
    simile=\$(grep -oE '就像[^,。]+一样' ${f}-*.md | wc -l | tr -d ' ')
    echo \"破折号:\$破折号(≤5) 加粗:\$加粗(≤10) 你:\$你(≤20) 让我们:\$让我们(≤0) 对仗:\$not_X_but_Y(≤1) 抽象:\$abstract(≤5) 元评论:\$meta(≤1) 比喻:\$simile(≤1)\"
  "
done
```

- [ ] **Step 3:跨章锚点完整性扫**

```bash
cd /Users/guliufang/MiniMax/AAAR
echo "==== 全 12 章锚点声明 ===="; grep -nE "{#sec-" outline/0[7-9]*.md outline/1[0-8]*.md | sort
echo
echo "==== 全 12 章锚点引用 ===="; grep -nE "@sec-" outline/0[7-9]*.md outline/1[0-8]*.md | sort
```

主线核对每个引用对应的声明存在(可写一个简单 awk / python 脚本,或人工核)。

- [ ] **Step 4:Quarto 全书最终渲染**

```bash
cd /Users/guliufang/MiniMax/AAAR && quarto render --to html 2>&1 | tail -100
```

Expected: 渲染成功,无 error;warning 列入最终报告。

- [ ] **Step 5:写 FINAL-REPORT.md**

```bash
cat > /Users/guliufang/MiniMax/AAAR/FINAL-REPORT.md
```

内容:
- 12 章字数终值表
- 12 章真实引用 + TODO 占位计数表
- 12 章 blocklist 8 条数据驱动综合表
- 跨章锚点完整性结论
- Quarto 渲染状态
- 全部待人工补 TODO 列表(给作者后续手动填)

- [ ] **Step 6:Commit FINAL-REPORT**

```bash
git add /Users/guliufang/MiniMax/AAAR/FINAL-REPORT.md
git commit -m "review: 全书 ch07-18 最终汇总报告"
```

---

### Task F.2:项目完成签字 + git tag

- [ ] **Step 1:把 FINAL-REPORT 提交给用户审阅**

主线告知用户:Phase 0-3 全部完成。FINAL-REPORT.md 在仓库根。请最终签字。

- [ ] **Step 2:用户签字"完成"后,git tag**

```bash
cd /Users/guliufang/MiniMax/AAAR && git tag ch07-18-deepened-v1
git log --oneline -20
git tag -l "ch07-18-deepened-*"
```

Expected: 看到 tag `ch07-18-deepened-v1`。

- [ ] **Step 3:可选 — 清理中间产物**

REVIEW-chXX.md 与 PHASE-SUMMARY.md 是过程文件。是否保留由作者决定:

- 保留(推荐):对未来追溯有价值
- 删除:`git rm REVIEW-ch*.md PHASE*-SUMMARY.md` 然后 commit

---

## 风险快速排查清单

| 失败现象 | 排查路径 |
|---|---|
| author abort 在 Phase 1(VOICE-academic.md 缺失等) | 锁包文件未到位,回 Phase 0 验证 |
| 章节字数严重不足(< 25K) | author Phase 3 e 步可能 silently skip;需要重 dispatch |
| reviewer verdict 全 NEEDS_REWRITE | 锁包阈值可能过严,或 author 未正确读锁包;先抽样 1 章读全文判定根因 |
| Quarto 渲染失败 | 可能 cross-ref 锚点语法错;grep `{#sec-` 检查是否有特殊字符 |
| 跨章引用大面积断裂 | cross-reference-contract.md 表与 author 实际命名不一致;扩展契约表覆盖 author 实际用名 |
| 真实引用数大面积不足 | 受限于 references.bib 现有 key 数量;在 FINAL-REPORT 中标记需要作者补条目 |
| 主线 dispatch 4-5 个并行 agent 后上下文吃紧 | 把 reviewer dispatch 拆成 2 批顺序(先 2 个,后 2 个);author 仍然全并行 |
