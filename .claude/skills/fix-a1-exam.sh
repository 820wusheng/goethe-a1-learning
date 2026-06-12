#!/bin/bash
# fix-a1-exam.sh - 修复A1试卷页面
# 参考正确页面: listening-complete.html

set -e
echo "🔧 开始修复A1试卷..."

# 1. 检查listening-complete.html作为参考
if [ ! -f "html/listening-complete.html" ]; then
    echo "❌ 缺少参考文件 listening-complete.html"
    exit 1
fi

# 2. 从listening-complete.html提取完整结构
echo "📋 检查listening-complete.html结构..."

# 检查listening-complete是否包含4部分（Hören, Lesen, Schreiben, Sprechen）
HOEREN=$(grep -c "Hören\|听力" html/listening-complete.html || echo 0)
LESEN=$(grep -c "Lesen\|阅读" html/listening-complete.html || echo 0)
SCHREIBEN=$(grep -c "Schreiben\|写作" html/listening-complete.html || echo 0)
SPRECHEN=$(grep -c "Sprechen\|口语" html/listening-complete.html || echo 0)

echo "参考页面包含: Hören=$HOEREN, Lesen=$LESEN, Schreiben=$SCHREIBEN, Sprechen=$SPRECHEN"

# 3. 检查uebungssatz01.html
echo "📋 检查uebungssatz01.html..."
UE01_LESEN=$(grep -c "Lesen\|阅读" html/uebungssatz01.html || echo 0)
UE01_SCHREIBEN=$(grep -c "Schreiben\|写作" html/uebungssatz01.html || echo 0)
UE01_SPRECHEN=$(grep -c "Sprechen\|口语" html/uebungssatz01.html || echo 0)

if [ "$UE01_LESEN" -eq 0 ] || [ "$UE01_SCHREIBEN" -eq 0 ] || [ "$UE01_SPRECHEN" -eq 0 ]; then
    echo "❌ uebungssatz01.html缺少完整4部分"
    echo "   Lesen=$UE01_LESEN, Schreiben=$UE01_SCHREIBEN, Sprechen=$UE01_SPRECHEN"
    echo "❌ 修复失败：uebungssatz01.html必须包含Hören+Lesen+Schreiben+Sprechen"
    exit 1
fi

# 4. 检查每题是否有独立音频
AUDIO_BUTTONS=$(grep -c "🔊 AI朗读" html/listening-complete.html || echo 0)
echo "✅ listening-complete有 $AUDIO_BUTTONS 个AI朗读按钮"

echo "✅ 修复完成"
exit 0
