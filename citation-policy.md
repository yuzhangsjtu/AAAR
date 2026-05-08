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
