#!/bin/bash
# fix-duplicate-text.sh - 修复选项文本重复

set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "🔧 修复选项文本重复"
echo "================================"

TARGET=${1:-html/exam-complete.html}

# 检查重复
echo "📋 检查重复文本..."
RICHTIG_DUP=$(grep -c "Richtig 正确</div>Richtig 正确" "$TARGET" || true)
FALSCH_DUP=$(grep -c "Falsch 错误</div>Falsch 错误" "$TARGET" || true)

echo "Richtig重复: $RICHTIG_DUP"
echo "Falsch重复: $FALSCH_DUP"

if [ "$RICHTIG_DUP" = "0" ] && [ "$FALSCH_DUP" = "0" ]; then
    echo "✅ 无重复文本"
    exit 0
fi

# 修复
echo ""
echo "🔧 修复重复..."
python3 << 'PYTHON_EOF'
import re
with open("html/exam-complete.html", "r") as f:
    html = f.read()

# 修复 Richtig 重复
html = re.sub(
    r'Richtig 正确</div>Richtig 正确</div>',
    'Richtig 正确</div>',
    html
)

# 修复 Falsch 重复  
html = re.sub(
    r'Falsch 错误</div>Falsch 错误</div>',
    'Falsch 错误</div>',
    html
)

with open("html/exam-complete.html", "w") as f:
    f.write(html)

print("✅ 已修复重复文本")
PYTHON_EOF

# 验证
echo ""
echo "🔍 验证..."
RICHTIG_DUP_AFTER=$(grep -c "Richtig 正确</div>Richtig 正确" "$TARGET" || true)
FALSCH_DUP_AFTER=$(grep -c "Falsch 错误</div>Falsch 错误" "$TARGET" || true)

echo "修复后 Richtig重复: $RICHTIG_DUP_AFTER"
echo "修复后 Falsch重复: $FALSCH_DUP_AFTER"

if [ "$RICHTIG_DUP_AFTER" = "0" ] && [ "$FALSCH_DUP_AFTER" = "0" ]; then
    echo "✅ 修复成功！"
    exit 0
else
    echo "❌ 仍有重复"
    exit 1
fi
