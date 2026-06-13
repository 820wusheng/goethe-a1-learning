#!/bin/bash
# check-full-features.sh - 全量功能检查
# 检查所有4部分的完整功能

set -e

TARGET=${1:-html/uebungssatz01.html}
echo "🔍 全量功能检查: $TARGET"

# 1. 听力：禁止新窗口官方音频
echo "📻 检查听力部分..."
HOEREN_NEW_WINDOW=$(grep "target=\"_blank\"" "$TARGET" | wc -l | tr -d ' ')
if [ "$HOEREN_NEW_WINDOW" != "0" ] && [ -n "$HOEREN_NEW_WINDOW" ]; then
    echo "❌ 听力音频打开新窗口 (target=_blank)"
    exit 1
fi
echo "✅ 听力：无新窗口链接"

# 2. 阅读：必须存在且有答题功能（强制检查）
echo "📖 检查阅读部分..."
LESEN_COUNT=$(grep "Lesen\|阅读" "$TARGET" | wc -l | tr -d ' ')
if [ "$LESEN_COUNT" = "0" ] || [ -z "$LESEN_COUNT" ]; then
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
LESEN_TRANSLATION=$(grep -A 100 "Lesen" "$TARGET" | grep "中文翻译\|chinese-text" | wc -l | tr -d ' ')
if [ "$LESEN_TRANSLATION" = "0" ] || [ -z "$LESEN_TRANSLATION" ]; then
    echo "❌ 阅读文章缺少翻译"
    exit 1
fi
echo "✅ 阅读：文章有翻译"

# 4. 写作：必须存在且有A1标准答案
echo "✍️ 检查写作部分..."
SCHREIBEN_COUNT=$(grep "Schreiben\|写作" "$TARGET" | wc -l | tr -d ' ')
if [ "$SCHREIBEN_COUNT" = "0" ] || [ -z "$SCHREIBEN_COUNT" ]; then
    echo "❌ 缺少写作部分！"
    exit 1
fi

SCHREIBEN_ANSWER=$(grep "A1标准答案示例" "$TARGET" | wc -l | tr -d ' ')
if [ "$SCHREIBEN_ANSWER" = "0" ] || [ -z "$SCHREIBEN_ANSWER" ]; then
    echo "❌ 写作部分缺少A1标准答案！"
    echo ""
    echo "应该包含:"
    echo "  📝 A1标准答案示例"
    echo "  Liebe Maria, danke für deine Einladung..."
    echo ""
    exit 1
fi

echo "✅ 写作：存在且有A1答案 (Schreiben=$SCHREIBEN_COUNT, 答案=$SCHREIBEN_ANSWER)"

# 5. 口语：必须存在且有A1场景对话
echo "🗣️ 检查口语部分..."
SPRECHEN_COUNT=$(grep "Sprechen\|口语" "$TARGET" | wc -l | tr -d ' ')
if [ "$SPRECHEN_COUNT" = "0" ] || [ -z "$SPRECHEN_COUNT" ]; then
    echo "❌ 缺少口语部分！"
    exit 1
fi

SPRECHEN_ANSWER=$(grep "A1场景对话示例" "$TARGET" | wc -l | tr -d ' ')
if [ "$SPRECHEN_ANSWER" = "0" ] || [ -z "$SPRECHEN_ANSWER" ]; then
    echo "❌ 口语部分缺少A1场景对话！"
    echo ""
    echo "应该包含:"
    echo "  💬 A1场景对话示例"
    echo "  Name: Ich heiße Max..."
    echo "  Alter: Ich bin 25 Jahre alt..."
    echo ""
    exit 1
fi

echo "✅ 口语：存在且有A1对话 (Sprechen=$SPRECHEN_COUNT, 对话=$SPRECHEN_ANSWER)"

echo ""
echo "✅ 全量功能检查通过！"
exit 0
