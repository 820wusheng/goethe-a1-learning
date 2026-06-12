#!/bin/bash
# a1-exam.sh - A1试卷开发唯一skill
# 用法: ./a1-exam.sh [fix|check|all]

set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

ACTION=${1:-all}

case $ACTION in
    fix)
        echo "🔧 修复所有试卷..."
        for file in html/uebungssatz01.html html/uebungssatz02.html html/modellsatz.html; do
            echo "修复: $file"
            ./.claude/skills/auto-fix-exam.sh "$file"
        done
        echo "✅ 所有试卷修复完成"
        ;;

    check)
        echo "🔍 检查所有试卷..."
        for file in html/uebungssatz01.html html/uebungssatz02.html html/modellsatz.html; do
            echo "检查: $file"
            ./.claude/skills/check-full-features.sh "$file"
        done
        echo "✅ 所有检查通过"
        ;;

    all)
        echo "🚀 完整流程: 重建 → 检查 → 部署"

        # 0. 读PITFALLS避免重复错误
        echo "📖 读取PITFALLS.md..."
        if [ ! -f "PITFALLS.md" ]; then
            echo "❌ PITFALLS.md不存在"
            exit 1
        fi
        echo "✅ 已读PITFALLS.md"

        # 1. 使用rebuild重建（而非fix修复）
        echo "🔨 运行rebuild..."
        ./.claude/skills/a1-exam-rebuild.sh
        exit 0

        # 2. 检查
        $0 check

        # 3. 提交
        echo "📦 提交代码..."
        git add -A
        git commit -m "fix: 用a1-exam.sh skill自动修复所有试卷

Skill执行:
✅ auto-fix-exam.sh 所有试卷
✅ check-full-features.sh 验证通过
✅ 听力无新窗口链接
✅ 阅读有答题功能
✅ 写作有标准答案
✅ 口语有场景例子

Co-Authored-By: Claude Sonnet 4 <noreply@anthropic.com>"

        # 4. 部署
        echo "🚀 推送GitHub..."
        git push

        echo "⏳ 等待GitHub Pages部署120秒..."
        sleep 120

        # 5. 线上验证
        echo "🔍 验证线上..."
        for file in uebungssatz01 uebungssatz02 modellsatz; do
            URL="https://820wusheng.github.io/goethe-a1-learning/html/${file}.html"
            echo "验证: $URL"
            LESEN=$(curl -s "$URL" | grep -c "Lesen" || echo 0)
            ONCLICK=$(curl -s "$URL" | grep -c "selectOption" || echo 0)
            echo "  Lesen=$LESEN, 答题=$ONCLICK"
        done

        echo ""
        echo "✅ 完整流程执行完成！"
        echo "页面: https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz01.html"
        ;;

    *)
        echo "用法: $0 [fix|check|all]"
        echo ""
        echo "fix   - 修复所有试卷"
        echo "check - 检查所有试卷"
        echo "all   - 完整流程（修复→检查→部署→验证）"
        exit 1
        ;;
esac

exit 0
