# 写作工作流多 Agent + Skills 改造 — 设计文档

- **日期**: 2026-05-07
- **状态**: 设计已批准,待写实施计划
- **目标读者**: 本书作者 + 后续维护者

## 1. 背景与目标

### 1.1 现状

AAAR 项目共 18 章,目前已写 4 章(`outline/01-04`,每章 300-380 行,带 callout、文献引用、强烈个人语气)。剩余 14 章为空壳(只有标题)。原始素材分散在 `idea记录.md`,混合各章想法、跨章节金句和待组织片段。

### 1.2 当前工作流的痛点(用户已确认)

1. **从点子到初稿**: idea 扩成几百行结构化初稿耗时
2. **保持个人语气一致**: AI 辅助写多了之后语气会被「平均化」,丢失辨识度
3. **跨章节连贯与不重复**: 章节间需要呼应(例:ch04 开头「前三章……」),概念/案例不能在多章重复堆砌
4. **文献与引用管理**: 找文献、核实、写 BibTeX 条目费时

### 1.3 目标

在本仓库 `.claude/` 下搭建一套基于 Claude Code 原生机制(subagent + skill + slash command)的高度自动写作工作流:

- 用户在 `ideas/XX-*.md` 写要点
- 一句 `/draft-chapter <编号>` 触发完整流程
- 多个 agent + skills 自动协作产出章节草稿到 git 分支
- 用户最后做一次 review,合并到 main

### 1.4 非目标(显式排除)

- 不构建 web UI / dashboard
- 不构建脱离 Claude Code 的独立 CLI(用户已选 Claude Code 原生)
- 不做 PR 自动创建(用户直接 merge 分支)
- 不做并行多章节生成(顺序生成才能让后写章节看到前面的上下文)
- 不做版本管理 / cost tracking(git 与 Claude Code 已覆盖)

## 2. 范围

### 2.1 In scope

- 2 个 subagent: `chapter-author`、`chapter-reviewer`
- 5 个 skill: `extracting-voice`、`applying-voice`、`finding-citations`、`checking-coherence`、`chapter-template`
- 2 个 slash command: `/draft-chapter`、`/refresh-voice`
- 仓库根的 `VOICE.md`(风格锚点)与 `ideas/` 目录(按章节拆分的输入)
- 端到端跑通 1 章(ch05「智能搜索与文献发现」)作为 MVP 验收

### 2.2 Out of scope

- 已写章节(01-04)的回头改写——只用作样本
- `idea记录.md` 中跨章节散文的处理——保留为「未归档想法池」,不强制拆分
- ch05 之外的 13 章批量推进——属于阶段 2

## 3. 架构总览

### 3.1 目录结构

```
.claude/
├── agents/
│   ├── chapter-author.md       # 主力:idea → 大纲 → 扩写 → 润色
│   └── chapter-reviewer.md     # 独立 reviewer:质量检查,产 issue 列表
├── skills/
│   ├── extracting-voice/SKILL.md
│   ├── applying-voice/SKILL.md
│   ├── finding-citations/SKILL.md
│   ├── checking-coherence/SKILL.md
│   └── chapter-template/SKILL.md
└── commands/
    ├── draft-chapter.md
    └── refresh-voice.md

(项目根)
├── VOICE.md                    # 风格锚点(混合方式产出,首次后人工维护)
├── ideas/                      # idea 输入按章节拆文件
│   ├── 05-智能搜索与文献发现.md
│   ├── 06-...
│   └── ...
├── idea记录.md                 # 保留:未归档想法池
└── outline/                    # 最终章节(不变)
```

### 3.2 关键架构决定

| 决定 | 理由 |
|---|---|
| **agent vs skill 的分工**: agent 用于需要独立 context 的角色(reviewer 不能带 author 偏见);skill 用于可复用能力封装 | Claude Code 设计哲学:skills 是知识/能力,agents 是 context 隔离单位。reviewer 必须独立 context 才有「独立」价值 |
| **VOICE.md 在仓库根**, 不在 `.claude/` 下 | 它是内容资产(用户常看常改),不是工具配置 |
| **ideas/ 按章节拆文件** | author agent 只读自己章节的 ideas,context 干净;`idea记录.md` 保留为想法池 |
| **不引入 `drafts/` 中间产物目录** | 高度自动模式下逐步可恢复价值有限;改用 git 分支(`draft/chXX`)做隔离,跑挂直接 `git branch -D` 重来 |
| **reviewer 不修改 author 产物,只产 issue list** | 避免两个 agent 互相覆盖打架;改不改、怎么改由用户在 review 时决定 |

## 4. 核心组件详细设计

### 4.1 `chapter-author` agent

