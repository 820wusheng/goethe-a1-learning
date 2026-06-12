---
name: goethe-a1-dev
description: "Goethe A1德语学习网站开发。自动生成听力/阅读/写作/口语4个部分的完整页面，包含答题系统、AI朗读、德汉翻译。严格遵循PITFALLS.md避免重复错误。触发词：添加听力题、新增阅读、开发Goethe页面、A1试卷"
category: education
author: "Claude"
---

# Goethe A1 Learning Website Developer

自动开发Goethe-Zertifikat A1德语学习网站的听力/阅读/写作/口语功能页面。

## When to Use This Skill

**触发场景**：
- 用户要求"添加听力题目"
- 用户要求"新增阅读部分"
- 用户要求"开发完整试卷页面"
- 用户要求"添加写作/口语功能"

**关键词**：
- 中文：添加听力题、新增阅读、开发页面、A1试卷、德语学习
- English: add listening、create reading、develop page、A1 exam

**不触发场景**：
- 修复现有功能问题（使用goethe-a1-fix skill）
- 纯粹的翻译工作（手动完成）

## 核心功能

### 1. 强制流程遵守
- **开发前必读PITFALLS.md**（不能跳过）
- **本地测试后再部署**（不能直接push）
- **自闭环验证**（本地+线上都要实测）

### 2. 页面开发
- Hören (听力)：17题，3个Teil，AI朗读+官方音频
- Lesen (阅读)：15题，3个Teil
- Schreiben (写作)：2个Teil，表单+示例
- Sprechen (口语)：3个Teil，对话卡片

### 3. 功能特性
- ✅ AI朗读按钮（speakGerman函数）
- ✅ 官方音频播放器（archive_audio/）
- ✅ 答题系统（选择→提交→对错→分数）
- ✅ 德汉翻译切换
- ✅ 响应式设计

## Setup & Prerequisites

### 环境检查

```bash
# 1. Python环境
python3 --version

# 2. 启动本地服务器
cd /path/to/goethe-a1-exam
python3 -m http.server 8085

# 3. 验证数据文件存在
ls data/archive_uebung01.json
ls archive_audio/sd1_uebungssatz_01.mp4
```

## 工作流程（强制执行）

### 阶段1: 开发前准备（必须执行）

```bash
# 1. 读PITFALLS.md（不能跳过）
Read PITFALLS.md

# 2. 创建TODO检查清单
TodoWrite([
  "已读PITFALLS.md",
  "本地测试通过",
  "线上验证通过"
])

# 3. 确认避免措施
- ❌ 不添加占位符文本（"开发中..."）
- ❌ 不删除现有功能布局
- ❌ 不直接push未测试代码
- ✅ 要么不做，要么做完整
```

### 阶段2: 代码开发

```bash
# 1. 使用quiz-common.js共享代码
- speakGerman()函数已存在
- renderTeil1/2/3()渲染题目
- 朗读按钮自动生成

# 2. HTML页面结构
<!DOCTYPE html>
<html>
<head>...</head>
<body>
    <div class="container">
        <!-- 音频播放器 -->
        <audio controls>
            <source src="../archive_audio/sd1_uebungssatz_01.mp4">
        </audio>
        
        <!-- Teil导航 -->
        <div class="nav-tabs">
            <button onclick="showTeil('teil1')">Teil 1</button>
            <button onclick="showTeil('teil2')">Teil 2</button>
            <button onclick="showTeil('teil3')">Teil 3</button>
        </div>
        
        <!-- 题目容器 -->
        <div id="teil1" class="teil-section active"></div>
        <div id="teil2" class="teil-section"></div>
        <div id="teil3" class="teil-section"></div>
    </div>
    
    <!-- 引用JS -->
    <script src="../js/uebung01-config.js"></script>
    <script src="../js/quiz-common.js"></script>
    <script>
        loadData();
        loadAnswers();
    </script>
</body>
</html>
```

### 阶段3: 本地测试（强制）

```bash
# 1. 启动服务器
python3 -m http.server 8085

# 2. 验证AI朗读按钮
curl -s http://localhost:8085/js/quiz-common.js | grep -c "AI朗读"
# 期望: 4

# 3. 验证数据文件
curl -I http://localhost:8085/data/archive_uebung01.json
# 期望: HTTP/1.0 200 OK

# 4. 检查无占位符
grep -i "开发中\|内容\.\.\.\|todo" html/*.html
# 期望: 无匹配
```

