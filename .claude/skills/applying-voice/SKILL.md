---
name: applying-voice
description: Use to revise a draft paragraph or section to match the voice defined in a specified voice guide (default VOICE.md, or VOICE-academic.md for ch07-18). Adjusts tone, sentence patterns, connectives, and rhetorical markers without changing argument structure, factual claims, or citations.
---

# Applying Voice Skill

When invoked with a draft paragraph/section, return a revised version conforming to the specified voice guide.

## Input parameters

- `voice_file` (路径,可选,默认 `VOICE.md`):风格指南文件相对于仓库根的路径。
  - ch01-06 内容调用方:传 `VOICE.md`(或省略,使用默认)
  - ch07-18 内容调用方:必须传 `VOICE-academic.md`

## 前置

- 必须能读到调用方指定的 `voice_file`
- 如缺失,拒绝执行,告诉调用方:VOICE.md 缺失先跑 `/refresh-voice`;VOICE-academic.md 缺失先完成锁包 Phase 0

## 执行步骤

1. 读 `voice_file`(由调用方指定;若调用方未指定,默认读 `VOICE.md`)
2. 读调用方提供的草稿段落/章节
3. 按 voice_file 各维度做转换:
   - 句长调整(按 voice_file 句长节奏要求,拆/合句子)
   - 连接词替换(按 voice_file 列出的连接词偏好)
   - 修辞注入(论证段如缺示例,可在合适位置补一个**已有素材中存在**的例子;如无,跳过)
   - Callout 重构(若草稿含 callout,确保符合 voice_file callout 模式)
   - 个人语气标记注入(按 voice_file 第二人称频率要求)
   - 禁忌移除(按 voice_file 禁忌部分;若 voice_file 引用了 AI-tells-blocklist.md,也按 blocklist 检查)

## 不要改

- 事实声明
- 论证结构、逻辑顺序
- 文献引用 key (`[@xxx]`)
- 交叉引用 (`@fig-`, `@eq-`, `@sec-`)
- 章节标题层级
- 锚点 ID(`{#sec-...}`)

## 输出

只返回修订后的文本,不要解释或理由。

## 重要

- 如果输入段落已经符合 voice_file checklist,原样返回
- 如果段落太短(< 50 字)无法做有意义转换,原样返回
- **绝不**为了「补例子」编造事实——如修辞需要例子但源文无,留原样,在末尾用 HTML 注释 `<!-- VOICE: 此段需要补一个具体例子 -->` 标注给调用方
- **绝不**修改交叉引用或锚点 ID,即使其格式与 voice_file 风格似乎不符
