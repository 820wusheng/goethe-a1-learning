# 🇩🇪 Goethe A1 完整学习资源

完整的Goethe A1级别德语学习资源，包含听力练习和词汇学习。

## 📁 文件说明

### 主要页面

- **`index-main.html`** - 学习中心首页（导航页）
- **`listening-complete.html`** - 完整听力练习页面 ⭐ **推荐使用**
  - 包含所有15个题目 + 2个示例
  - 完整的德语原文（通过Whisper AI从官方音频转录）
  - 完整的中文翻译
  - AI朗读功能（浏览器内置）
  - 官方音频链接
  - 题目和选项
- **`vocabulary.html`** - 词汇学习页面
  - 2,073个A1词汇
  - 788个重点词汇（绿色标记）
  - 例句和翻译
  - 音频播放

### 数据文件

- **`transcripts_with_translation.json`** - 听力原文和翻译数据
- **`vocabulary_data.json`** - 词汇数据

### 音频文件

- **`audio/`** 目录 - 包含所有官方音频文件（17个MP4文件）
- **`audio/transcripts/`** - Whisper AI转录的文本文件

## 🚀 使用方法

1. 启动本地服务器：
```bash
cd /Users/wusheng820/Downloads/goethe-a1-exam
python3 -m http.server 8080
```

2. 打开浏览器访问：
- **主页**：http://localhost:8080/index-main.html
- **听力练习**：http://localhost:8080/listening-complete.html
- **词汇学习**：http://localhost:8080/vocabulary.html

## ✨ 功能特点

### 听力练习

- ✅ **完整原文**：所有15个题目的完整德语原文
- ✅ **AI转录**：使用OpenAI Whisper从官方音频转录，保证准确性
- ✅ **中文翻译**：每句话都有对应的中文翻译
- ✅ **双音频系统**：
  - 🔊 **AI朗读**：点击后直接播放（浏览器内置德语语音）
  - 📻 **官方音频**：链接到Goethe官方音频文件
- ✅ **题目和选项**：完整的问题和选择项
- ✅ **三个部分**：
  - Teil 1: 对话（7个题目）
  - Teil 2: 通知（5个题目）
  - Teil 3: 电话留言（5个题目）

### 词汇学习

- ✅ 2,073个A1级别单词
- ✅ 788个重点词汇绿色标记
- ✅ 每个单词都有例句
- ✅ 例句翻译功能
- ✅ 搜索和筛选功能
- ✅ 分页显示

## 🔧 技术实现

### 听力原文获取

1. 下载Goethe官方音频文件（17个MP4）
2. 使用OpenAI Whisper AI进行语音识别转录
3. 使用MyMemory Translation API翻译成中文
4. 整理成JSON格式供页面使用

### 转录命令

```bash
# 安装Whisper
pip3 install openai-whisper

# 安装ffmpeg
brew install ffmpeg

# 转录音频
whisper audio_file.mp4 --language German --model base --output_format txt --output_dir transcripts
```

## 📊 数据统计

- 听力题目：15题 + 2个示例 = 17个音频
- 词汇总数：2,073个
- 重点词汇：788个
- 例句数量：2,073个
- 翻译条目：2,073 + 17 = 2,090个

## ⚠️ 重要说明

1. **音频准确性**：
   - 所有听力原文都是通过Whisper AI从官方音频转录
   - 转录准确率很高，但可能存在个别识别错误
   - 已手动检查主要内容，基本准确

2. **翻译质量**：
   - 使用MyMemory Translation API自动翻译
   - 翻译质量较好，但可能不够地道
   - 建议作为辅助理解工具使用

3. **音频播放**：
   - AI朗读使用浏览器内置功能，可能因浏览器不同而有差异
   - 官方音频链接需要联网访问Goethe网站

## 📝 更新日志

### 2026-06-11

- ✅ 使用Whisper AI转录所有17个官方音频
- ✅ 添加完整的中文翻译
- ✅ 创建listening-complete.html完整听力页面
- ✅ 修复音频播放功能
- ✅ 添加所有题目和选项
- ✅ 优化页面设计和用户体验

### 之前版本

- 创建词汇学习页面
- 添加重点词汇标记
- 实现搜索和筛选功能

## 🙏 致谢

- Goethe-Institut 提供官方学习资源
- OpenAI Whisper 提供语音识别技术
- MyMemory Translation API 提供翻译服务

---

**祝学习愉快！Viel Erfolg! 🎉**
