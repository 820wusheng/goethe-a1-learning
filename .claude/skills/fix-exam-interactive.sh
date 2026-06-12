#!/bin/bash
# fix-exam-interactive.sh - 修复试卷交互功能
# 问题：阅读无答题功能、口语无场景例子

set -e

TARGET=${1:-html/uebungssatz01.html}
echo "🔧 修复试卷交互功能: $TARGET"

# 检查当前问题
echo "📋 检查当前状态..."
LESEN_ONCLICK=$(grep "Lesen" -A 50 "$TARGET" | grep -c "onclick=" || echo 0)
SPRECHEN_EXAMPLE=$(grep "Sprechen" -A 50 "$TARGET" | grep -c "场景例子" || echo 0)

echo "当前状态:"
echo "- 阅读onclick: $LESEN_ONCLICK"
echo "- 口语场景: $SPRECHEN_EXAMPLE"

if [ "$LESEN_ONCLICK" -gt 0 ] && [ "$SPRECHEN_EXAMPLE" -gt 0 ]; then
    echo "✅ 交互功能已完整"
    exit 0
fi

echo ""
echo "❌ 问题确认:"
echo "1. 阅读部分缺少答题功能(selectOption/data-answer)"
echo "2. 口语部分缺少场景例子和中文翻译"
echo "3. 写作部分缺少标准答案模板"
echo ""
echo "需要手动修复HTML，添加："
echo "- 阅读: onclick=\"selectOption()\" data-answer=\"a/b\""
echo "- 写作: 标准答案模板数据"
echo "- 口语: 场景例子数据"
echo ""
echo "参考: data/standard_answers.json"

exit 1
