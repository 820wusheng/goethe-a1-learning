#!/bin/bash
# fix-translation-button.sh - 修复翻译按钮不响应

set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "🔧 修复翻译按钮"
echo "================================"

TARGET=${1:-html/exam-complete.html}

# 步骤1: 检查toggleTranslation函数
echo "📋 检查toggleTranslation函数..."
if ! grep -q "function toggleTranslation" "$TARGET"; then
    echo "❌ 缺少toggleTranslation函数！"
    exit 1
fi
echo "✅ toggleTranslation函数存在"

# 步骤2: 检查CSS .show类
echo ""
echo "📋 检查CSS .show类..."
if ! grep -q "\.chinese\.show" "$TARGET"; then
    echo "❌ 缺少.chinese.show CSS！"
    exit 1
fi
echo "✅ CSS .show类存在"

# 步骤3: 检查是否有内联display覆盖
echo ""
echo "📋 检查内联display样式..."
INLINE_DISPLAY=$(grep 'class=".*chinese.*".*style=.*display:' "$TARGET" | wc -l | tr -d ' ')
if [ "$INLINE_DISPLAY" != "0" ]; then
    echo "❌ 发现 $INLINE_DISPLAY 个内联display样式（会覆盖.show类）"
    echo ""
    echo "示例:"
    grep 'class=".*chinese.*".*style=.*display:' "$TARGET" | head -2 | sed 's/^/  /'
    echo ""
    
    # 修复: 删除内联display
    echo "🔧 删除内联display样式..."
    python3 << 'PYTHON_EOF'
import re
with open("$TARGET", "r") as f:
    html = f.read()

# 删除chinese类元素的内联display样式
html = re.sub(
    r'(class="[^"]*chinese[^"]*"[^>]*style="[^"]*?)display:\s*none;\s*',
    r'\1',
    html
)

with open("$TARGET", "w") as f:
    f.write(html)

print("✅ 已删除内联display样式")
PYTHON_EOF
    echo "✅ 修复完成"
else
    echo "✅ 无内联display冲突"
fi

# 步骤4: 验证
echo ""
echo "🔍 最终验证..."
echo "toggleTranslation函数: $(grep -c 'function toggleTranslation' "$TARGET")"
echo "CSS .show类: $(grep -c '\.chinese\.show' "$TARGET")"
echo "内联display冲突: $(grep 'class=".*chinese.*".*style=.*display:' "$TARGET" | wc -l | tr -d ' ')"

echo ""
echo "✅ 翻译按钮修复完成！"
exit 0
