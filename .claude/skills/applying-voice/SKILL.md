---
name: applying-voice
description: Use to revise a draft paragraph or section to match the voice defined in VOICE.md. Adjusts tone, sentence patterns, connectives, and rhetorical markers without changing argument structure, factual claims, or citations.
---

# Applying Voice Skill

When invoked with a draft paragraph/section, return a revised version conforming to VOICE.md.

## 前置

- 必须能读到仓库根 `VOICE.md`
- 如缺失,拒绝执行,告诉调用方先跑 `/refresh-voice`

## 执行步骤

1. 读 VOICE.md
2. 读调用方提供的草稿段落/章节
3. 按 VOICE.md 各维度做转换:
   - 句长调整(按 §1 的长短句比例,拆/合句子)
   - 连接词替换(用 §1 列出的典型连接词)
   - 修辞注入(论证段如缺示例,可在合适位置补一个**已有素材中存在**的例子;如无,跳过)
   - Callout 重构(若草稿含 callout,确保符合 §4 模式)
   - 个人语气标记注入(按 §5 的频率)
   - 禁忌移除(按 §6)

## 不要改

- 事实声明
- 论证结构、逻辑顺序
- 文献引用 key (`[@xxx]`)
- 交叉引用 (`@fig-`, `@eq-`)
- 章节标题层级

## 输出

只返回修订后的文本,不要解释或理由。

## 重要

- 如果输入段落已经符合 §7 checklist,原样返回
- 如果段落太短(< 50 字)无法做有意义转换,原样返回
- **绝不**为了「补例子」编造事实——如修辞需要例子但源文无,留原样,在末尾用 HTML 注释 `<!-- VOICE: 此段需要补一个具体例子 -->` 标注给调用方
