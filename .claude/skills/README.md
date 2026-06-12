# A1 德语学习网站 - Skills 使用手册

## 什么是 Skill？

Skill 是可执行的自动化脚本，确保每次开发都遵循相同的标准流程，避免重复错误。

## 可用 Skills

### 1. verify-a1-dev.sh - 开发验证

**作用**: 验证代码是否符合所有规范

**用法**:
```bash
cd /Users/wusheng820/Downloads/goethe-a1-exam
./.claude/skills/verify-a1-dev.sh
```

**检查项**:
- ✅ AI朗读按钮数量 = 4
- ✅ quiz-common.js无题目定义冲突
- ✅ 数据文件完整（archive_uebung01.json等）
- ✅ 配置文件正确（uebung01-config.js等）
- ✅ speakGerman使用原生Web Speech API
- ✅ 每题有AI朗读按钮
- ✅ 禁止target="_blank"新窗口音频
- ✅ 无占位符内容（"开发中"/"TODO"等）

**输出示例**:
```
🔍 开始A1网站验证...
✅ AI朗读按钮: 4
✅ 无题目定义冲突
✅ 数据文件完整
✅ 配置文件正确
✅ speakGerman原生朗读功能
✅ 每题有AI朗读按钮: 3
✅ 无新窗口音频链接
✅ 无占位符内容

✅ 所有验证通过！可以部署。
```

---

### 2. develop-a1-exam.sh - 试卷开发

**作用**: 从参考页面复制完整4部分结构（Hören + Lesen + Schreiben + Sprechen）

**用法**:
```bash
# 开发单个试卷
./.claude/skills/develop-a1-exam.sh html/uebungssatz01.html

# 开发所有试卷
./.claude/skills/develop-a1-exam.sh html/uebungssatz01.html
./.claude/skills/develop-a1-exam.sh html/uebungssatz02.html
./.claude/skills/develop-a1-exam.sh html/modellsatz.html
```

**工作流程**:
1. 检查参考页面 exam-complete.html 完整性
2. 复制完整4部分结构到目标文件
3. 自动创建备份 `<target>.backup`
4. 运行 verify-a1-dev.sh 验证
5. 输出成功信息

**输出示例**:
```
🔧 A1试卷开发skill
参考: html/exam-complete.html
目标: html/uebungssatz01.html
✅ 参考页面完整: Lesen=11, Schreiben=10, Sprechen=9
📋 复制完整4部分结构...
✅ 已复制完整结构
✅ 所有验证通过！可以部署。

✅ 开发完成！
备份: html/uebungssatz01.html.backup
```

---

## 完整开发流程（强制）

### 步骤1: 开发前准备
```bash
# 1. 读PITFALLS避免重复错误
cat PITFALLS.md

# 2. 确认在正确目录
cd /Users/wusheng820/Downloads/goethe-a1-exam
```

### 步骤2: 使用skill开发
```bash
# 开发新试卷
./.claude/skills/develop-a1-exam.sh html/uebungssatz03.html
```

### 步骤3: 本地验证
```bash
# 运行验证skill
./.claude/skills/verify-a1-dev.sh

# 启动本地服务器测试
python3 -m http.server 8085
# 访问 http://localhost:8085/html/uebungssatz03.html
```

### 步骤4: 提交部署
```bash
# 提交代码
git add -A
git commit -m "feat: 用develop-a1-exam.sh开发uebungssatz03

Skill执行:
✅ develop-a1-exam.sh uebungssatz03.html
✅ verify-a1-dev.sh验证通过

Co-Authored-By: Claude Sonnet 4 <noreply@anthropic.com>"

# 推送
git push

# 等待GitHub Pages部署
sleep 120
```

### 步骤5: 线上验证
```bash
# 验证4部分完整
curl -s "https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz03.html" | grep -c "Lesen"
curl -s "https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz03.html" | grep -c "Schreiben"
curl -s "https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz03.html" | grep -c "Sprechen"

# 期望: 每个都>0
```

---

## 为什么必须用Skill？

### ❌ 不用Skill的问题
- 忘记检查项，反复犯同样错误
- 手动检查遗漏，部署后才发现问题
- 每次流程不一致，质量不稳定
- 用户反馈："为什么重复犯错？"

### ✅ 用Skill的好处
- 自动化检查，100%覆盖所有规则
- 统一标准，每次开发质量一致
- 发现错误时自动fail，不会部署坏代码
- 可重复、可审计、可持续改进

---

## Skill开发规则

### 规则1: 必须用Skill开发
所有新功能开发**必须**调用skill脚本，不能手动改代码

### 规则2: 失败必须修复
如果skill报错，**必须**修复问题直到通过，不能跳过

### 规则3: 错误必须记录
每次发现新错误，**必须**更新skill脚本添加检查

### 规则4: 自闭环验证
开发→skill验证→部署→线上验证，全程自动化，不依赖人工

---

## 添加新检查项到Skill

发现新问题时，更新 verify-a1-dev.sh：

```bash
# 编辑skill
vim .claude/skills/verify-a1-dev.sh

# 添加检查（例如：检查是否有A2语法）
echo "# 9. 检查是否有A2语法" >> .claude/skills/verify-a1-dev.sh
echo 'A2_GRAMMAR=$(grep -r "Präteritum\|wurde\|hatte" data/*.json || echo "")' >> .claude/skills/verify-a1-dev.sh
echo 'if [ -n "$A2_GRAMMAR" ]; then' >> .claude/skills/verify-a1-dev.sh
echo '    echo "❌ 错误: 发现A2语法，必须是A1级别"' >> .claude/skills/verify-a1-dev.sh
echo '    exit 1' >> .claude/skills/verify-a1-dev.sh
echo 'fi' >> .claude/skills/verify-a1-dev.sh
echo 'echo "✅ 无A2语法"' >> .claude/skills/verify-a1-dev.sh

# 测试
./.claude/skills/verify-a1-dev.sh

# 提交
git add .claude/skills/verify-a1-dev.sh
git commit -m "feat: skill增加A2语法检查"
```

---

## 常见问题

**Q: 如果skill报错怎么办？**
A: 看错误信息，修复代码，重新运行skill直到通过

**Q: 可以跳过skill直接部署吗？**
A: 不可以！必须skill验证通过才能部署

**Q: 如何知道skill是否最新？**
A: 每次开发前 `git pull` 获取最新skill

**Q: 能否手动改代码不用skill？**
A: 不能！所有开发必须用skill，这是硬性规则

---

## 历史错误记录

见 PITFALLS.md 文件，记录了所有历史错误和避免方法。

---

**最后更新**: 2026-06-12  
**维护者**: Claude Sonnet 4
