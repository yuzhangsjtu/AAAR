---
name: checking-coherence
description: Use to scan a target chapter draft against all other written chapters in outline/ for thematic overlap, terminology drift, broken cross-references, and unfulfilled forward references. Reports only — never modifies any file.
---

# Checking Coherence Skill

When invoked with a target chapter path:

## 输入

- 目标章节路径(如 `outline/05-...md`)
- 默认对比所有 `outline/*.md` 中以两位数字开头且**有实质内容(行数 > 50)**的章节

## 执行步骤

### Phase 1:读

1. 读目标章节
2. 用 Glob 列出所有 `outline/[0-9][0-9]-*.md`,对每个用 wc -l 检查行数,行数 > 50 的读进来

### Phase 2:四类检查

#### A. 主题重叠

- 找目标章节中出现的概念/案例/比喻,在其他章节中也出现的
- 对每个,判断:
  - 是有意呼应(比如 ch04 提到的「认知外包」是核心概念,后续章节自然会再提)→ OK,标注「呼应」
  - 是无谓重复(同一案例在两章都展开)→ 标注「重复」
- 输出:`(概念, 出现位置 1, 出现位置 2, 判断)` 列表

#### B. 前向引用兑现

- 在所有**其他**章节中 grep 这些短语:「我们将在第」「后文会」「后面会讲」「留待第」「在后面的章节」
- 对每个匹配,提取它承诺的章节号 N
- 如果目标章节就是第 N 章,检查目标章节是否兑现承诺
- 输出:未兑现的承诺列表 `(出处章节, 承诺内容, 是否兑现)`

#### C. 术语一致性

- 提取目标章节中的关键技术术语(英文术语、人名、概念译名)
- 在其他章节中查同一概念是否用了不同译名
- 例:「认知外包」vs「认知卸载」、「上下文」vs「context」、「思维链」vs「思考链」
- 输出:不一致列表

#### D. 交叉引用有效性

- Grep 目标章节中所有 `@fig-`、`@eq-`、`@tbl-` 引用
- 对每个 key,在所有 outline/ 章节中 grep 对应的 label 定义(`#fig-key`、`#eq-key`、`#tbl-key`)
- 输出:找不到 label 的引用列表(broken refs)

### Phase 3:输出报告

返回 markdown 报告:

```markdown
# Coherence Report — chXX

> Generated YYYY-MM-DD HH:MM

## A. 主题重叠

(若无:写「未发现明显重叠」)
- **概念 X**: 在 ch0Y §N 与 chXX §M 都展开。判断:重复 / 呼应。建议:...
- ...

## B. 前向引用兑现

(若无:写「未发现未兑现的前向引用」)
- ch0Y 第 N 段提到「我们将在第 XX 章讨论 Y」 → 本章未涉及 Y。建议:...
- ...

## C. 术语一致性

(若无:写「术语一致」)
- 「概念 X」在 ch0Y 中作「译名 A」,本章作「译名 B」。建议统一为...
- ...

## D. 交叉引用有效性

(若无:写「所有引用 valid」)
- `@fig-foo` 在本章 §N 引用,但未找到 label `#fig-foo` 定义。
- ...
```

## 重要

- 此 skill **只报告,绝不修改任何文件**
- 主题重叠不一定是问题,要给出判断而非简单标记
- 任何空节都要写「未发现 ...」,不能省略,以便调用方知道检查跑过了
