---
name: finding-citations
description: Use to find citation keys in references.bib that support a given claim, or to mark a [@TODO] placeholder when no suitable existing citation is found. Strictly never fabricates BibTeX entries, DOIs, authors, or any bibliographic info.
---

# Finding Citations Skill

When invoked with a claim that needs citation support:

## 步骤

1. 用 Read 工具读 `references.bib`
2. 用 Grep 工具按 keyword 扫描:把待证论点拆成核心关键词(中英都试),在 bib 文件里找 title/abstract/keywords 字段匹配
3. 返回:
   - **找到匹配**: `[@bibkey]` (或多条 `[@key1; @key2]`)
   - **找不到**: `[@TODO: <一行描述需要什么样的证据>]`

## 严禁

- **绝不**编造 BibTeX key、DOI、作者、年份、期刊、标题
- **绝不**虚构「应该会支持这个论点」的论文
- **绝不**在 references.bib 中添加你无法独立验证存在的条目

## 当被要求添加新 BibTeX 条目时

- 仅在调用方提供**经过核实**的书目信息(title、authors、venue、year、DOI/URL)时才添加
- 调用方只给主题/标题提示 → 拒绝并解释:"我无法在没有可核实来源的情况下生成 BibTeX。请提供 DOI 或完整引用。"
- 添加时把新条目 append 到 references.bib 末尾,保持 BibTeX 格式

## 输出格式

只返回引用标记本身(如 `[@kahneman2011thinking]` 或 `[@TODO: 实验证据,认知外包对长期记忆的影响]`)。不在行内加解释。

如调用方要求批量找,返回一个表:

```
| 论点 | 引用 |
|---|---|
| ... | [@xxx] |
| ... | [@TODO: ...] |
```
