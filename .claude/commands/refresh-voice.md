---
description: 从 outline/01-NN 提取作者写作风格到 VOICE.md,用户审阅后 commit
---

# /refresh-voice

执行以下步骤:

## 1. 前置检查

- 用 Glob 列出 `outline/*.md` 中所有以两位数字开头且行数 > 50 的章节
- 如不到 2 个,告诉用户「样本不足(需要至少 2 章已有实质内容),先写完几章再跑此命令」并退出

## 2. 已有 VOICE.md 检查

- 如果仓库根 `VOICE.md` 已存在,问用户:
  - "VOICE.md 已存在。覆盖 / 取消?(默认取消)"
- 用户选 "取消" → 退出
- 用户选 "覆盖" → 继续

## 3. 调用 skill

- 用 Skill 工具调用 `extracting-voice` skill
- 产物落到仓库根 `VOICE.md`(skill 默认路径)

## 4. 用户审阅

呈现完整 VOICE.md 内容给用户,提示:

> "VOICE.md 已生成 (N 行)。请你 review 一下,根据需要在文件里直接标注/修改 (10-20 分钟)。改完保存,告诉我「可以 commit」或「再改一版」。"

## 5. 用户确认后 commit

```bash
git add VOICE.md
git commit -m "voice: refresh VOICE.md from outline/01-NN"
```

## 失败处理

- outline/ 没有任何符合条件的章节文件 → 立即退出,见 Step 1
- 用户在审阅阶段说「再改一版」 → 不 commit,退出,等用户手动改
- 调用 skill 报错 → 把错误转告用户,不创建 VOICE.md
