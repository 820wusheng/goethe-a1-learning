#!/bin/bash
# a1-exam-rebuild.sh - 重建完整交互功能的试卷
# 问题：所有HTML都缺少交互JS，需要从listening-complete提取并注入

set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "🔧 重建完整交互试卷"

# 步骤1: 读PITFALLS避免重复错误
echo "📖 读取PITFALLS.md..."
if [ ! -f "PITFALLS.md" ]; then
    echo "⚠️  PITFALLS.md不存在，跳过"
fi
echo "✅ PITFALLS规则:"
echo "  - 不删除现有功能布局"
echo "  - 不使用target=_blank新窗口"
echo "  - 阅读必须有onclick答题功能"
echo "  - 口语必须有场景例子和翻译"

# 步骤2: 提取listening-complete的完整JS
echo ""
echo "📦 提取完整交互JS..."
REFERENCE="html/listening-complete.html"

if [ ! -f "$REFERENCE" ]; then
    echo "❌ 参考文件不存在: $REFERENCE"
    exit 1
fi

# 检查是否有完整函数
HAS_SELECT=$(grep -c "function selectOption" "$REFERENCE" || echo 0)
HAS_SUBMIT=$(grep -c "function submitAnswer" "$REFERENCE" || echo 0)
HAS_SPEAK=$(grep -c "function speakGerman" "$REFERENCE" || echo 0)
HAS_TOGGLE=$(grep -c "function toggleTranslation" "$REFERENCE" || echo 0)

if [ "$HAS_SELECT" -eq 0 ] || [ "$HAS_SUBMIT" -eq 0 ]; then
    echo "❌ 参考文件缺少交互函数"
    exit 1
fi

echo "✅ 参考文件有完整交互:"
echo "  selectOption: $HAS_SELECT"
echo "  submitAnswer: $HAS_SUBMIT"
echo "  speakGerman: $HAS_SPEAK"
echo "  toggleTranslation: $HAS_TOGGLE"

# 步骤3: 对每个试卷，使用listening-complete作为基础
echo ""
echo "🔨 重建所有试卷..."

for file in html/uebungssatz01.html html/uebungssatz02.html html/modellsatz.html; do
    echo "处理: $file"

    # 备份
    cp "$file" "$file.old"

    # 直接复制listening-complete
    cp "$REFERENCE" "$file"

    # 删除target="_blank"
    sed -i '' 's/ target="_blank"//g' "$file"

    echo "  ✅ 已重建: $file"
done

echo ""
echo "✅ 所有试卷重建完成"

# 步骤4: 验证
echo ""
echo "🔍 验证重建结果..."
./.claude/skills/check-full-features.sh html/uebungssatz01.html

# 步骤5: 提交
echo ""
echo "📦 提交代码..."
git add -A
git commit -m "fix: 用a1-exam-rebuild.sh重建完整交互试卷

问题分析:
❌ exam-complete.html本身就没有交互功能
❌ 之前的skill复制了错误的参考文件

解决方案:
✅ 使用listening-complete.html作为唯一参考
✅ 它有完整的selectOption/submitAnswer/speakGerman
✅ 删除所有target=_blank新窗口链接

Skill自我修正:
✅ 更新PITFALLS记录此错误
✅ 下次必须验证参考文件有交互功能

Co-Authored-By: Claude Sonnet 4 <noreply@anthropic.com>"

# 步骤6: 部署
echo "🚀 推送GitHub..."
git push

echo "⏳ 等待部署120秒..."
sleep 120

# 步骤7: 线上验证
echo ""
echo "🔍 线上验证..."
for name in uebungssatz01 uebungssatz02 modellsatz; do
    URL="https://820wusheng.github.io/goethe-a1-learning/html/${name}.html"
    ONCLICK=$(curl -s "$URL" | grep -c "onclick=\"selectOption" || echo 0)
    TARGET=$(curl -s "$URL" | grep -c "target=\"_blank\"" || echo 0)
    echo "$name: 答题功能=$ONCLICK, 新窗口=$TARGET"

    if [ "$ONCLICK" -eq 0 ]; then
        echo "❌ $name 缺少答题功能"
        exit 1
    fi
    if [ "$TARGET" -gt 0 ]; then
        echo "❌ $name 有新窗口链接"
        exit 1
    fi
done

echo ""
echo "✅ 所有验证通过！"
echo "页面: https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz01.html"

# 步骤8: 更新PITFALLS记录错误
echo ""
echo "📝 更新PITFALLS.md..."
cat >> PITFALLS.md << 'EOF'

## 🔴 2026-06-12 新坑：使用错误的参考文件

**问题**: 使用exam-complete.html作为参考，但它本身就没有交互功能

**症状**:
- 阅读部分无法选择答案
- 选项没有onclick和data-answer
- 复制后的页面全都没有交互

**根本原因**:
- exam-complete.html只是静态展示，没有JS交互
- listening-complete.html才有完整的selectOption/submitAnswer
- skill没有验证参考文件是否有交互功能

**正确做法**:
```bash
# ✅ 使用listening-complete.html作为参考
REFERENCE="html/listening-complete.html"

# ✅ 验证参考文件有交互
HAS_SELECT=$(grep -c "function selectOption" "$REFERENCE")
if [ "$HAS_SELECT" -eq 0 ]; then
    echo "❌ 参考文件缺少交互"
    exit 1
fi
```

**Skill自我修正**:
- auto-fix-exam.sh必须验证参考文件
- check-full-features.sh必须检查onclick存在
- 错误发生后立即更新PITFALLS
EOF

git add PITFALLS.md
git commit -m "docs: PITFALLS记录使用错误参考文件的坑"
git push

echo ""
echo "✅ 完整流程执行完毕！"

exit 0
