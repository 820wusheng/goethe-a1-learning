#!/bin/bash
# debug-reading.sh - 调试阅读答题问题
set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "🔍 调试阅读答题功能"
echo "================================"

# 1. 对比听力和阅读的完整差异
echo "1. 对比听力listening-complete.html和阅读uebungssatz01.html"
echo ""

# 下载线上文件
curl -s "https://820wusheng.github.io/goethe-a1-learning/html/listening-complete.html" > /tmp/listen.html
curl -s "https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz01.html" > /tmp/read.html

echo "CSS对比:"
echo "  听力.selected: $(grep -c '\.option\.selected' /tmp/listen.html)"
echo "  阅读.selected: $(grep -c '\.option\.selected' /tmp/read.html)"

echo ""
echo "JS函数对比:"
echo "  听力selectOption: $(grep -c 'function selectOption' /tmp/listen.html)"
echo "  阅读selectOption: $(grep -c 'function selectOption' /tmp/read.html)"

echo ""
echo "变量初始化对比:"
LISTEN_VARS=$(grep -c "let answers\|let userAnswers\|let submitted" /tmp/listen.html || echo 0)
READ_VARS=$(grep -c "let answers\|let userAnswers\|let submitted" /tmp/read.html || echo 0)
echo "  听力变量声明: $LISTEN_VARS"
echo "  阅读变量声明: $READ_VARS"

# 2. 检查阅读HTML结构
echo ""
echo "2. 检查阅读HTML结构"
echo ""

# 提取第一个阅读task
FIRST_TASK=$(grep -A 20 'id="task-lesen1"' /tmp/read.html | head -25)
echo "第一个阅读task:"
echo "$FIRST_TASK" | grep "class=\"task\"\|onclick\|class=\"option\""

# 检查onclick
ONCLICK_COUNT=$(grep -c "onclick=\"selectOption('lesen" /tmp/read.html || echo 0)
echo ""
echo "onclick数量: $ONCLICK_COUNT"

# 3. 检查可能的JS错误
echo ""
echo "3. 检查可能导致JS失败的问题"
echo ""

# 检查是否有未闭合的引号
UNCLOSED=$(grep -o "onclick=\"selectOption([^\"]*$" /tmp/read.html | wc -l | tr -d ' ')
echo "未闭合引号: $UNCLOSED"

# 检查script标签数量
SCRIPT_COUNT=$(grep -c "<script>" /tmp/read.html || echo 0)
echo "script标签数量: $SCRIPT_COUNT"

# 4. 生成调试用的最小HTML
echo ""
echo "4. 生成调试页面"
echo ""

