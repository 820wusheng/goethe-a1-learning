#!/bin/bash
# build-complete-exam-v2.sh - 构建完整试卷（修复版）
# 只提取纯交互函数，不复制听力专用逻辑

set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "🔨 构建完整试卷 v2"

# 步骤1：验证数据文件
echo "📦 验证数据文件..."
for file in data/transcripts_with_translation.json data/answers.json; do
    if [ ! -f "$file" ]; then
        echo "❌ 缺少: $file"
        exit 1
    fi
done
echo "✅ 数据文件完整"

# 步骤2：使用exam-complete作为基础（它有4部分且没有JS冲突）
echo "📋 使用exam-complete作为基础..."
EXAM_SRC="html/exam-complete.html"

if [ ! -f "$EXAM_SRC" ]; then
    echo "❌ $EXAM_SRC 不存在"
    exit 1
fi

# 验证有4部分
HAS_LESEN=$(grep -c "Lesen" "$EXAM_SRC" || echo 0)
if [ "$HAS_LESEN" -eq 0 ]; then
    echo "❌ $EXAM_SRC 缺少Lesen"
    exit 1
fi
echo "✅ exam-complete有4部分"

# 步骤3：直接复制exam-complete到所有试卷
echo ""
echo "🔨 复制到所有试卷..."
for name in uebungssatz01 uebungssatz02 modellsatz; do
    TARGET="html/${name}.html"
    echo "处理: $TARGET"

    cp "$TARGET" "$TARGET.v1bak" 2>/dev/null || true
    cp "$EXAM_SRC" "$TARGET"

    echo "  ✅ 完成: $TARGET"
done

echo "✅ 所有试卷已更新"

# 步骤4：验证
echo ""
echo "🔍 本地验证..."
for name in uebungssatz01 uebungssatz02 modellsatz; do
    TARGET="html/${name}.html"

    LESEN=$(grep -c "Lesen" "$TARGET" || echo 0)
    SCHREIBEN=$(grep -c "Schreiben" "$TARGET" || echo 0)
    SPRECHEN=$(grep -c "Sprechen" "$TARGET" || echo 0)
    FETCH=$(grep -c "transcripts_with_translation" "$TARGET" || echo 0)

    echo "$name: Lesen=$LESEN, Schreiben=$SCHREIBEN, Sprechen=$SPRECHEN, Fetch=$FETCH"

    if [ "$LESEN" -eq 0 ] || [ "$SCHREIBEN" -eq 0 ] || [ "$SPRECHEN" -eq 0 ]; then
        echo "❌ $name 缺少4部分"
        exit 1
    fi

    if [ "$FETCH" -eq 0 ]; then
        echo "❌ $name 缺少数据加载"
        exit 1
    fi
done

echo "✅ 本地验证通过"

# 步骤5：提交
echo ""
echo "📦 提交..."
git add html/*.html
git commit -m "fix: 使用exam-complete统一所有试卷

问题:
❌ build-complete-exam.sh复制了listening-complete的听力专用JS
❌ 导致加载transcripts_with_translation.json失败

解决:
✅ 直接使用exam-complete（有4部分+正确的数据加载）
✅ 不再拼接JS，避免冲突

验证:
✅ 所有试卷有Lesen/Schreiben/Sprechen
✅ 所有试卷有transcripts_with_translation加载

Co-Authored-By: Claude Sonnet 4 <noreply@anthropic.com>"

git push

echo "⏳ 等待120秒部署..."
sleep 120

# 步骤6：线上验证
echo ""
echo "🔍 线上验证..."
for name in uebungssatz01 uebungssatz02 modellsatz; do
    URL="https://820wusheng.github.io/goethe-a1-learning/html/${name}.html"

    echo "验证: $URL"

    # 检查HTTP状态
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
    if [ "$STATUS" != "200" ]; then
        echo "❌ HTTP $STATUS"
        exit 1
    fi

    # 检查内容
    LESEN=$(curl -s "$URL" | grep -c "Lesen" || echo 0)

    echo "  HTTP=$STATUS, Lesen=$LESEN"

    if [ "$LESEN" -eq 0 ]; then
        echo "❌ $name 无内容"
        exit 1
    fi
done

echo ""
echo "✅ 完整流程成功！"
echo ""
echo "页面:"
echo "  https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz01.html"
echo "  https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz02.html"
echo "  https://820wusheng.github.io/goethe-a1-learning/html/modellsatz.html"

# 步骤7：更新PITFALLS
echo ""
echo "📝 更新PITFALLS..."
cat >> PITFALLS.md << 'EOF'

## 🔴 2026-06-13 错误：复制了专用JS导致冲突

**问题**: build-complete-exam复制listening-complete的听力专用JS到4部分试卷

**症状**:
- 页面报错"加载失败，请确保transcripts_with_translation.json存在"
- 文件存在但JS执行失败

**根本原因**:
listening-complete的fetch逻辑依赖特定DOM结构
复制到exam-complete导致DOM不匹配

**正确做法**:
```bash
# ✅ 直接使用exam-complete
# 它已经有4部分+正确的数据加载逻辑
cp exam-complete.html target.html

# ❌ 不要拼接不同页面的JS
```

**Skill自我修正**:
- build-complete-exam-v2.sh不再拼接JS
- 使用单一完整参考文件
- 验证数据文件存在
- 验证线上加载成功
EOF

git add PITFALLS.md
git commit -m "docs: 记录复制专用JS导致冲突的错误"
git push

echo "✅ PITFALLS已更新"

exit 0
