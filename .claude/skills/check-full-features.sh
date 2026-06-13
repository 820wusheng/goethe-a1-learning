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

# 2. 阅读：必须存在且有答题功能（强制检查）
echo "📖 检查阅读部分..."
LESEN_COUNT=$(grep -c "Lesen\|阅读" "$TARGET" || echo 0)
if [ "$LESEN_COUNT" -eq 0 ]; then
    echo "❌ 缺少阅读部分！页面只有听力"
    exit 1
fi

# 检查阅读选项是否可点击
LESEN_OPTIONS=$(grep "Lesen" -A 300 "$TARGET" | grep "class=\"option\"" | head -10)
LESEN_CLICKABLE=$(echo "$LESEN_OPTIONS" | grep "onclick" | wc -l | tr -d ' ')

echo "阅读选项示例:"
echo "$LESEN_OPTIONS" | head -3 | sed 's/^/  /'
echo "可点击数量: $LESEN_CLICKABLE"

if [ "$LESEN_CLICKABLE" = "0" ] || [ -z "$LESEN_CLICKABLE" ]; then
    echo ""
    echo "❌❌❌ 严重错误：阅读选项无法点击！"
    echo ""
    echo "当前选项HTML:"
    echo "$LESEN_OPTIONS" | head -2 | sed 's/^/  /'
    echo ""
    echo "应该是:"
    echo "  <div class=\"option\" data-answer=\"a\" onclick=\"selectOption('lesen1', 'a', this)\">"
    echo "    Richtig 正确"
    echo "  </div>"
    echo ""
    echo "这是重复错误！已在PITFALLS记录多次！"
    exit 1
fi

echo "✅ 阅读：有答题功能 (可点击选项=$LESEN_CLICKABLE)"

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