cat > html/debug-reading-test.html << 'DEBUG_EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>阅读答题调试</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        .task { background: #f0f0f0; padding: 20px; margin: 20px 0; }
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
        .option.selected {
            border-color: #667eea;
            background: #e6f2ff;
        }
        .submit-btn {
            padding: 10px 20px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .submit-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        #debug-log {
            background: #000;
            color: #0f0;
            padding: 10px;
            margin-top: 20px;
            font-family: monospace;
            font-size: 12px;
            max-height: 300px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <h1>阅读答题功能调试</h1>
    <p>打开浏览器Console (F12) 查看详细日志</p>
    
    <div class="task" id="task-lesen1">
        <h3>测试题目 1</h3>
        <p>问题：这是一道测试题</p>
        <div class="options">
            <div class="option" data-answer="richtig" onclick="selectOption('lesen1', 'richtig', this)">
                <strong>a</strong> Richtig 正确
            </div>
            <div class="option" data-answer="falsch" onclick="selectOption('lesen1', 'falsch', this)">
                <strong>b</strong> Falsch 错误
            </div>
        </div>
        <button class="submit-btn" disabled onclick="submitAnswer('lesen1')">提交答案</button>
        <div class="result-message"></div>
    </div>
    
    <div id="debug-log"></div>

    <script>
        const debugLog = document.getElementById('debug-log');
        function log(msg) {
            const time = new Date().toLocaleTimeString();
            debugLog.innerHTML += `[${time}] ${msg}<br>`;
            console.log(msg);
        }
        
        log("🔧 Script开始执行");
        
        let answers = {};
        let userAnswers = {};
        let submitted = {};
        
        answers['lesen1'] = 'richtig';
        
        log("✅ 变量初始化完成");
        log("answers: " + JSON.stringify(answers));
        
        function selectOption(taskId, answer, element) {
            log(`📌 selectOption调用: taskId=${taskId}, answer=${answer}`);
            
            if (submitted[taskId]) {
                log("⚠️ 已提交，忽略");
                return;
            }
            
            const taskElement = element.closest(".task");
            log(`🔍 closest('.task'): ${taskElement ? 'found' : 'NOT FOUND'}`);
            
            if (!taskElement) {
                log("❌ 错误：找不到.task元素");
                return;
            }
            
            taskElement.querySelectorAll(".option").forEach(opt => {
                opt.classList.remove("selected");
            });
            log("🗑️ 清除所有selected");
            
            element.classList.add("selected");
            log("✅ 添加selected到当前元素");
            
            userAnswers[taskId] = answer;
            log("💾 保存答案: " + JSON.stringify(userAnswers));
            
            const submitBtn = taskElement.querySelector(".submit-btn");
            if (submitBtn) {
                submitBtn.disabled = false;
                log("✅ 启用提交按钮");
            } else {
                log("⚠️ 未找到提交按钮");
            }
        }
        
        function submitAnswer(taskId) {
            log(`📤 submitAnswer调用: taskId=${taskId}`);
            
            if (!userAnswers[taskId]) {
                log("❌ 错误：未选择答案");
                return;
            }
            
            submitted[taskId] = true;
            const correct = answers[taskId];
            const user = userAnswers[taskId];
            const isCorrect = (user === correct);
            
            log(`📊 正确答案: ${correct}, 用户答案: ${user}`);
            log(`${isCorrect ? '✅ 正确！' : '❌ 错误'}`);
            
            const msg = document.querySelector(".result-message");
            if (msg) {
                msg.textContent = isCorrect ? "✓ 正确！" : "✗ 错误";
                msg.style.display = "block";
                msg.style.padding = "10px";
                msg.style.marginTop = "10px";
                msg.style.background = isCorrect ? "#c6f6d5" : "#fed7d7";
                msg.style.color = isCorrect ? "#22543d" : "#742a2a";
            }
        }
        
        log("✅ Script执行完成");
        log("👆 请点击上面的选项测试");
    </script>
</body>
</html>
DEBUG_EOF

echo "✅ 已创建 html/debug-reading-test.html"
echo ""
echo "================================"
echo "📋 调试步骤："
echo "================================"
echo ""
echo "1. 在浏览器打开："
echo "   https://820wusheng.github.io/goethe-a1-learning/html/debug-reading-test.html"
echo ""
echo "2. 打开浏览器Console (按F12)"
echo ""
echo "3. 点击选项，观察："
echo "   - 选项是否高亮（蓝色边框+浅蓝背景）"
echo "   - Console是否有错误"
echo "   - 调试日志显示什么"
echo ""
echo "4. 如果调试页面正常工作，问题在于uebungssatz01.html的某个差异"
echo ""
echo "5. 常见问题："
echo "   - CSS被后续样式覆盖"
echo "   - JS作用域问题"
echo "   - HTML结构嵌套错误"
echo "   - event.target指向错误"
echo ""

# 提交调试页面
git add html/debug-reading-test.html
git commit -m "debug: 添加阅读答题调试页面

调试页面功能:
- 详细Console日志
- 页面内调试输出
- 最小化HTML结构
- 完整交互功能

使用方法:
打开 html/debug-reading-test.html
观察点击行为和日志

Co-Authored-By: Claude Sonnet 4 <noreply@anthropic.com>"

git push

echo ""
echo "✅ 调试页面已部署"
echo "⏳ 等待120秒..."
sleep 120

echo ""
echo "🔍 调试页面已上线："
echo "https://820wusheng.github.io/goethe-a1-learning/html/debug-reading-test.html"
echo ""
echo "请用户："
echo "1. 打开此调试页面"
echo "2. 打开Console (F12)"
echo "3. 点击选项并截图Console日志"
echo "4. 报告现象"

