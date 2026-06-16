# Skill开发强制要求

## 核心原则

**所有Skill必须在部署前调用pitfalls-checker.sh检查，确保不重复历史错误**

## 强制检查清单

### 1. PITFALLS规则检查
```bash
./.claude/skills/pitfalls-checker.sh html/exam-complete.html
```

**必须通过所有检查**:
- ✅ 页面导航函数完整
- ✅ 阅读答题功能存在
- ✅ CSS .selected存在
- ✅ 口语3个Teil范文完整
- ✅ 写作A1标准答案存在
- ✅ 无重复变量声明
- ✅ 无重复答案定义
- ✅ 听力音频不新窗口

### 2. 完整功能验证
```bash
./.claude/skills/comprehensive-verify.sh html/exam-complete.html
```

**必须验证所有功能**:
- ✅ 页面导航（4个函数）
- ✅ 答题功能（2个函数）
- ✅ 其他功能（翻译、朗读）
- ✅ 变量初始化
- ✅ CSS样式
- ✅ HTML onclick元素
- ✅ 函数总数统计

### 3. 开发流程

```
1. 开发前
   - [ ] 阅读PITFALLS.md
   - [ ] 列出所有功能点
   - [ ] 确认不会删除现有功能

2. 开发中
   - [ ] 使用合并而非完全替换
   - [ ] 保留所有原有函数
   - [ ] 添加Console日志

3. 开发后
   - [ ] 调用pitfalls-checker.sh ✅ 必须
   - [ ] 调用comprehensive-verify.sh ✅ 必须
   - [ ] 本地浏览器测试
   - [ ] 检查Console无错误

4. 部署前
   - [ ] 所有检查通过
   - [ ] 更新文档
   - [ ] 记录新的踩坑（如有）

5. 部署后
   - [ ] 等待120秒
   - [ ] 线上验证
   - [ ] 用户确认
```

## Skill模板

```bash
#!/bin/bash
set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "🔧 [Skill名称]"
echo "================================"

# 步骤1: 读取PITFALLS
echo "📖 检查PITFALLS规则..."
if [ -f "PITFALLS.md" ]; then
    echo "  ✅ PITFALLS.md存在"
else
    echo "  ❌ 未找到PITFALLS.md"
    exit 1
fi

# 步骤2: 执行修改
echo ""
echo "🔨 执行修改..."
# ... 你的代码 ...

# 步骤3: PITFALLS检查（强制）
echo ""
echo "🔍 PITFALLS规则检查..."
./.claude/skills/pitfalls-checker.sh html/exam-complete.html
if [ $? -ne 0 ]; then
    echo "❌ PITFALLS检查失败"
    exit 1
fi

# 步骤4: 完整功能验证（强制）
echo ""
echo "🔍 完整功能验证..."
./.claude/skills/comprehensive-verify.sh html/exam-complete.html
if [ $? -ne 0 ]; then
    echo "❌ 功能验证失败"
    exit 1
fi

# 步骤5: 复制到所有试卷
for f in uebungssatz01 uebungssatz02 modellsatz; do
    cp html/exam-complete.html html/${f}.html
done

# 步骤6: 提交部署
git add html/*.html
git commit -m "feat: [描述]

修改: [列表]
验证: 
✅ pitfalls-checker通过
✅ comprehensive-verify通过

Co-Authored-By: Claude Sonnet 4 <noreply@anthropic.com>"

git push

# 步骤7: 等待部署
sleep 120

# 步骤8: 线上验证
# ... 线上检查代码 ...

exit 0
```

## 违规后果

**如果Skill没有调用检查器就部署**:
1. 记录到PITFALLS.md
2. 标记为重复错误
3. 更新Skill添加检查

## 现有Skill更新状态

- [ ] copy-working-code.sh - 需要添加检查
- [ ] fix-onclick-inline.sh - 需要添加检查
- [ ] force-css-important.sh - 需要添加检查
- [x] pitfalls-checker.sh - 新创建
- [x] comprehensive-verify.sh - 已存在

## 关键规则

🔴 **所有Skill部署前必须调用pitfalls-checker.sh**
🔴 **所有Skill部署前必须调用comprehensive-verify.sh**
🔴 **验证失败不允许部署**
🔴 **新Skill必须使用模板**

---

**更新日期**: 2026-06-15  
**版本**: v1.0  
**状态**: 强制执行
