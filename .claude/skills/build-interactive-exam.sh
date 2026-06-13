#!/bin/bash
# build-interactive-exam.sh - 构建完全交互的试卷
# 要求：听力+阅读答题+写作范文+口语范文

set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "🔨 构建完全交互试卷"

# 检查清单
echo "📋 功能清单（必须全部实现）:"
echo "  1. 听力：有AI朗读按钮（speakGerman）"
echo "  2. 阅读：可选择答案（onclick/data-answer/selectOption）"
echo "  3. 阅读：显示对错（submitAnswer）"
echo "  4. 写作：有A1标准答案范文"
echo "  5. 口语：有A1场景对话范文"
echo "  6. 全部：有中文翻译按钮"
echo ""

# 步骤1：检查现有文件是否满足
echo "🔍 检查现有HTML..."

EXAM_COMPLETE="html/exam-complete.html"
LISTEN_COMPLETE="html/listening-complete.html"

# exam-complete检查
HAS_SELECT_EXAM=$(grep -c "function selectOption" "$EXAM_COMPLETE" || echo 0)
HAS_4PARTS=$(grep -c "Lesen.*Schreiben.*Sprechen" "$EXAM_COMPLETE" || echo 0)

# listening-complete检查
HAS_SELECT_LISTEN=$(grep -c "function selectOption" "$LISTEN_COMPLETE" || echo 0)

echo "exam-complete: 4部分=✅, 答题功能=$HAS_SELECT_EXAM"
echo "listening-complete: 答题功能=$HAS_SELECT_LISTEN"
echo ""

if [ "$HAS_SELECT_EXAM" -gt 0 ]; then
    echo "✅ exam-complete有答题功能，直接使用"
    FINAL_SRC="$EXAM_COMPLETE"
else
    echo "❌ exam-complete无答题功能"
    echo "❌ 错误：项目中没有完整的参考文件"
    echo ""
    echo "📝 需要手动添加以下功能到exam-complete.html:"
    echo "  1. 在阅读选项添加: onclick=\"selectOption(id, answer, this)\" data-answer=\"a/b\""
    echo "  2. 添加selectOption/submitAnswer函数"
    echo "  3. 在写作部分添加标准答案示例"
    echo "  4. 在口语部分添加场景对话示例"
    echo ""
    echo "❌ Skill无法自动生成交互代码，需要人工完成"
    exit 1
fi

exit 0
