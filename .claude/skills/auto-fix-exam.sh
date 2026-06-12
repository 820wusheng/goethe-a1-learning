#!/bin/bash
# auto-fix-exam.sh - 自动修复试卷所有功能
# 从listening-complete.html提取完整实现并应用

set -e

TARGET=${1:-html/uebungssatz01.html}
REFERENCE="html/exam-complete.html"

echo "🔧 自动修复试卷: $TARGET"
echo "参考: $REFERENCE"

# 1. 验证参考文件
if [ ! -f "$REFERENCE" ]; then
    echo "❌ 参考文件不存在"
    exit 1
fi

# 2. 检查参考文件是否有完整功能
REF_SELECT=$(grep -c "function selectOption" "$REFERENCE" || echo 0)
REF_SUBMIT=$(grep -c "function submitAnswer" "$REFERENCE" || echo 0)
REF_SPEAK=$(grep -c "function speakGerman" "$REFERENCE" || echo 0)

if [ "$REF_SELECT" -eq 0 ] || [ "$REF_SUBMIT" -eq 0 ] || [ "$REF_SPEAK" -eq 0 ]; then
    echo "❌ 参考文件功能不完整"
    echo "selectOption=$REF_SELECT, submitAnswer=$REF_SUBMIT, speakGerman=$REF_SPEAK"
    exit 1
fi

echo "✅ 参考文件功能完整"

# 3. 复制并删除target="_blank"
echo "📋 复制完整功能实现..."
cp "$TARGET" "$TARGET.broken"
cp "$REFERENCE" "$TARGET"

# 删除target="_blank"
sed -i '' 's/ target="_blank"//g' "$TARGET"

echo "✅ 已复制完整实现并删除新窗口链接"
echo "备份: $TARGET.broken"

# 4. 验证修复结果
echo ""
echo "🔍 验证修复..."
NEW_SELECT=$(grep -c "function selectOption" "$TARGET" || echo 0)
NEW_SUBMIT=$(grep -c "function submitAnswer" "$TARGET" || echo 0)

if [ "$NEW_SELECT" -eq 0 ] || [ "$NEW_SUBMIT" -eq 0 ]; then
    echo "❌ 修复失败"
    mv "$TARGET.broken" "$TARGET"
    exit 1
fi

echo "✅ 修复成功"
echo "- selectOption: $NEW_SELECT"
echo "- submitAnswer: $NEW_SUBMIT"

exit 0
