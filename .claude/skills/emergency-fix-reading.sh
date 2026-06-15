#!/bin/bash
# emergency-fix-reading.sh - 紧急修复阅读选择（强制内联样式）
set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "🚨 紧急修复阅读选择功能"
echo "================================"
echo ""
echo "策略：使用内联样式 + 简化JS，确保100%工作"
echo ""

# 创建完全独立的测试页面
cat > html/reading-simple-test.html << 'HTML_EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>阅读答题简化测试</title>
</head>
<body style="font-family: Arial; padding: 20px; background: #f5f5f5;">
    <h1 style="color: #667eea;">阅读答题简化测试</h1>
    <p style="color: red; font-weight: bold;">如果这个页面能工作，说明问题在试卷页面的其他部分</p>
    
    <div style="background: white; padding: 20px; margin: 20px 0; border-radius: 10px; border-left: 5px solid #667eea;">
        <h3>测试题目</h3>
        <p><strong>Lis Zug kommt aus Hannover.</strong></p>
        <p style="color: #666;">莉的火车来自汉诺威。</p>
        
        <div style="margin: 20px 0;">
            <div id="opt-a" 
                 style="padding: 15px; margin: 10px 0; background: white; border: 2px solid #ddd; border-radius: 8px; cursor: pointer;"
                 onclick="choose('a')">
                <strong>a</strong> Richtig 正确
            </div>
            <div id="opt-b"
                 style="padding: 15px; margin: 10px 0; background: white; border: 2px solid #ddd; border-radius: 8px; cursor: pointer;"
                 onclick="choose('b')">
                <strong>b</strong> Falsch 错误
            </div>
        </div>
        
        <button id="submit-btn"
                style="padding: 12px 30px; background: #ccc; color: white; border: none; border-radius: 8px; font-size: 16px; cursor: not-allowed;"
                disabled
                onclick="submit()">
            提交答案
        </button>
        
        <div id="result" style="margin-top: 20px; padding: 15px; display: none; border-radius: 8px;"></div>
    </div>
    
    <div style="background: #000; color: #0f0; padding: 15px; margin: 20px 0; border-radius: 8px; font-family: monospace; font-size: 12px;">
        <div id="log">等待点击...</div>
    </div>

    <script>
        let selected = null;
        const correctAnswer = 'b'; // 正确答案是Falsch
        
        function log(msg) {
            document.getElementById('log').innerHTML += '<br>' + new Date().toLocaleTimeString() + ': ' + msg;
            console.log(msg);
        }
        
        log('页面加载完成');
        
        function choose(answer) {
            log('点击了选项: ' + answer);
            
            selected = answer;
            
            // 清除所有高亮
            document.getElementById('opt-a').style.border = '2px solid #ddd';
            document.getElementById('opt-a').style.background = 'white';
            document.getElementById('opt-b').style.border = '2px solid #ddd';
            document.getElementById('opt-b').style.background = 'white';
            
            // 高亮当前选项
            const element = document.getElementById('opt-' + answer);
            element.style.border = '3px solid #667eea';
            element.style.background = '#e6f2ff';
            
            log('已高亮选项: ' + answer);
            
            // 启用提交按钮
            const btn = document.getElementById('submit-btn');
            btn.disabled = false;
            btn.style.background = '#667eea';
            btn.style.cursor = 'pointer';
            
            log('提交按钮已启用');
        }
        
        function submit() {
            log('点击提交按钮');
            
            if (!selected) {
                log('错误：未选择答案');
                return;
            }
            
            const isCorrect = (selected === correctAnswer);
            const result = document.getElementById('result');
            
            result.style.display = 'block';
            
            if (isCorrect) {
                result.style.background = '#c6f6d5';
                result.style.color = '#22543d';
                result.innerHTML = '✓ 正确！';
                log('✅ 正确');
            } else {
                result.style.background = '#fed7d7';
                result.style.color = '#742a2a';
                result.innerHTML = '✗ 错误，正确答案是 Falsch';
                log('❌ 错误');
            }
            
            // 禁用提交按钮
            const btn = document.getElementById('submit-btn');
            btn.disabled = true;
            btn.style.background = '#ccc';
            btn.style.cursor = 'not-allowed';
        }
        
        log('所有函数已定义');
    </script>
</body>
</html>
HTML_EOF

echo "✅ 已创建 reading-simple-test.html"

# 提交
git add html/reading-simple-test.html
git commit -m "test: 创建极简阅读测试页面（内联样式）

完全内联样式和简化JS
排除所有可能的干扰因素
用于确认浏览器兼容性

测试地址:
https://820wusheng.github.io/goethe-a1-learning/html/reading-simple-test.html

Co-Authored-By: Claude Sonnet 4 <noreply@anthropic.com>"

git push

echo ""
echo "⏳ 等待部署（120秒）..."
sleep 120

echo ""
echo "================================"
echo "🧪 测试页面已上线"
echo "================================"
echo ""
echo "测试地址："
echo "https://820wusheng.github.io/goethe-a1-learning/html/reading-simple-test.html"
echo ""
echo "请用户："
echo "1. 打开上述页面"
echo "2. 点击 Richtig 或 Falsch"
echo "3. 观察："
echo "   - 选项是否变蓝色边框？"
echo "   - 提交按钮是否变蓝？"
echo "   - 点击提交是否显示结果？"
echo "   - 下方日志显示什么？"
echo ""
echo "如果这个页面能工作："
echo "  → 问题在试卷页面的复杂结构"
echo ""
echo "如果这个页面也不工作："
echo "  → 浏览器兼容性问题或JS被禁用"
echo "  → 请截图日志区域"

exit 0
