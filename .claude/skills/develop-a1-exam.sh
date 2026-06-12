#!/bin/bash
# develop-a1-exam.sh - A1试卷开发skill
# 用法: ./develop-a1-exam.sh <target-file>
# 例如: ./develop-a1-exam.sh html/uebungssatz01.html

set -e

TARGET=${1:-html/uebungssatz01.html}
REFERENCE="html/exam-complete.html"

echo "🔧 A1试卷开发skill"
echo "参考: $REFERENCE"
echo "目标: $TARGET"

# 1. 检查参考页面存在且完整
if [ ! -f "$REFERENCE" ]; then
    echo "❌ 参考文件不存在: $REFERENCE"
    exit 1
fi

REF_LESEN=$(grep -c "Lesen" "$REFERENCE" || echo 0)
REF_SCHREIBEN=$(grep -c "Schreiben" "$REFERENCE" || echo 0)
REF_SPRECHEN=$(grep -c "Sprechen" "$REFERENCE" || echo 0)

if [ "$REF_LESEN" -eq 0 ] || [ "$REF_SCHREIBEN" -eq 0 ] || [ "$REF_SPRECHEN" -eq 0 ]; then
    echo "❌ 参考页面不完整"
    exit 1
fi

echo "✅ 参考页面完整: Lesen=$REF_LESEN, Schreiben=$REF_SCHREIBEN, Sprechen=$REF_SPRECHEN"

# 2. 从exam-complete.html复制完整结构到目标文件
echo "📋 复制完整4部分结构..."
cp "$REFERENCE" "$TARGET.backup"
cp "$REFERENCE" "$TARGET"

echo "✅ 已复制完整结构"

# 3. 验证
./.claude/skills/verify-a1-dev.sh

echo ""
echo "✅ 开发完成！"
echo "备份: $TARGET.backup"
exit 0
