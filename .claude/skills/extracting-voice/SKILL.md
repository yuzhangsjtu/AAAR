---
name: extracting-voice
description: Use to extract the AAAR author's writing voice from existing chapter samples (default outline/01-04) into a structured VOICE.md guide covering sentence patterns, paragraph structure, rhetoric, callout usage, personal voice markers, and forbidden patterns. Triggered by /refresh-voice slash command.
---

# Extracting Voice Skill

When invoked, perform corpus analysis on the AAAR chapter samples and produce a structured VOICE.md.

## Input

- 默认样本:`outline/` 下所有以两位数字开头的 .md 文件中**有实质内容(行数 > 50)**的章节
- 如调用方明确指定样本路径,优先使用指定的

## 执行步骤

1. 读取所有样本章节
2. 对下面每个维度,从样本里提取**具体**观察(数字、统计、原文示例),不要抽象描述
3. 按下面格式输出到目标文件(默认 `VOICE.md`,可由调用方指定路径)

## 输出格式

```markdown
# 写作风格指南

> 从 <样本路径列表> 提取,日期:YYYY-MM-DD

## 1. 句式特征

- **平均句长**: 约 N 字(基于样本统计)
- **长短句比例**: 长句(>40 字)占比约 X%
- **典型连接词**: 「但」「不过」「问题在于」「这意味着」「换句话说」...
- **示例句**: 「...」(出自 outline/0X-...md)

## 2. 段落结构

- **开头习惯**: ...
- **收尾习惯**: ...
- **过渡方式**: ...
- **段落长度**: 平均 N 句 / 段

## 3. 修辞与举例

- **隐喻类型**: 列举 3-5 种,各给一个原文示例
  - 例:身体 / 运动隐喻 — 「就像一个运动员每次觉得累了就让别人替他跑」(ch04)
  - 例:历史类比 — ...
- **举例方式**: 个人案例 / 历史事件 / 思想实验 / 学术研究 的占比
- **案例密度**: 每节平均 X 个具体例子

## 4. Callout 使用习惯

- **总频率**: 每章约 N 个 callout
- **`callout-warning`**: 用于...(给一个原文示例的标题与第一句)
- **`callout-tip`**: 用于...
- **`callout-note`**: 用于...(如样本中存在)

## 5. 个人语气标记

- **第二人称(你)频率**: 高/中/低,典型场景:...
- **反问句**: 频率 + 典型用法
- **口语化插入**: 「其实」「老实说」「说白了」... 列出实际出现的
- **个人观点标记**: 「我认为」「在我看来」... 频率与位置

## 6. 禁忌(从样本反推:从不/极少出现的)

- **避免使用的词**: ...
- **避免的句式**: ...(如:从不用「众所周知」「显而易见」)
- **避免的修辞**: ...(如:从不用排比堆砌)

## 7. 风格判定 checklist(给 reviewer 用)

判断一段是否符合风格,优先检查:

- [ ] 是否避免了第 6 节列出的禁忌
- [ ] 论证段是否包含至少 1 个具体例子
- [ ] callout 使用是否符合第 4 节的场景定义
- [ ] 长短句搭配是否符合第 1 节的比例
- [ ] 是否使用了第 1 节列出的典型连接词中的至少一个(每节)
```

## 重要

- 数字(N、X)必须基于实际样本统计,不可虚构
- 示例必须是样本中的**逐字原文**,标注来源:「...」(ch0X §N)
- 不要推断样本中不存在的风格偏好
- VOICE.md 总长控制在 ~150 行内
- 如果样本不足(< 2 个有内容的章节),报错并提示调用方
