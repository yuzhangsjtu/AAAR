# 章际交叉引用契约(cross-reference-contract)

> 适用于 ch07-18。author agent 跨章引用必须依此契约;reviewer agent 验证锚点存在性。
> 设计依据:specs/2026-05-08-deepen-thin-chapters-design.md
> 日期:2026-05-08

## 1. 契约表

| 章 | 标题 | 本章承诺定义的术语与锚点 ID | 允许引用的章节范围 | 必须呼应的前置 |
|---|---|---|---|---|
| 07 | AI 编程与数据分析 | 「AI 编程三角色:补全员/对话员/Agent」`{#sec-ai-coding-roles}`;「上下文工程」`{#sec-context-engineering}`;「prompt / skill / tool / MCP 抽象层级」`{#sec-coding-abstraction-levels}` | ch01-06 | ch03 §API;ch04 §执行 vs 思考边界 |
| 08 | AI 辅助写作 | 「AI 介入三层次:词句级/段落级/结构级」`{#sec-writing-three-levels}`;「先自己写差版再让 AI 改」原则 `{#sec-write-first-then-ai}`;「AI 平均化」`{#sec-ai-averaging}` | ch01-07 | ch04 §写作即思考;ch04 §学术诚信 |
| 09 | AI Agent 与工作流自动化 | 「Chatbot vs Agent 自主程度区分」`{#sec-chatbot-vs-agent}`;「Agent 失败模式:漂移/循环/截断/丢弃/级联」`{#sec-agent-failure-modes}`;「skill / MCP / prompt / sub-agent 判定法」`{#sec-agent-asset-judgment}` | ch01-08 | ch01 §Agent 是行动者;ch04 §自动化偏见;ch07 §AI 编程角色 |
| 10 | 图像生成与多模态 | 「多模态三类任务:理解/生成/转换」`{#sec-multimodal-three-tasks}`;「图像生成四类合理场景」`{#sec-image-gen-legitimate-uses}`;「学术配图的 AI 边界」`{#sec-academic-figure-boundary}` | ch01-09 | ch02 §锯齿;ch03 §模型评估维度 |
| 11 | AI 作为研究助理(RA Level) | 「RA Level 三档信任校准」`{#sec-ra-three-tiers}`;「硅样本作为方法论假设」`{#sec-silicon-sample-as-method}`;「RA 化对学生培养的代价」`{#sec-ra-training-cost}` | ch01-10 | ch01 §5-level 框架;ch02 锯齿;ch04 §执行 vs 思考 |
| 12 | AI 辅助项目管理(Supervisor Level) | 「Supervisor Level 三特征」`{#sec-supervisor-three-features}`;「苏格拉底问/对抗辩论/周期复盘三种用法」`{#sec-supervisor-three-modes}`;「AI Supervisor 失效场景」`{#sec-supervisor-failure-cases}` | ch01-11 | ch01 §AI 不善学习用户;ch04 §苏格拉底式提问;ch11 §RA Level |
| 13 | AI 作为领域专家(Domain Expert Level) | 「域专家任务三特征」`{#sec-domain-expert-task-features}`;「5 题测试模板」`{#sec-five-question-test}`;「跨学科入门作为合理使用边界」`{#sec-cross-disciplinary-entry}` | ch01-12 | ch02 §锯齿整章;ch03 §模型评估维度 2;ch11-12 角色递进 |
| 14 | AI 作为独立行动者(Agent Level) | 「LLM-as-tool / -as-agent / -as-subject 三身份」`{#sec-llm-three-identities}`;「硅样本研究的论文写作底线」`{#sec-silicon-paper-rules}`;「行动者概念边界」`{#sec-actor-concept-boundary}` | ch01-13 | ch01 §Agent 概念;ch04 §Agent 行为不可预测;ch11 §硅样本;ch13 §AI 同行评议 |
| 15 | 伦理与治理(Governance Level) | 「论文三种功能:总结/交流/发现」`{#sec-paper-three-functions}`;「评价体系 proxy hacking」`{#sec-proxy-hacking}`;「同行评议系统性崩盘」`{#sec-peer-review-collapse}`;「个人能做/必须做清单」`{#sec-individual-action-lists}` | ch01-14 | ch04 §学术诚信;ch11-14 五级角色全部 |
| 16 | 一个完整的 AI 科研工作流 | 「研究项目五阶段:酝酿/构建/执行/写作/传播」`{#sec-five-phase-workflow}`;「三种工作流模板:本科/博士/资深」`{#sec-three-workflow-templates}`;「工作流断裂作为失败模式」`{#sec-workflow-fracture}` | ch01-15(全书) | ch07-15 工具+角色全栈 |
| 17 | 终章·AI 时代的研究者 | 「GenAI 三定律:去用/思考不能外包/为产出负全责」`{#sec-three-laws}`;「45 年国军」隐喻 `{#sec-1945-metaphor}`;「分阶段研究者价值观清单」`{#sec-stage-values}` | ch01-16(全书) | 全书所有章 |
| 18 | 附录 | (附录类章节,主要承接,不承诺新术语锚点) | ch01-17 | 全书所有章 |

## 2. 硬约束

- 章节中所有跨章引用必须使用契约表中已声明的锚点 ID
- 严禁前向引用未在表中声明的内容(防止 ch12 引用 ch15 还没定义的概念)
- 章节首次出现承诺锚点的标题必须加 `{#sec-{anchor-id}}` 后缀
  例:`## RA Level 三档信任校准 {#sec-ra-three-tiers}`
- 跨章引用语法:`@sec-ra-three-tiers`(Quarto 自动转跳转链接)

## 3. 跨章呼应密度

- 每章 ≥ 2 处具体的跨章呼应(「第 X 章 §Y 提出的 Z 概念,在本章场景下……」),且至少 1 处使用 `@sec-` 锚点引用
- 不允许笼统的「前面章节已讨论过」或「后续章节会讨论」
- ch16(整合章)对 ch07-15 全 9 章每章至少 1 处具体引用
- ch17(终章)对全书每个 part 至少 1 处具体引用

## 4. 命名规范

- 锚点 ID 全小写;单词间用连字符 `-`
- 不用中文命名锚点(Quarto 渲染兼容性问题)
- 与 BibTeX key 命名风格一致(短小、可读、无歧义)

## 5. reviewer 检查项

reviewer agent 在 REVIEW-chXX.md 的 `§ C 跨章节连贯` 须包含:

1. 本章定义的所有锚点是否按契约表落地(`grep "{#sec-" outline/XX-*.md` 验证)
2. 本章引用的所有 `@sec-` 标记是否在契约表中已被声明定义
3. 是否有前向引用违规(引用了表中尚未定义的锚点)
4. 跨章呼应数量(≥ 2 处,其中 ≥ 1 处使用锚点)
5. 对 ch16 / ch17 的特殊检查:对前置章节的覆盖度
