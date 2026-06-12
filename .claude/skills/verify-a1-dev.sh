#!/bin/bash
# verify-a1-dev - A1德语网站开发验证脚本
# 用法: ./verify-a1-dev.sh

set -e

echo "🔍 开始A1网站验证..."

# 1. 检查AI朗读按钮数量
AI_COUNT=$(grep -c "AI朗读" js/quiz-common.js || echo 0)
if [ "$AI_COUNT" -ne 4 ]; then
    echo "❌ 错误: AI朗读按钮数量=$AI_COUNT (期望4)"
    exit 1
fi
echo "✅ AI朗读按钮: $AI_COUNT"

# 2. 检查是否有题目定义冲突
TEIL_IN_COMMON=$(grep -c "const TEIL1_QUESTIONS" js/quiz-common.js || echo 0)
if [ "$TEIL_IN_COMMON" -ne 0 ]; then
    echo "❌ 错误: quiz-common.js不应包含题目定义(会覆盖config)"
    exit 1
fi
echo "✅ 无题目定义冲突"

# 3. 检查数据文件存在
for file in data/archive_uebung01.json data/archive_uebung02.json; do
    if [ ! -f "$file" ]; then
        echo "❌ 错误: 数据文件不存在 $file"
        exit 1
    fi
done
echo "✅ 数据文件完整"

# 4. 检查config文件
for file in js/uebung01-config.js js/uebung02-config.js; do
    if [ ! -f "$file" ]; then
        echo "❌ 错误: 配置文件不存在 $file"
        exit 1
    fi
    # 确认定义了TEIL1_QUESTIONS
    if ! grep -q "const TEIL1_QUESTIONS" "$file"; then
        echo "❌ 错误: $file 缺少TEIL1_QUESTIONS定义"
        exit 1
    fi
done
echo "✅ 配置文件正确"

# 5. 检查speakGerman函数
if ! grep -q "function speakGerman" js/quiz-common.js; then
    echo "❌ 错误: quiz-common.js缺少speakGerman函数"
    exit 1
fi
echo "✅ speakGerman函数存在"

# 6. 检查是否有占位符
PLACEHOLDER=$(grep -r "开发中\|TODO\|内容\.\.\." html/*.html || echo "")
if [ -n "$PLACEHOLDER" ]; then
    echo "❌ 错误: 发现占位符内容"
    echo "$PLACEHOLDER"
    exit 1
fi
echo "✅ 无占位符内容"

echo ""
echo "✅ 所有验证通过！可以部署。"
exit 0
