#!/bin/bash
# cleanup.sh - 清理临时和备份文件

set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "🧹 清理项目文件..."

# 1. 删除备份文件
echo "删除备份文件..."
find . -name "*.backup" -delete
find . -name "*.broken" -delete
echo "✅ 备份文件已删除"

# 2. 删除测试文件
echo "删除测试文件..."
rm -f html/test-*.html
rm -f test-*.html
echo "✅ 测试文件已删除"

# 3. 整理skill文件（删除旧的多余skill）
echo "整理skill..."
cd .claude/skills
# 保留主skill和子skill
ls -1 | grep -v "a1-exam.sh\|auto-fix-exam.sh\|check-full-features.sh\|README.md\|cleanup.sh" | xargs rm -f 2>/dev/null || true
cd ../..
echo "✅ Skill已整理"

# 4. 显示当前文件结构
echo ""
echo "📂 当前目录结构:"
tree -L 2 -I 'node_modules|.git' || ls -R | head -50

echo ""
echo "✅ 清理完成！"
echo "保留的skill:"
ls -1 .claude/skills/

exit 0
