---
name: goethe-a1-fix
description: "修复Goethe A1学习网站功能问题。自动检测、验证并修复听力页面的AI朗读按钮、数据加载、GitHub Pages部署等问题。触发词：修复朗读按钮、fix audio、恢复功能、页面404、GitHub Pages"
author: "Claude"
---

# Goethe A1 功能修复工具

自动诊断并修复Goethe A1德语学习网站的常见问题。

## When to Use This Skill

当出现以下问题时：
- 听力页面AI朗读按钮缺失
- 题目内容不显示（空白页面）
- GitHub Pages返回404
- 音频播放器无法加载
- JavaScript加载失败

**触发词**：修复朗读按钮、fix audio、恢复功能、页面404、GitHub Pages、听力不显示

## 功能

### 0. ⚠️ 铁律：禁止指挥用户
- **绝对禁止**要求用户"打开浏览器看Console"
- **绝对禁止**要求用户"检查xxx"、"告诉我xxx"
- **必须自己**用curl/grep/git/diff完成所有诊断
- **必须自己**完成闭环验证，不依赖用户反馈

### 1. 自动诊断
- 检测页面是否有AI朗读按钮（speakGerman函数）
- 验证quiz-common.js是否正确加载
- 检查数据文件（archive_uebung01.json）是否可访问
- 确认GitHub Pages部署状态

### 2. 自动修复
- 恢复历史正确版本的代码
- 修复JavaScript引用路径
- 重新部署到GitHub Pages
- 验证线上功能正常

### 3. 自闭环验证
- 本地服务器测试（http://localhost:8085）
- 线上部署验证（GitHub Pages）
- 功能完整性检查（朗读按钮、题目显示、音频播放）

## 使用方法

### 自动修复（推荐）

```bash
/goethe-a1-fix
```

工具会自动：
1. 检测当前问题
2. 从git历史找到正确版本
3. 恢复功能代码
4. 本地验证
5. 推送到GitHub
6. 等待部署并线上验证

### 手动指定问题

```bash
/goethe-a1-fix --issue audio-button
/goethe-a1-fix --issue github-pages
/goethe-a1-fix --issue data-loading
```

## 工作流程

```
1. 读取PITFALLS.md了解历史问题
   ↓
2. git reflog查找正确版本
   ↓
3. 本地测试验证功能
   ├─ 启动http.server 8085
   ├─ curl检查speakGerman数量
   └─ 验证数据文件加载
   ↓
4. 确认正确后推送GitHub
   ├─ git push
   ├─ sleep 120等待部署
   └─ curl验证线上版本
   ↓
5. 输出修复报告
```

## 检查清单

修复前必查：
- [ ] 已读PITFALLS.md
- [ ] git reflog查看历史
- [ ] 找到有speakGerman的版本

修复中必做：
- [ ] 本地启动服务器测试
- [ ] curl检查speakGerman数量>0
- [ ] 检查quiz-common.js存在
- [ ] 验证数据文件可访问

修复后必验：
- [ ] git push成功
- [ ] 等待120秒部署
- [ ] curl检查线上speakGerman>0
- [ ] 访问GitHub Pages确认功能正常

## 已知正确版本

根据git历史，以下版本已验证功能正常：
- `9375539` - feat: 完成3套完整试卷功能
- `listening-complete.html` 有AI朗读按钮

恢复命令：
```bash
git checkout 9375539 -- html/listening-complete.html
git add html/listening-complete.html
git commit -m "fix: 恢复listening-complete.html的AI朗读功能"
git push
```

## 常见问题

**Q: 为什么GitHub Pages显示404？**
A: 可能是force push破坏了部署。解决：回退到28bc501或更早的稳定版本。

**Q: 为什么朗读按钮消失了？**
A: 可能删除了speakGerman函数或quiz-common.js。解决：从9375539恢复。

**Q: 如何验证修复成功？**
A: 必须同时验证本地和线上，curl检查speakGerman数量>0。

## 输出示例

```
✅ Goethe A1 功能修复完成

问题诊断:
- 当前版本: 28bc501
- speakGerman数量: 0（本地）, 0（线上）
- 问题: AI朗读按钮缺失

修复操作:
- 从9375539恢复listening-complete.html
- 验证本地speakGerman: 4个 ✓
- 推送到GitHub
- 等待部署120秒
- 验证线上speakGerman: 4个 ✓

访问地址:
https://820wusheng.github.io/goethe-a1-learning/html/listening-complete.html

下次避免:
- 不要force push到main分支
- 修改前先git checkout -b feature分支
- 删除代码前先grep检查影响范围
```