### 阶段4: 提交部署

```bash
# 1. 提交代码
git add -A
git commit -m "feat: xxx

完成:
- ✅ 具体功能
- ✅ 已读PITFALLS.md
- ✅ 本地测试通过

Co-Authored-By: Claude Sonnet 4 <noreply@anthropic.com>"

# 2. 推送
git push

# 3. 等待GitHub Pages部署
sleep 120
```

### 阶段5: 线上验证（强制）

```bash
# 1. 验证JS文件
curl -s "https://820wusheng.github.io/goethe-a1-learning/js/quiz-common.js" | grep -c "AI朗读"
# 期望: 4

# 2. 验证HTML
curl -I "https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz01.html"
# 期望: HTTP/2 200

# 3. 验证数据文件
curl -I "https://820wusheng.github.io/goethe-a1-learning/data/archive_uebung01.json"
# 期望: HTTP/2 200
```

## 强制检查清单

### 开发前
- [ ] 已读PITFALLS.md全文
- [ ] 已创建TODO清单
- [ ] 确认不重复历史错误

### 开发中
- [ ] 不使用占位符文本
- [ ] 不删除现有功能
- [ ] 使用quiz-common.js共享代码

### 提交前
- [ ] 本地服务器测试通过
- [ ] curl验证AI朗读数量=4
- [ ] grep无占位符文本
- [ ] 所有文件完整

### 部署后
- [ ] 等待120秒部署完成
- [ ] curl验证线上AI朗读=4
- [ ] 访问GitHub Pages确认功能

## 已知问题记录（PITFALLS）

### Pit 0: 使用占位符代替完整内容
❌ 错误：`<p>内容开发中...</p>`
✅ 正确：要么不做，要么做完整

### Pit 1: 删除现有功能布局
❌ 错误：删除speakGerman函数和朗读按钮
✅ 正确：保留现有功能，只改实现

### Pit 2: 不做自闭环测试
❌ 错误：git push后直接说"完成"
✅ 正确：本地测试→push→等待部署→线上验证

### Pit 3: force push破坏部署
❌ 错误：git push -f到main分支
✅ 正确：开发用feature分支，合并用PR

## 文件结构

```
goethe-a1-exam/
├── html/
│   ├── uebungssatz01.html      # 练习01（引用quiz-common.js）
│   ├── uebungssatz02.html      # 练习02
│   ├── modellsatz.html         # 模拟题
│   └── listening-complete.html # 完整听力（有AI朗读）
├── js/
│   ├── quiz-common.js          # 共享答题系统（包含speakGerman）
│   ├── uebung01-config.js      # 练习01配置
│   ├── uebung02-config.js      # 练习02配置
│   └── modellsatz-config.js    # 模拟题配置
├── data/
│   ├── archive_uebung01.json   # 听力数据
│   ├── archive_uebung02.json
│   └── transcripts_with_translation.json
├── archive_audio/
│   ├── sd1_uebungssatz_01.mp4  # 官方完整音频
│   ├── sd1_uebungssatz_02.mp4
│   └── sd1_modellsatz.mp4
├── .claude/skills/
│   ├── goethe-a1-dev/          # 开发skill（本文件）
│   └── goethe-a1-fix/          # 修复skill
└── PITFALLS.md                 # 踩坑记录（必读）
```

## 输出示例

```
✅ Goethe A1页面开发完成

开发内容:
- 练习试卷01：17道听力题
- AI朗读按钮：每题都有🔊按钮
- 官方音频：完整音频播放器
- 答题系统：选择→提交→对错→分数

自测结果:
✓ 已读PITFALLS.md
✓ 本地测试通过（AI朗读按钮: 4个）
✓ 无占位符文本
✓ 推送到GitHub
✓ 等待部署120秒
✓ 线上验证通过（AI朗读按钮: 4个）

访问地址:
https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz01.html

代码已提交:
https://github.com/820wusheng/goethe-a1-learning
```

## 常见问题

**Q: 为什么必须读PITFALLS.md？**
A: 避免重复历史错误（占位符、删除功能、不测试等）

**Q: 为什么本地测试后还要线上验证？**
A: 确保GitHub Pages部署正常，文件路径正确

**Q: quiz-common.js是什么？**
A: 共享答题系统，包含speakGerman、renderTeil等所有页面通用的功能

**Q: 如何确认AI朗读功能正常？**
A: `grep -c "AI朗读" js/quiz-common.js` 应该返回4
