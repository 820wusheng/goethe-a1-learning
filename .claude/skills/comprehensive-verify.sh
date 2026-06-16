#!/bin/bash
# comprehensive-verify.sh - 完整功能验证
set -e

TARGET=${1:-html/uebungssatz01.html}

echo "🔍 完整功能验证: $TARGET"
echo "================================"

# 1. 页面导航功能
echo ""
echo "1️⃣ 页面导航功能"
REQUIRED_NAV=(
    "showSection"
    "showLesenPart"
    "showSchreibenPart"
    "showSprechenPart"
)

NAV_OK=true
for func in "${REQUIRED_NAV[@]}"; do
    if grep -q "function $func" "$TARGET"; then
        echo "  ✅ $func"
    else
        echo "  ❌ 缺少: $func"
        NAV_OK=false
    fi
done

# 2. 答题功能
echo ""
echo "2️⃣ 答题功能"
REQUIRED_ANSWER=(
    "selectOption"
    "submitAnswer"
)

ANSWER_OK=true
for func in "${REQUIRED_ANSWER[@]}"; do
    if grep -q "function $func" "$TARGET"; then
        echo "  ✅ $func"
    else
        echo "  ❌ 缺少: $func"
        ANSWER_OK=false
    fi
done

# 3. 其他功能
echo ""
echo "3️⃣ 其他功能"
if grep -q "function toggleTranslation" "$TARGET"; then
    echo "  ✅ toggleTranslation (翻译切换)"
else
    echo "  ❌ 缺少: toggleTranslation"
fi

if grep -q "function speakGerman" "$TARGET"; then
    echo "  ✅ speakGerman (AI朗读)"
else
    echo "  ❌ 缺少: speakGerman"
fi

# 4. 变量初始化
echo ""
echo "4️⃣ 变量初始化"
if grep -q "let answers" "$TARGET"; then
    echo "  ✅ answers"
else
    echo "  ❌ 缺少: answers"
fi

if grep -q "let userAnswers" "$TARGET"; then
    echo "  ✅ userAnswers"
else
    echo "  ❌ 缺少: userAnswers"
fi

# 5. CSS样式
echo ""
echo "5️⃣ CSS样式"
if grep -q "\.option\.selected" "$TARGET"; then
    echo "  ✅ .option.selected"
else
    echo "  ❌ 缺少: .option.selected CSS"
fi

# 6. HTML元素
echo ""
echo "6️⃣ HTML元素"
ONCLICK_NAV=$(grep -c 'onclick="showSection' "$TARGET" || echo 0)
ONCLICK_ANSWER=$(grep -c 'onclick="selectOption' "$TARGET" || echo 0)

echo "  导航onclick: $ONCLICK_NAV (应该>0)"
echo "  答题onclick: $ONCLICK_ANSWER (应该>0)"

# 7. 函数总数
echo ""
echo "7️⃣ 函数统计"
TOTAL_FUNCTIONS=$(grep -c "^        function " "$TARGET" || grep -c "function " "$TARGET")
echo "  总函数数量: $TOTAL_FUNCTIONS (应该≥7)"

# 总结
echo ""
echo "================================"
if [ "$NAV_OK" = true ] && [ "$ANSWER_OK" = true ] && [ "$ONCLICK_NAV" -gt 0 ] && [ "$ONCLICK_ANSWER" -gt 0 ]; then
    echo "✅ 所有功能验证通过"
    exit 0
else
    echo "❌ 有功能缺失"
    exit 1
fi
