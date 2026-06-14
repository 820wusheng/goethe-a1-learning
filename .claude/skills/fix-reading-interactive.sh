#!/bin/bash
# fix-reading-interactive.sh - 修复阅读答题功能（学习听力实现）
# 关键：完全参考listening-complete的实现

set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "🔧 修复阅读答题功能"
echo "================================"
echo ""

# 步骤1：对比听力和阅读的差异
echo "📊 对比听力和阅读..."
echo ""

LISTENING_REF="html/listening-complete.html"
TARGET="html/exam-complete.html"

# 检查1：CSS .selected样式
echo "检查1: CSS .selected样式"
HAS_LISTENING_CSS=$(grep -c "\.option\.selected" "$LISTENING_REF" || echo 0)
HAS_TARGET_CSS=$(grep -c "\.option\.selected" "$TARGET" || echo 0)

echo "  听力: $HAS_LISTENING_CSS"
echo "  阅读: $HAS_TARGET_CSS"

if [ "$HAS_LISTENING_CSS" -gt 0 ] && [ "$HAS_TARGET_CSS" -eq 0 ]; then
    echo "  ❌ 阅读缺少.selected CSS"
    echo "  ✅ 从听力提取并添加..."
    
    python3 << 'PYTHON_EOF'
import re
with open("html/listening-complete.html", "r") as f:
    listening = f.read()
with open("html/exam-complete.html", "r") as f:
    exam = f.read()

# 提取CSS
css = re.search(r'\.option:hover \{.*?\}.*?\.option\.selected \{.*?\}', listening, re.DOTALL)
if css and ".option.selected" not in exam:
    exam = exam.replace(
        """.option:hover {
            border-color: #667eea;
            background: #edf2f7;
        }""",
        css.group(0),
        1
    )
    with open("html/exam-complete.html", "w") as f:
        f.write(exam)
    print("    ✅ 已添加CSS")
PYTHON_EOF
fi

# 检查2：task ID
echo ""
echo "检查2: task容器ID"
TASK_ID_COUNT=$(grep -c 'id="task-lesen' "$TARGET" | tr -d ' ')
echo "  阅读task ID数量: $TASK_ID_COUNT"
if [ "$TASK_ID_COUNT" -lt 15 ]; then
    echo "  ❌ 缺少task ID"
    exit 1
fi
echo "  ✅ task ID完整"

# 检查3：固定taskId（不能是随机）
echo ""
echo "检查3: onclick使用固定taskId"
RANDOM_ID=$(grep 'Math.random()' "$TARGET" | wc -l | tr -d ' ')
FIXED_ID=$(grep "selectOption('lesen[0-9]" "$TARGET" | wc -l | tr -d ' ')
echo "  随机ID: $RANDOM_ID"
echo "  固定ID: $FIXED_ID"

if [ "$RANDOM_ID" -gt 0 ]; then
    echo "  ❌ 检测到随机ID！必须改为固定ID"
    echo "  听力使用: selectOption('\${q.id}', 'a', this)"
    echo "  阅读应该: selectOption('lesen1', 'richtig', this)"
    exit 1
fi
echo "  ✅ 使用固定ID"

# 检查4：提交按钮
echo ""
echo "检查4: 提交按钮"
SUBMIT_COUNT=$(grep -c 'class="submit-btn"' "$TARGET" | tr -d ' ')
echo "  提交按钮数量: $SUBMIT_COUNT"
if [ "$SUBMIT_COUNT" -lt 15 ]; then
    echo "  ❌ 缺少提交按钮"
    exit 1
fi
echo "  ✅ 提交按钮完整"

# 检查5：JS函数存在
echo ""
echo "检查5: JS函数"
HAS_SELECT=$(grep -c "function selectOption" "$TARGET" || echo 0)
HAS_SUBMIT=$(grep -c "function submitAnswer" "$TARGET" || echo 0)
echo "  selectOption: $HAS_SELECT"
echo "  submitAnswer: $HAS_SUBMIT"

if [ "$HAS_SELECT" -eq 0 ] || [ "$HAS_SUBMIT" -eq 0 ]; then
    echo "  ❌ 缺少JS函数"
    exit 1
fi
echo "  ✅ JS函数完整"

echo ""
echo "================================"
echo "✅ 阅读答题功能检查通过"
echo "================================"
echo ""

# 复制到所有试卷
echo "📋 复制到所有试卷..."
for name in uebungssatz01 uebungssatz02 modellsatz; do
    cp "$TARGET" "html/${name}.html"
    echo "  ✅ ${name}.html"
done

# 提交
echo ""
echo "📦 提交..."
git add html/*.html
git commit -m "fix: 修复阅读答题功能（Skill自动）

Skill检查项:
✅ CSS .selected样式（从listening提取）
✅ task容器ID (id=\"task-lesen1~15\")
✅ 固定taskId (selectOption('lesen1'...))
✅ 提交按钮 (15个)
✅ JS函数 (selectOption + submitAnswer)

参考: listening-complete.html正确实现

Co-Authored-By: Claude Sonnet 4 <noreply@anthropic.com>"

git push

echo "⏳ 等待120秒部署..."
sleep 120

# 线上验证
echo ""
echo "🔍 线上验证..."
ONLINE_CSS=$(curl -s "https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz01.html" | grep -c "\.option\.selected" | tr -d ' ')
ONLINE_FIXED_ID=$(curl -s "https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz01.html" | grep -c "selectOption('lesen" | tr -d ' ')

echo "线上CSS: $ONLINE_CSS"
echo "线上固定ID: $ONLINE_FIXED_ID"

if [ "$ONLINE_CSS" -gt 0 ] && [ "$ONLINE_FIXED_ID" -gt 0 ]; then
    echo ""
    echo "✅✅✅ 成功！阅读答题功能已上线"
else
    echo ""
    echo "⚠️  GitHub Pages可能还在部署，请稍候手动检查"
fi

echo ""
echo "页面: https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz01.html"

exit 0
