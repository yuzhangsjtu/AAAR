---
description: 端到端起草一章:author agent 写 + reviewer agent 复核 + Quarto 渲染验证
argument-hint: <章节编号 (如 05)>
---

# /draft-chapter $ARGUMENTS

把 $ARGUMENTS 记为 N(章节编号,两位数字)。

## 1. 前置检查

按顺序,任一失败 → 退出报错给用户:

1. **N 格式**:必须是两位数字。否则 → "章节编号必须是两位数字,如 05、14。"
2. **ideas 文件**:用 Glob `ideas/N-*.md`。无匹配 / 文件为空 → "ideas/N-*.md 不存在或为空。请先在 ideas/ 下创建对应文件。"
3. **VOICE.md**:仓库根必须存在。否则 → "VOICE.md 不存在。请先跑 /refresh-voice。"
4. **章节标题**:用 Grep 在 `_quarto.yml` 找 `outline/N-` 开头的行,提取标题。找不到 → "_quarto.yml 中没有 ch N 的注册。请先更新章节列表。"
5. **工作树干净**:Bash `git status --porcelain`,有输出 → "工作树有未提交修改,请先 commit/stash。"
6. **分支不存在**:Bash `git rev-parse --verify draft/chN 2>/dev/null`,如返回 0(分支存在)→ "draft/chN 分支已存在。请先 git branch -D draft/chN 或切到该分支继续。"

## 2. 切分支

```bash
git checkout -b draft/chN
```

## 3. 调用 chapter-author

用 Agent 工具:

```
Agent({
  description: "Draft chapter N",
  subagent_type: "chapter-author",
  prompt: "章节编号: N\n章节标题: <从 _quarto.yml 提取>\nideas 路径: <Step 1 找到的实际路径>\ntarget 路径: outline/N-<标题>.md"
})
```

等 agent 完成。如 author 返回错误 → 跳到 Step 6 的「失败收尾」。

## 4. 调用 chapter-reviewer

```
Agent({
  description: "Review chapter N",
  subagent_type: "chapter-reviewer",
  prompt: "章节编号: N\ndraft 路径: outline/N-<标题>.md\nideas 路径: <Step 1 找到的实际路径>"
})
```

等 reviewer 完成。

## 5. Quarto 渲染验证

```bash
quarto render --to html 2>&1 | tail -50
```

捕获 stdout/stderr。失败不阻断,把错误片段 append 到 REVIEW-chN.md 末尾。

## 6. 汇报给用户

无论成功失败,产出最终汇报:

```
✅ ch N 草稿生成完毕

- 草稿: outline/N-<标题>.md
- REVIEW: REVIEW-chN.md
- Quarto 渲染: <成功 / 失败(see REVIEW §E)>
- 当前分支: draft/chN

下一步:
1. 打开 REVIEW-chN.md 看 issue 列表
2. 在 draft/chN 上手动改
3. 满意后:
   git checkout main && git merge --no-ff draft/chN
4. 不满意:
   git checkout main && git branch -D draft/chN  # 然后调整 ideas 或 prompt 重跑
```

## 失败收尾

如 author 中途报错:
- 不调用 reviewer
- 报错给用户
- 提示:"草稿不完整,你可以在 draft/chN 上看 author 写到哪、决定继续还是 -D 重来"

如 reviewer 报错:
- 草稿文件保留(author 已 commit)
- 报错给用户
- 提示:"草稿存在但 review 跑挂了,可以手动 review 或重跑"
