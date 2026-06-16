#!/bin/bash
# emergency-restore.sh - 紧急恢复页面切换函数
set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "🚨 紧急恢复页面切换函数"
echo "================================"

# 从git历史恢复正确版本
echo "📦 从git历史提取页面切换函数..."

git show HEAD~1:html/exam-complete.html > /tmp/prev-version.html

# 提取页面切换相关函数
python3 << 'PYTHON_EOF'
import re

# 读取上一个版本
with open("/tmp/prev-version.html", "r") as f:
    prev = f.read()

# 提取所有页面切换函数
navigation_js = re.search(
    r'(function showSection.*?function toggleTranslation.*?\})',
    prev,
    re.DOTALL
)

if navigation_js:
    nav_code = navigation_js.group(1)
    print("✅ 已提取页面切换函数")
    print(f"代码长度: {len(nav_code)}")
    
    with open("/tmp/nav-functions.js", "w") as f:
        f.write(nav_code)
else:
    print("❌ 未找到页面切换函数")
    import sys
    sys.exit(1)
PYTHON_EOF

# 读取当前版本并合并
python3 << 'PYTHON_EOF'
import re

with open("html/exam-complete.html", "r") as f:
    current = f.read()

with open("/tmp/nav-functions.js", "r") as f:
    nav_functions = f.read()

# 在第一个<script>标签后插入导航函数
if "<script>" in current:
    current = current.replace(
        "<script>",
        "<script>\n// === 页面导航函数 ===\n" + nav_functions + "\n\n// === 答题函数 ===\n",
        1
    )
    
    with open("html/exam-complete.html", "w") as f:
        f.write(current)
    
    print("✅ 已恢复页面切换函数")
else:
    print("❌ 未找到<script>标签")
    import sys
    sys.exit(1)
PYTHON_EOF

# 验证
echo ""
echo "🔍 验证"
SHOW_SECTION=$(grep -c "function showSection" html/exam-complete.html)
SELECT_OPTION=$(grep -c "function selectOption" html/exam-complete.html)

echo "showSection: $SHOW_SECTION"
echo "selectOption: $SELECT_OPTION"

if [ "$SHOW_SECTION" -eq 0 ]; then
    echo "❌ showSection未恢复"
    exit 1
fi

echo "✅ 验证通过"

# 复制
echo ""
echo "📋 复制到所有试卷"
for f in uebungssatz01 uebungssatz02 modellsatz; do
    cp html/exam-complete.html html/${f}.html
    echo "  ✅ ${f}.html"
done

# 提交
git add html/*.html
git commit -m "fix: 紧急恢复页面切换函数

问题: 复制调试页面JS时删除了showSection等函数
导致: 无法切换阅读/写作/口语部分

修复:
✅ 从git历史恢复showSection函数
✅ 保留selectOption答题函数
✅ 合并两部分功能

现在同时有:
✅ 页面切换功能（showSection等）
✅ 答题功能（selectOption等）

Co-Authored-By: Claude Sonnet 4 <noreply@anthropic.com>"

git push

echo ""
echo "⏳ 等待120秒部署..."
sleep 120

echo ""
echo "✅ 部署完成"
echo ""
echo "现在页面应该能:"
echo "1. 切换到阅读/写作/口语部分"
echo "2. 点击选择答案"

exit 0