**职责**: 端到端产出章节草稿,从 ideas 到 commit。

**输入**:
- `ideas/XX-*.md`: 本章原始想法(必需)
- `VOICE.md`: 风格锚点(必需)
- `outline/01-NN.md`: 所有已写章节(作风格参考 + 连贯参考)
- `_quarto.yml`: 章节列表(知道前后章节标题)

**流程**:
1. 读 ideas + 已写章节 → 生成章节大纲
2. 调用 `chapter-template` skill 套结构(callout/cross-ref/章节层级约定)
3. 逐节扩写,边写边调用:
   - `applying-voice` skill(润语气)
   - `finding-citations` skill(找文献,追加到 `references.bib`)
   - `checking-coherence` skill(查重/呼应)
4. 写到 `outline/XX-*.md`,git commit

**输出**:
- `outline/XX-*.md`(章节草稿)
- `references.bib` 新增条目
- 一行简报回主对话(不超 100 字)

### 4.2 `chapter-reviewer` agent

**职责**: 独立质量检查,产 issue list 供用户 review。**不修改任何文件**。

**输入**:
- `outline/XX-*.md`(刚写的章节)
- `VOICE.md`
- `outline/01-NN.md`(查呼应/重复)
- `ideas/XX-*.md`(查覆盖度)

**输出**: `REVIEW-chXX.md`(临时文件,git 不跟踪)包含:
- 风格偏离:具体段落 + 偏离的维度 + 建议
- 与已写章节重复/冲突的论述:位置 + 性质
- ideas 里没用上的关键点
- 引用错误/缺失:位置 + 缺什么
- Quarto 语法问题(callout 错用、cross-ref 失效)

### 4.3 Skills

#### `extracting-voice`
- **何时调用**: `/refresh-voice` 触发,或用户主动调用
- **输入**: `outline/01-NN.md`(已写章节做样本)
- **输出**: `VOICE.md` 草稿,覆盖以下维度:
  - 句式(平均句长、长短句比例、典型连接词)
  - 段落结构(开头/收尾习惯、过渡方式)
  - 修辞(常用隐喻类型、举例方式、案例密度)
  - callout 使用习惯(频率、warning/tip/note 用在什么场景)
  - 个人语气标记(第二人称频率、反问、口语化插入)
  - 禁忌(从样本反推:从不出现的句式/词)

#### `applying-voice`
- **何时调用**: `chapter-author` 在扩写每节后调用
- **输入**: 段落草稿 + `VOICE.md`
- **输出**: 调整后段落(只改语气、不改论点结构)

#### `finding-citations`
- **何时调用**: `chapter-author` 写到需要引用的地方
- **输入**: 待引用论点 + 上下文
- **输出**:
  - BibTeX 条目(追加到 `references.bib`)
  - `[@key]` 标记(插入草稿)
  - 找不到时:占位符 + 在 REVIEW 里标 TODO,**绝不假造文献**

#### `checking-coherence`
- **何时调用**: `chapter-author` 扩写完成后,或 `chapter-reviewer` 主动调用
- **输入**: 当前章节 + `outline/01-NN.md`
- **输出**: 一份简短报告:
  - 与已写章节的概念重叠点
  - 已写章节中提到「后面会讲」的内容,本章是否覆盖
  - 术语/译名一致性问题

#### `chapter-template`
- **何时调用**: `chapter-author` 起草大纲时
- **输入**: 章节标题 + 大纲点
- **输出**: 章节骨架(章节层级、callout 块位置、cross-ref 占位、文献占位),约定来自现有 ch01-04 的结构观察

### 4.4 Slash commands

#### `/draft-chapter <编号>`
- **前置检查**:
  - `ideas/<编号>-*.md` 存在且非空
  - `VOICE.md` 存在(否则提示 `/refresh-voice`)
- **执行**:
  1. `git checkout -b draft/ch<编号>`(若分支已存在,**拒绝执行**并提示用户先处理,不自动覆盖)
  2. 调用 `chapter-author` agent(独立 context)
  3. 调用 `chapter-reviewer` agent(独立 context)
  4. `quarto render --to html` 验证语法
  5. 把 REVIEW 结果 + 渲染状态汇报给用户

#### `/refresh-voice`
- **前置检查**: `outline/01-NN.md` 至少存在 2 章
- **执行**:
  1. 调用 `extracting-voice` skill 在主对话执行
  2. 把 VOICE.md 草稿呈现给用户
  3. 邀请用户标注/修改
  4. 用户确认后 git commit

## 5. 端到端数据流

