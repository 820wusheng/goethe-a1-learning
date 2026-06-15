#!/bin/bash
# fix-onclick-inline.sh - 添加addEventListener确保事件触发
set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "🔧 修复onclick事件（添加addEventListener）"
echo "================================"

python3 << 'PYTHON_EOF'
with open("html/exam-complete.html", "r") as f:
    html = f.read()

# 在selectOption函数开头添加console.log
if "console.log('selectOption called" not in html:
    html = html.replace(
        "function selectOption(taskId, answer, element) {",
        """function selectOption(taskId, answer, element) {
    console.log('✅ selectOption called:', taskId, answer);""",
        1
    )
    print("✅ 已添加selectOption日志")

# 添加页面加载时的初始化脚本
init_script = """
// 页面加载完成后，为所有选项添加事件监听（双重保险）
document.addEventListener('DOMContentLoaded', function() {
    console.log('🔧 开始绑定阅读选项事件...');
    
    const options = document.querySelectorAll('.option[data-answer]');
    console.log('找到选项数量:', options.length);
    
    options.forEach((opt, index) => {
        // 从onclick属性提取参数
        const onclickAttr = opt.getAttribute('onclick');
        if (onclickAttr && onclickAttr.includes('selectOption')) {
            // 提取参数
            const match = onclickAttr.match(/selectOption\\('([^']+)',\\s*'([^']+)',\\s*this\\)/);
            if (match) {
                const taskId = match[1];
                const answer = match[2];
                
                // 添加事件监听（优先级更高）
                opt.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    console.log('🖱️ 点击事件触发:', taskId, answer);
                    selectOption(taskId, answer, this);
                }, true); // useCapture=true，最先触发
                
                console.log(`绑定 #${index+1}:`, taskId, answer);
            }
        }
    });
    
    console.log('✅ 事件绑定完成');
});
"""

if "开始绑定阅读选项事件" not in html:
    # 在</script>前添加
    html = html.replace("</script>", init_script + "\n</script>", 1)
    print("✅ 已添加addEventListener")

with open("html/exam-complete.html", "w") as f:
    f.write(html)

print("✅ 已更新exam-complete.html")
PYTHON_EOF

# 复制
for f in uebungssatz01 uebungssatz02 modellsatz; do
    cp html/exam-complete.html html/${f}.html
    echo "✅ ${f}.html"
done

# 提交
git add html/*.html
git commit -m "fix: 添加addEventListener双重保险+Console日志

问题: onclick可能被阻止或不触发
解决: 添加addEventListener作为备用

新增:
✅ console.log调试日志
✅ DOMContentLoaded事件监听
✅ addEventListener绑定所有选项
✅ useCapture=true优先触发

现在点击时Console会显示:
- 🔧 开始绑定阅读选项事件...
- 找到选项数量: N
- 🖱️ 点击事件触发: lesen1, richtig
- ✅ selectOption called: lesen1, richtig

Co-Authored-By: Claude Sonnet 4 <noreply@anthropic.com>"

git push

echo ""
echo "⏳ 等待120秒..."
sleep 120

echo ""
echo "✅ 已部署"
echo ""
echo "用户测试:"
echo "1. 强制刷新: Ctrl+Shift+R"
echo "2. 打开: https://820wusheng.github.io/goethe-a1-learning/html/uebungssatz01.html"
echo "3. 按F12打开Console"
echo "4. 切换到阅读部分"
echo "5. 观察Console日志（应该看到'开始绑定'等消息）"
echo "6. 点击选项"
echo "7. Console应该显示'点击事件触发'和'selectOption called'"
echo ""
echo "如果Console有日志但选项不保持选中，说明是CSS问题"
echo "如果Console没有日志，说明JS未加载"

exit 0
