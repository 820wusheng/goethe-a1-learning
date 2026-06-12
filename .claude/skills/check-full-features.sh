#!/bin/bash
# check-full-features.sh - 全量功能检查
# 检查所有4部分的完整功能

set -e

TARGET=${1:-html/uebungssatz01.html}
echo "🔍 全量功能检查: $TARGET"

# 1. 听力：禁止新窗口官方音频
echo "📻 检查听力部分..."
HOEREN_NEW_WINDOW=$(grep -c "target=\"_blank\"" "$TARGET" || echo 0)
if [ "$HOEREN_NEW_WINDOW" -gt 0 ]; then
    echo "❌ 听力音频打开新窗口 (target=_blank)"
    exit 1
fi
echo "✅ 听力：无新窗口链接"

# 2. 阅读：必须有答题功能
echo "📖 检查阅读部分..."
LESEN_ONCLICK=$(grep -A 50 "Lesen" "$TARGET" | grep -c "onclick=\"selectOption" || echo 0)
LESEN_DATA_ANSWER=$(grep -A 50 "Lesen" "$TARGET" | grep -c "data-answer" || echo 0)
if [ "$LESEN_ONCLICK" -eq 0 ] || [ "$LESEN_DATA_ANSWER" -eq 0 ]; then
    echo "❌ 阅读缺少答题功能: onclick=$LESEN_ONCLICK, data-answer=$LESEN_DATA_ANSWER"
    exit 1
fi
echo "✅ 阅读：有答题功能 (onclick=$LESEN_ONCLICK)"

# 3. 阅读：文章必须有翻译
LESEN_TRANSLATION=$(grep -A 100 "Lesen" "$TARGET" | grep -c "中文翻译\|chinese-text" || echo 0)
if [ "$LESEN_TRANSLATION" -eq 0 ]; then
    echo "❌ 阅读文章缺少翻译"
    exit 1
fi
echo "✅ 阅读：文章有翻译"

# 4. 写作：必须有标准答案模板
echo "✍️ 检查写作部分..."
SCHREIBEN_TEMPLATE=$(grep -A 100 "Schreiben" "$TARGET" | grep -c "标准答案\|standard.*answer\|模板" || echo 0)
if [ "$SCHREIBEN_TEMPLATE" -eq 0 ]; then
    echo "❌ 写作缺少标准答案模板"
    exit 1
fi
echo "✅ 写作：有标准答案模板"

# 5. 口语：必须有场景例子
echo "🗣️ 检查口语部分..."
SPRECHEN_EXAMPLE=$(grep -A 100 "Sprechen" "$TARGET" | grep -c "场景例子\|example\|示例对话" || echo 0)
if [ "$SPRECHEN_EXAMPLE" -eq 0 ]; then
    echo "❌ 口语缺少场景例子"
    exit 1
fi
echo "✅ 口语：有场景例子"

# 6. 口语：必须有中文翻译
SPRECHEN_CHINESE=$(grep -A 100 "Sprechen" "$TARGET" | grep -c "中文\|汉语" || echo 0)
if [ "$SPRECHEN_CHINESE" -eq 0 ]; then
    echo "❌ 口语缺少中文翻译"
    exit 1
fi
echo "✅ 口语：有中文翻译"

echo ""
echo "✅ 全量功能检查通过！"
exit 0
