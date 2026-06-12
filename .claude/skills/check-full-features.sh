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

# 2. 阅读：必须存在且有答题功能
echo "📖 检查阅读部分..."
LESEN_COUNT=$(grep -c "Lesen\|阅读" "$TARGET" || echo 0)
if [ "$LESEN_COUNT" -eq 0 ]; then
    echo "❌ 缺少阅读部分！页面只有听力"
    exit 1
fi
LESEN_ONCLICK=$(grep "Lesen" -A 200 "$TARGET" | grep -c "onclick=\"selectOption" || echo 0)
LESEN_DATA_ANSWER=$(grep "Lesen" -A 200 "$TARGET" | grep -c "data-answer" || echo 0)
if [ "$LESEN_ONCLICK" -eq 0 ] || [ "$LESEN_DATA_ANSWER" -eq 0 ]; then
    echo "❌ 阅读缺少答题功能: onclick=$LESEN_ONCLICK, data-answer=$LESEN_DATA_ANSWER"
    exit 1
fi
echo "✅ 阅读：存在且有答题功能 (Lesen=$LESEN_COUNT, onclick=$LESEN_ONCLICK)"

# 3. 阅读：文章必须有翻译
LESEN_TRANSLATION=$(grep -A 100 "Lesen" "$TARGET" | grep -c "中文翻译\|chinese-text" || echo 0)
if [ "$LESEN_TRANSLATION" -eq 0 ]; then
    echo "❌ 阅读文章缺少翻译"
    exit 1
fi
echo "✅ 阅读：文章有翻译"

# 4. 写作：必须存在
echo "✍️ 检查写作部分..."
SCHREIBEN_COUNT=$(grep -c "Schreiben\|写作" "$TARGET" || echo 0)
if [ "$SCHREIBEN_COUNT" -eq 0 ]; then
    echo "❌ 缺少写作部分！"
    exit 1
fi
echo "✅ 写作：存在 (Schreiben=$SCHREIBEN_COUNT)"

# 5. 口语：必须存在
echo "🗣️ 检查口语部分..."
SPRECHEN_COUNT=$(grep -c "Sprechen\|口语" "$TARGET" || echo 0)
if [ "$SPRECHEN_COUNT" -eq 0 ]; then
    echo "❌ 缺少口语部分！"
    exit 1
fi
echo "✅ 口语：存在 (Sprechen=$SPRECHEN_COUNT)"

echo ""
echo "✅ 全量功能检查通过！"
exit 0
