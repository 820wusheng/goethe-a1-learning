# 🇩🇪 Goethe A1 完整学习资源

[![GitHub Pages](https://img.shields.io/badge/在线访问-GitHub%20Pages-blue?style=for-the-badge&logo=github)](https://820wusheng.github.io/goethe-a1-learning/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Skill](https://img.shields.io/badge/开发方式-Skill强制检查-orange?style=for-the-badge)](#-给开发者)

完整的 Goethe-Zertifikat A1 (Start Deutsch 1) 学习资源，包含听力、阅读、写作、口语练习和词汇学习。

**⭐ 特色**: 基于Skill开发，强制质量检查，避免历史错误

**🌐 在线体验**: [https://820wusheng.github.io/goethe-a1-learning/](https://820wusheng.github.io/goethe-a1-learning/)

---

## 🎯 给开发者

如果你想基于本项目开发新功能或修复问题：

📖 **必读文档**:
- [SKILL_USAGE.md](SKILL_USAGE.md) - Skill使用指南（强烈推荐）
- [PITFALLS.md](PITFALLS.md) - 历史踩坑记录（开发前必读）
- [.claude/skills/goethe-a1-builder.md](.claude/skills/goethe-a1-builder.md) - Skill定义

🚀 **使用Skill开发**:
```bash
# 在Claude Code中调用
/goethe-a1-builder

# Skill会强制执行25项检查，确保质量
```

**为什么使用Skill?**
- ✅ 避免重复历史错误（8大类坑）
- ✅ 强制执行开发流程（6个阶段）
- ✅ 自动检查清单（25项）
- ✅ 确保浏览器测试
- ✅ 三次确认才提交

---

## 📁 目录结构

```
goethe-a1-exam/
├── html/                    # 📄 主要HTML页面
│   ├── index-main.html      # 学习中心首页（推荐从这里开始）
│   ├── listening-complete.html  # 完整听力练习（17题+音频+翻译）
│   ├── exam-complete.html   # 完整考试练习（4个部分）
│   └── vocabulary.html      # 词汇学习（2,073个单词）
├── data/                    # 📊 数据文件
│   ├── vocabulary_data.json # 词汇数据
│   ├── transcripts_with_translation.json  # 听力原文+翻译
│   └── transcripts.json     # 听力原文（仅德语）
├── audio/                   # 🎵 音频文件
│   ├── audio_bsp1.mp4       # 17个官方音频文件
│   ├── ...
│   └── transcripts/         # Whisper AI转录文本
├── scripts/                 # 🐍 Python脚本
│   ├── correct_transcripts.py      # 修正转录脚本
│   └── ...
└── pages/                   # 📦 旧版本（备份）
```

## 🚀 快速开始

### 🌐 在线访问（推荐）

**无需安装，直接访问**：

👉 **https://820wusheng.github.io/goethe-a1-learning/**

- ✅ 手机/平板/电脑都可访问
- ✅ 无需下载代码
- ✅ 无需启动服务器
- ✅ HTTPS安全加密
- ✅ 全球CDN加速

---

### 💻 本地运行（开发用）

如果需要本地开发或离线使用：

#### 1. 启动本地服务器

```bash
cd /path/to/goethe-a1-learning
python3 -m http.server 8080
```

#### 2. 在浏览器中打开

- **学习中心首页**：http://localhost:8080/html/index-main.html
- **听力练习**：http://localhost:8080/html/listening-complete.html
- **完整考试**：http://localhost:8080/html/exam-complete.html
- **词汇学习**：http://localhost:8080/html/vocabulary.html

## ✨ 功能特点

### 🎧 听力练习（Hören）
- ✅ **17个题目**：15个正式题目 + 2个示例
- ✅ **完整原文**：根据PDF官方转录手动修正
- ✅ **准确翻译**：每句话都有对应的中文翻译
- ✅ **双音频系统**：
  - 🔊 AI朗读：点击直接播放（浏览器内置德语语音）
  - 📻 官方音频：链接到Goethe官方音频文件
- ✅ **三个部分**：
  - Teil 1: Gespräche 对话（7题）
  - Teil 2: Durchsagen 通知（5题）
  - Teil 3: Telefonansagen 电话留言（5题）

### 📖 阅读理解（Lesen）
- ✅ **15个题目**：3个Teil
- ✅ **真实材料**：邮件、广告、通知等
- ✅ **德汉翻译**：一键切换显示/隐藏翻译

### ✍️ 写作练习（Schreiben）
- ✅ **Teil 1**：填写表格（博登湖环游报名表）
- ✅ **Teil 2**：写短信（旅游咨询信）
- ✅ **示例答案**：提供参考写作范例
- ✅ **写作要求**：详细说明（约30个单词）

### 💬 口语练习（Sprechen）
- ✅ **Teil 1**：自我介绍（7个话题）
- ✅ **Teil 2**：询问和提供信息（饮食、购物）
- ✅ **Teil 3**：提出请求并回应（12个情景）
- ✅ **示例对话**：提供参考对话

### 📚 词汇学习
- ✅ **2,073个A1词汇**
- ✅ **788个重点词汇**（绿色标记）
- ✅ **每个单词都有例句**
- ✅ **例句翻译功能**
- ✅ **搜索和筛选**
- ✅ **分页显示**（50词/页）

## 📊 数据统计

- **听力题目**：17个（15题 + 2示例）
- **阅读题目**：15个
- **写作任务**：2个
- **口语部分**：3个
- **词汇总数**：2,073个
- **重点词汇**：788个
- **翻译条目**：2,090个

## 🔧 技术实现

### 听力原文获取
1. 下载Goethe官方音频文件（17个MP4）
2. 使用OpenAI Whisper AI进行语音识别转录
3. 对照PDF官方Transkriptionen手动修正
4. 手动翻译成中文
5. 整理成JSON格式供页面使用

### 主要技术
- **Web Speech API**：德语AI朗读（浏览器内置）
- **JSON数据驱动**：所有内容通过JSON文件加载
- **响应式设计**：适配手机和电脑
- **纯前端实现**：无需后端服务器

## ⚠️ 重要说明

1. **音频准确性**：
   - 听力原文经过Whisper AI转录后，参照PDF官方转录手动修正
   - 主要修正：房间号、价格、人名等关键信息
   - 整体准确率：100%（已手动校对）

2. **翻译质量**：
   - 所有翻译都经过人工检查和修正
   - 人名保持原文（如Schneider = 施奈德）
   - 数字准确翻译（如19,95 Euro = 19.95欧元）

3. **音频播放**：
   - AI朗读：使用浏览器内置功能，不同浏览器效果可能不同
   - 官方音频：需要联网访问Goethe网站

## 📝 更新日志

### 2026-06-11 v2.0

#### ✅ 重大更新
- **修正所有听力原文**：对照PDF官方转录，修正Whisper AI识别错误
- **重写所有翻译**：修正自动翻译错误，确保准确性
- **创建完整考试页面**：包含听力、阅读、写作、口语4个部分
- **整理目录结构**：分类存放HTML、数据、脚本文件

#### 修正内容示例
- ❌ 错误：Zimmer 250 → ✅ 正确：Zimmer 254
- ❌ 错误：1995 Euro → ✅ 正确：19,95 Euro
- ❌ 错误：裁缝 → ✅ 正确：施奈德先生
- ❌ 错误：Polo衫 → ✅ 正确：毛衣（Pullover）

### 2026-06-11 v1.0
- 创建词汇学习页面（2,073个单词）
- 创建听力练习页面框架
- 实现音频播放功能

## 🙏 致谢

- **Goethe-Institut**：提供官方学习资源
- **OpenAI Whisper**：提供语音识别技术
- **官方PDF文档**：sd_1_modellsatz.pdf（转录参考）

---

**祝学习愉快！Viel Erfolg bei der Prüfung! 🎉**
