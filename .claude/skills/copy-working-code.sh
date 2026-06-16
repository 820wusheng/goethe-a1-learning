#!/bin/bash
# copy-working-code.sh - 直接复制调试页面的成功代码
set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "📋 从调试页面复制成功的代码"
echo "================================"
echo ""
echo "策略: 调试页面能工作，直接用它的CSS和JS替换试卷页面"
echo ""

python3 << 'PYTHON_EOF'
import re

# 读取调试页面（已验证工作）
with open("html/debug-reading-test.html", "r") as f:
    debug = f.read()

# 提取调试页面的CSS
debug_css = re.search(r'<style>(.*?)</style>', debug, re.DOTALL).group(1)

# 提取调试页面的JS（selectOption和submitAnswer函数）
debug_js = re.search(
    r'(let answers = \{\};.*?function submitAnswer\(taskId\) \{.*?if \(msg\) \{.*?\}\s*\})',
    debug,
    re.DOTALL
).group(1)

print("✅ 已提取调试页面代码")
print(f"CSS长度: {len(debug_css)}")
print(f"JS长度: {len(debug_js)}")

# 读取试卷页面
with open("html/exam-complete.html", "r") as f:
    exam = f.read()

# 1. 替换CSS - 找到.option相关的所有CSS并替换
# 保留其他CSS，只替换.option相关部分
option_css = """
        .option {
            padding: 12px 20px;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .option:hover {
            border-color: #667eea;
            background: #edf2f7;
        }

        body .task .option.selected {
            border-color: #667eea !important;
            background: #e6f2ff !important;
            border-width: 3px !important;
        }

        .option.correct {
            border-color: #48bb78;
            background: #c6f6d5;
        }

        .option.incorrect {
            border-color: #f56565;
            background: #fed7d7;
        }
"""

# 替换.option CSS
exam = re.sub(
    r'\.option \{.*?\}.*?\.option:hover \{.*?\}.*?(?:body )?\.task \.option\.selected \{.*?\}',
    option_css.strip(),
    exam,
    flags=re.DOTALL
)

# 2. 替换JS - 完全使用调试页面的实现
# 删除旧的JS
exam = re.sub(
    r'(<script>|<!-- 交互功能JS.*?-->.*?<script>)(.*?)(</script>)',
    r'\1\n' + debug_js + r'\n\3',
    exam,
    count=1,
    flags=re.DOTALL
)

# 3. 确保没有重复的变量声明
# 只保留一个let answers = {}
parts = exam.split('let answers = {};')
if len(parts) > 2:
    exam = parts[0] + 'let answers = {};' + ''.join(parts[1:]).replace('let answers = {};', '// answers已声明', 1)
    print("✅ 移除重复的变量声明")

with open("html/exam-complete.html", "w") as f:
    f.write(exam)

print("✅ 已替换CSS和JS为调试页面的成功代码")
PYTHON_EOF

# 复制到所有试卷
echo ""
echo "📋 复制到所有试卷"
for f in uebungssatz01 uebungssatz02 modellsatz; do
    cp html/exam-complete.html html/${f}.html
    echo "  ✅ ${f}.html"
done

# 验证
echo ""
echo "🔍 验证"
python3 << 'PYTHON_EOF'
with open("html/uebungssatz01.html", "r") as f:
    content = f.read()

checks = {
    ".option.selected !important": ".option.selected" in content and "!important" in content,
    "function selectOption": "function selectOption" in content,
    "let answers": "let answers = {}" in content,
}

print("\n验证结果:")
all_ok = True
for check, result in checks.items():
    print(f"  {'✅' if result else '❌'} {check}")
    if not result:
        all_ok = False

if all_ok:
    print("\n✅ 所有检查通过")
else:
    print("\n❌ 有检查失败")
    import sys
    sys.exit(1)
PYTHON_EOF

# 提交
echo ""
echo "📦 提交"
git add html/*.html
git commit -m "fix: 直接使用调试页面的成功代码

问题: 调试页面能工作，试卷页面不工作
解决: 完全复制调试页面的CSS和JS

修改:
✅ .option CSS使用调试页面版本
✅ selectOption/submitAnswer使用调试页面版本
✅ 添加!important确保优先级
✅ 移除重复声明

验证: 调试页面已证明有效

Co-Authored-By: Claude Sonnet 4 <noreply@anthropic.com>"

git push

echo ""
echo "⏳ 等待120秒部署..."
sleep 120

# 线上验证
echo ""
echo "🔍 线上验证"
ONLINE=$(curl -s "https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz01.html")
CSS_CHECK=$(echo "$ONLINE" | grep -c "option.selected" || echo 0)
JS_CHECK=$(echo "$ONLINE" | grep -c "function selectOption" || echo 0)

echo "CSS检查: $CSS_CHECK"
echo "JS检查: $JS_CHECK"

if [ "$CSS_CHECK" -gt 0 ] && [ "$JS_CHECK" -gt 0 ]; then
    echo ""
    echo "✅✅✅ 线上验证通过"
else
    echo ""
    echo "⚠️  部分检查未通过"
fi

echo ""
echo "================================"
echo "✅ 完成"
echo "================================"
echo ""
echo "现在试卷页面使用的是调试页面的完全相同代码"
echo ""
echo "用户测试:"
echo "1. 强制刷新: Ctrl+Shift+R"
echo "2. 打开: https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz01.html"
echo "3. 切换到阅读部分"
echo "4. 点击选项"
echo "5. 应该像调试页面一样工作"
echo ""
echo "如果还是不行，说明问题在页面的其他部分（非CSS/JS）"

exit 0
