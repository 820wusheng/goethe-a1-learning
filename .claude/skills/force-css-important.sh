#!/bin/bash
# force-css-important.sh - 强制CSS使用!important
set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "💪 强制CSS优先级（使用!important）"
echo "================================"

python3 << 'PYTHON_EOF'
import re

with open("html/exam-complete.html", "r") as f:
    html = f.read()

# 找到.selected CSS并添加!important
html = re.sub(
    r'(\.task \.option\.selected \{\s*border-color: #667eea;)',
    r'.task .option.selected {\n            border-color: #667eea !important;',
    html
)

html = re.sub(
    r'(background: #e6f2ff;)(\s*\})',
    r'background: #e6f2ff !important;\2',
    html
)

# 再添加一个更高权重的规则
if "body .task .option.selected" not in html:
    # 在</style>前添加
    additional_css = """
        /* 强制选中样式 - 最高优先级 */
        body .task .option.selected {
            border-color: #667eea !important;
            background: #e6f2ff !important;
            border-width: 3px !important;
        }
    """
    html = html.replace("</style>", additional_css + "\n    </style>", 1)
    print("✅ 已添加!important CSS")

with open("html/exam-complete.html", "w") as f:
    f.write(html)

print("✅ 已更新CSS权重")
PYTHON_EOF

# 复制
for f in uebungssatz01 uebungssatz02 modellsatz; do
    cp html/exam-complete.html html/${f}.html
    echo "✅ ${f}.html"
done

# 提交
git add html/*.html
git commit -m "fix: 强制CSS优先级使用!important

问题: CSS可能被其他规则覆盖
解决: 添加!important确保样式生效

CSS更新:
- border-color: #667eea !important
- background: #e6f2ff !important  
- border-width: 3px !important
- 选择器: body .task .option.selected

Co-Authored-By: Claude Sonnet 4 <noreply@anthropic.com>"

git push

echo ""
echo "⏳ 等待120秒..."
sleep 120

echo ""
echo "✅ 已部署"
echo ""
echo "用户测试步骤:"
echo "1. ⚠️  强制刷新: Ctrl+Shift+R (Windows) 或 Cmd+Shift+R (Mac)"
echo "2. 打开: https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz01.html"
echo "3. 点击阅读选项"
echo "4. 现在应该有3px蓝色边框"
echo ""
echo "同时测试极简页面:"
echo "https://820wusheng.github.io/goethe-a1-learning/html/reading-simple-test.html"

exit 0
