---
name: chapter-template
description: Use when drafting a new AAAR book chapter to generate a structural skeleton matching Quarto syntax conventions and the patterns observed in chapters 01-04 (heading levels, callout block placement, cross-reference syntax, citation syntax, opening/closing patterns, length targets).
---

# Chapter Template Skill

When drafting a new chapter for the AAAR book, generate a chapter skeleton that follows these structural conventions extracted from outline/01-04.

## 标题层级

- `# 章节标题`(level 1,仅一次)
- `## 主要章节`(level 2,4-7 个)
- `### 子节`(level 3,每个二级章节下 0-3 个,谨慎使用)

## 开篇模式

章节开头放 2-3 段 hook:

1. 一个具体场景或观察(常常是个案例)
2. 提出一个张力 / 问题,本章要回答的
3. (从第 2 章开始)回顾前面章节并引出本章:如「前 N 章我们讨论了 X、Y、Z。这一章要讨论一个更根本的问题:...」

## Callout 块

样本中三种 callout 在用:

- `::: {.callout-warning}` — 警示性观察或风险。每章 1-2 个。
- `::: {.callout-tip}` — 可操作的建议或简单测试。每章 1-2 个。
- `::: {.callout-note}` — 澄清或定义。每章 0-1 个。

格式:

```
::: {.callout-warning}
## Callout 标题

正文段落 1。

正文段落 2(可选)。
:::
```

## 交叉引用

- 章节互引:`第 N 章`(纯文本,无 anchor)
- 图:`@fig-key`
- 公式:`@eq-key`
- 表:`@tbl-key`

## 文献引用

- 格式:`[@bibkey]`
- BibTeX 条目放 `references.bib`
- 多条:`[@key1; @key2]`

## 章节段落收尾模式

每个二级章节末尾放 1-2 句过渡,预告下一节或与下一节连接。

## 章节整体收尾模式

章末放「回归点」—— 2-3 段总结:

1. 重述核心张力
2. 简洁陈述本章的论点
3. 引出下一章(如适用)

## 长度目标

- 整章:350-450 行 markdown
- 每个二级章节:50-100 行

## 调用时输出

返回章节骨架,包含:

- 章节标题(level 1)
- 4-7 个二级标题(基于调用者提供的大纲点)
- 每 1-2 节嵌入一个 callout 占位
- 论证位置插入 `[@TODO: ...]` 文献占位
- 章末「回归点」占位

不要填充正文,只要骨架。
