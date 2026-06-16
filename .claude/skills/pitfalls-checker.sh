#!/bin/bash
# pitfalls-checker.sh - 检查是否违反PITFALLS记录的规则
set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "🔍 PITFALLS规则检查"
echo "================================"
echo ""

TARGET=${1:-html/exam-complete.html}

VIOLATIONS=0

# 规则1: 不要删除现有功能
echo "1️⃣ 检查页面导航函数"
REQUIRED_NAV=(
    "showSection"
    "showLesenPart"
    "showSchreibenPart"
    "showSprechenPart"
)

for func in "${REQUIRED_NAV[@]}"; do
    if ! grep -q "function $func" "$TARGET"; then
        echo "  ❌ 缺少导航函数: $func"
        ((VIOLATIONS++))
    fi
done

# 规则2: 阅读答题功能必须像听力一样
echo ""
echo "2️⃣ 检查阅读答题功能"
LESEN_ONCLICK=$(grep -c 'onclick=.*lesen' "$TARGET" || echo 0)
if [ "$LESEN_ONCLICK" -eq 0 ]; then
    echo "  ❌ 阅读选项缺少onclick"
    ((VIOLATIONS++))
fi

# 规则3: CSS .selected必须存在
echo ""
echo "3️⃣ 检查.selected CSS"
if ! grep -q "\.option\.selected" "$TARGET"; then
    echo "  ❌ 缺少.selected CSS"
    ((VIOLATIONS++))
fi

# 规则4: 口语必须有3个Teil范文
echo ""
echo "4️⃣ 检查口语3个Teil范文"
SPRECHEN_TEIL=(
    "Teil 1 A1标准答案示例"
    "Teil 2 A1标准答案示例"
    "Teil 3 A1标准答案示例"
)

for teil in "${SPRECHEN_TEIL[@]}"; do
    if ! grep -q "$teil" "$TARGET"; then
        echo "  ❌ 缺少: $teil"
        ((VIOLATIONS++))
    fi
done

# 规则5: 写作必须有A1标准答案
echo ""
echo "5️⃣ 检查写作A1标准答案"
if ! grep -q "A1标准答案示例" "$TARGET"; then
    echo "  ❌ 缺少写作标准答案"
    ((VIOLATIONS++))
fi

# 规则6: 不能有重复的变量声明
echo ""
echo "6️⃣ 检查重复变量声明"
ANSWERS_COUNT=$(grep -c "let answers = {}" "$TARGET" || echo 0)
if [ "$ANSWERS_COUNT" -gt 1 ]; then
    echo "  ❌ let answers重复声明 ($ANSWERS_COUNT 次)"
    ((VIOLATIONS++))
fi

# 规则7: 答案数据不能重复
echo ""
echo "7️⃣ 检查答案数据重复"
for i in {1..15}; do
    LESEN_ANS_COUNT=$(grep -c "answers\['lesen$i'\]" "$TARGET" || echo 0)
    if [ "$LESEN_ANS_COUNT" -gt 1 ]; then
        echo "  ❌ lesen$i 答案重复定义 ($LESEN_ANS_COUNT 次)"
        ((VIOLATIONS++))
    fi
done

# 规则8: 听力不能新窗口打开
echo ""
echo "8️⃣ 检查听力音频新窗口"
NEW_WINDOW=$(grep -c 'target="_blank"' "$TARGET" || echo 0)
if [ "$NEW_WINDOW" -gt 0 ]; then
    echo "  ⚠️  发现target=_blank ($NEW_WINDOW 处)"
fi

# 总结
echo ""
echo "================================"
if [ "$VIOLATIONS" -eq 0 ]; then
    echo "✅ 所有PITFALLS规则检查通过"
    exit 0
else
    echo "❌ 发现 $VIOLATIONS 个违规"
    exit 1
fi