```
用户:/draft-chapter 05
       │
       ▼
slash command (主对话):
  - 检查 ideas/05-*.md、VOICE.md
  - git checkout -b draft/ch05
       │
       ▼
chapter-author agent(独立 context):
  ideas + VOICE + 已写章节 → outline + 扩写
  (内部调用 applying-voice / finding-citations /
   checking-coherence / chapter-template skills)
  → outline/05-*.md + references.bib(committed)
       │
       ▼
chapter-reviewer agent(独立 context,新开):
  outline/05-*.md + VOICE + 已写章节 + ideas/05
  → REVIEW-ch05.md(issue list,不跟踪)
       │
       ▼
slash command 收尾:
  - quarto render --to html
  - 把 REVIEW + 渲染结果汇报
  - 提示用户在 draft/ch05 上 review,改好后 merge 回 main
```

## 6. 失败处理 & 质量 gate

### 6.1 失败处理

| 失败点 | 处理 |
|---|---|
| `ideas/XX-*.md` 不存在/为空 | slash command 立即退出,提示先填 idea |
| `VOICE.md` 不存在 | slash command 拒绝,提示跑 `/refresh-voice` |
| `chapter-author` 跑挂或写出明显垃圾 | reviewer 标出来;最坏 `git branch -D draft/chXX` 重跑 |
| `quarto render` 失败 | 错误塞进 REVIEW,但章节文件保留(让用户决定改语法还是改内容) |
| `finding-citations` 找不到合适文献 | BibTeX 占位符 + REVIEW 里标 TODO,**不假造** |
| 跨章节冲突 | reviewer 只标记不修改,用户决定哪边改 |
| `draft/chXX` 分支已存在 | slash command 拒绝并提示用户先处理(不自动覆盖) |

### 6.2 质量 gate

- **第一道**: `chapter-reviewer`(自动,客观问题:语法、重复、覆盖、引用)
- **第二道**: 用户人工 review(主观判断:语气、立场、案例选择)
- **设计原则**: reviewer **不**自动改 author 的产物——只产 issue list,避免两个 agent 互相覆盖打架

## 7. VOICE.md 初始化流程

混合方式(用户已确认):

1. 用户跑 `/refresh-voice`
2. `extracting-voice` skill 读 `outline/01-04` 提取草稿
3. 草稿呈现给用户,用户花 10-20 分钟标注/修改
4. 用户确认 → git commit

后续重跑场景:
- 用户主动 `/refresh-voice`(写了几章后想让 VOICE 进化)
- VOICE.md 删了(slash command 检测到会拒绝 `/draft-chapter`)

## 8. MVP 范围(分阶段)

### 阶段 1(MVP)— 全套基础设施 + ch05 端到端验证

- 写完所有 agent / skill / slash command
- 拆 `idea记录.md` → `ideas/05-*.md`(其他章节先不拆)
- 跑 `/refresh-voice` 定稿 VOICE.md
- 跑 `/draft-chapter 05`
- 用户 review,根据问题反向调整:
  - voice 问题 → 改 `VOICE.md`
  - author 流程问题 → 改 `chapter-author` 提示词
  - reviewer 漏检 → 加规则到 `chapter-reviewer`
- **验收标准**: ch05 草稿合入 main 时改动量 ≤ 30%(以 `git diff --stat` 行数计:`(insertions + deletions) / 草稿总行数 ≤ 0.30`)

### 阶段 2(规模化)— 基于阶段 1 反馈批量推进

- 拆剩下 13 章的 `ideas/XX-*.md`
- 按章节顺序跑(顺序很关键——后写章节才能看到前面的更多上下文)
- 不再 setup,纯生产模式

## 9. 验收标准

阶段 1 完成意味着:

- [ ] `.claude/` 下 agents / skills / commands 全部就位且可被 Claude Code 加载
- [ ] `VOICE.md` 已生成且经用户确认
- [ ] `ideas/05-智能搜索与文献发现.md` 已从 `idea记录.md` 拆出且含足够要点
- [ ] `/draft-chapter 05` 能跑完整流程(无 unhandled error)
- [ ] 产出的 `outline/05-*.md` 合入 main 时改动量 ≤ 30%(`git diff --stat` 计算)
- [ ] `references.bib` 新增条目均为真实文献(无假造)
- [ ] `quarto render --to html` 成功

## 10. 开放问题(实施时再定)

- `chapter-author` agent 的 model 选择(Opus 4.7 默认,但单章 token 量大,可能需要切 Sonnet 4.6 控制成本)
- `extracting-voice` 的输出格式细节(是结构化清单还是叙述式?——MVP 阶段先用结构化清单,后续按用户反馈调)
- `finding-citations` 是否调用 WebSearch 还是只在 `references.bib` 已有条目里匹配——倾向先只在 `references.bib` 内匹配,标 TODO 让用户决定补什么外部文献(避免假造风险)
