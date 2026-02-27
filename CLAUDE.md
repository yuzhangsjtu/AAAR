# AAAR：AI加速学术研究的方法论与经验

## 项目概述

这是一本用 Quarto Book 构建的中文学术书籍，面向从本科生到教授的读者，讲解如何理性、批判性地将 AI 用于科研全流程。

- 在线阅读：https://yuzhangsjtu.github.io/AAAR/
- 仓库：https://github.com/yuzhangsjtu/AAAR

## 项目结构

```
outline/          # 全部章节内容（Markdown）
_quarto.yml       # Quarto 配置（书籍结构、格式、字体）
index.qmd         # 首页
references.bib    # 参考文献（BibTeX）
css/              # 自定义样式
includes/         # LaTeX/HTML header
cover.png         # 封面图片
.github/workflows/publish.yml  # GitHub Actions 自动部署
```

## 章节结构（3 部分 + 终章/附录）

- 第一部分（01-03）：理解 AI
- 第二部分（04-09）：AI 工具与技巧
- 第三部分（10-15）：案例与实践
- 终章（16）：AI 时代的研究者
- 附录（17）

## 写作规范

- 语言：中文为主，专业术语保留英文
- 风格：学术但不晦涩，注重实例和批判性分析
- 章节文件命名：`XX-标题.md`，XX 为两位数字编号
- 引用：使用 `[@key]` 格式，文献定义在 `references.bib`
- 交叉引用：`@fig-xxx`、`@eq-xxx`、`@tbl-xxx`

## 构建与部署

- **HTML（自动）**：push 到 main 后 GitHub Actions 自动构建部署到 GitHub Pages
- **PDF（本地）**：`quarto render --to pdf`（需要 XeLaTeX + PingFang SC 字体，仅 macOS）
- **本地预览**：`quarto preview`

## 版本管理

- 只跟踪源文件，`docs/` 构建产物已在 `.gitignore` 中排除
- commit message 格式：`类型: 描述`，类型包括 `content`、`fix`、`config`、`ci`、`build`
- 用 tag 标记里程碑版本（如 v0.1），通过 GitHub Releases 发布 PDF

## 注意事项

- 不要修改 `docs/` 下的文件，它们由 Quarto 自动生成
- 编辑章节内容只改 `outline/` 下的 `.md` 文件
- 新增章节需要同步更新 `_quarto.yml` 的 chapters 列表
- PDF 渲染使用 PingFang SC 字体，仅在 macOS 上可用
