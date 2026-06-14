# 🔴 2026-06-14 CSS缺失问题记录

## 问题
用户反馈：阅读部分还是点击无法选中无显示结果

## 症状
- 点击阅读选项无高亮
- HTML结构完整（有onclick、taskId、提交按钮）
- JS函数存在
- 但就是不工作

## 根本原因

### 1. git恢复删除了CSS
```bash
git checkout HEAD~2 -- html/exam-complete.html
```
- 恢复的版本没有`.option.selected` CSS
- 后续所有复制都基于这个不完整的文件

### 2. 从不对比听力参考
- 听力有`.selected` CSS，阅读没有
- 复制了20次但从未检查差异

### 3. Skill没有参考检查
- 应该对比listening-complete
- CSS、JS、HTML结构应该一致

## 听力vs阅读对比

| 检查项 | 听力 | 阅读 | 说明 |
|--------|------|------|------|
| CSS .selected | ✅ | ❌ | **核心问题** |
| JS selectOption | ✅ | ✅ | 有 |
| JS submitAnswer | ✅ | ✅ | 有 |
| onclick | ✅ | ✅ | 有 |
| 固定taskId | ✅ | ✅ | 有 |
| 提交按钮 | ✅ | ✅ | 有 |

**唯一差异**: CSS样式

## 正确解决方案

```bash
# 1. 对比听力
grep "\.option\.selected" html/listening-complete.html  # 有
grep "\.option\.selected" html/exam-complete.html      # 没有

# 2. 从听力提取CSS
python3 << 'EOF'
import re
with open("html/listening-complete.html", "r") as f:
    listening = f.read()
css = re.search(r'\.option:hover.*?\.option\.selected.*?\}', listening, re.DOTALL)

with open("html/exam-complete.html", "r") as f:
    exam = f.read()
exam = exam.replace(".option:hover {...}", css.group(0), 1)
with open("html/exam-complete.html", "w") as f:
    f.write(exam)
EOF

# 3. 复制
cp html/exam-complete.html html/uebungssatz01.html
```

## Skill改进

创建 `fix-reading-interactive.sh`:

```bash
# 步骤1：对比听力和阅读
检查CSS、JS、HTML差异

# 步骤2：从听力提取缺失部分
if 听力有 && 阅读没有:
    从listening提取CSS
    添加到exam-complete

# 步骤3：5项检查
- CSS .selected
- task ID
- 固定taskId (不能随机)
- 提交按钮
- JS函数

# 步骤4：线上验证
curl 检查线上CSS存在
```

## 关键规则

🔴 **阅读答题功能必须参考listening-complete实现**
🔴 **复制文件前先对比听力，确认完整一致**
🔴 **git恢复后必须检查关键功能是否缺失**
🔴 **Skill必须包含对比listening-complete的检查**
🔴 **5项必查：CSS/taskID/固定ID/提交按钮/JS函数**

## 标准开发流程

### ✅ 正确流程
1. 先看listening-complete怎么实现的
2. 对比差异：diff listening exam
3. 缺什么补什么
4. 检查5项必查清单
5. 本地验证
6. 部署
7. 线上验证

### ❌ 错误流程
1. 自己想怎么实现
2. 写完就复制
3. 不检查差异
4. 用户说不行才发现
