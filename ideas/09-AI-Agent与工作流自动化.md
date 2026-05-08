# ch09 AI Agent 与工作流自动化 — ideas

> 第二部分压轴章。从「单工具」过渡到「工具的编排」。

---

## A. 来自 idea记录.md 的相关线索

- 「**skill / mcp 等的区别和联系**」 — Agent 工作流中绕不开的概念
- 「**我的提示词、skills 放哪里**」 — Agent 资产的组织与版本管理
- 「**很多时候在做的,是上下文工程**」 — Agent 编排本质是 context 在多步间的流转
- 「Claude code + skills,加一系列 **agentic 能力优化和编排**,可以完成带数据分析的任务」 — Agent + skill 已经能做带数据分析的研究任务

## B. 来自原 outline.md 的章节意图

无直接对应章节(本章是 _quarto.yml 新增的章节,outline.md 中未规划)。

## C. 已在 ch01-05 中点过名的相关工具/概念

- ch01 §OpenAI 5-level 框架(line 116-138):Chatbot vs Agent 的明确分界
- ch01 §Agent 是行动者(line 130-138):「你给它一个目标而不是一个问题」
- ch03 §推理时间缩放(line 37):o1 路径 — Agent 内部推理的延展
- ch04 §自动化偏见(line 331):多步自主执行场景下,偏见会被放大
- ch05 §四步工作流(line 107-138):「种子→扩展→去重→补盲」是 agent 思路雏形

## D. 与已写章节的呼应锚点

- 承接 **ch01 Chatbot vs Agent 区分**:本章是这个区分的具体技术实现
- 承接 **ch04 自主程度提高 = 警惕程度提高**:Agent 自动跨多步意味着更多盲点
- 与 **ch07 编程章** 边界:ch07 是工具,本章是工具的编排(写代码 vs 写 skill/agent 的判定)
- 为 **ch11/14 RA / Agent Level**铺垫:本章给「角色化」提供技术基础

## E. 需要作者补充的核心要点

### E1. 你自己最常用的 agent 配置

- Claude Code + 哪几个 skill 是你日常配置?
- MCP server 你用过哪几个?具体在做什么?

### E2. 一个跨 5+ 步的真实研究 workflow

- 比如「从一个研究 idea 到一份初步分析报告」,具体把哪几步交给 agent?
- 哪些步骤即使能 agent 化你也保留人工?

### E3. Agent 失败模式

- 你遇过 agent 跑歪 / 漂移 / 进入循环 / 烧 token 的实战经验?
- 怎么设计「降级回退」?

### E4. skill / MCP / prompt / sub-agent 判定

- 同一个能力,什么时候做成 skill,什么时候做成 MCP server,什么时候只用 prompt?
- 你的判断原则?

### E5. 资产组织

- 提示词 / skill / agent 你怎么版本管理?(git? 私人 wiki? Notion?)
- 跨项目复用的边界?

## F. Callout 候选位置

- `callout-warning`: Agent 多步执行中的错误累积 — 承接 ch02 的 95% × 10 = 60% 论证,放在 agent 场景里的具体计算
- `callout-tip`: 一个「最小可用 workflow」模板(本书的 `/draft-chapter` 编排可作为案例)
- `callout-note`: skill / MCP / tool / prompt / sub-agent 术语澄清表
