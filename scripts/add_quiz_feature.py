#!/usr/bin/env python3
"""
为听力和阅读页面添加答题功能
- 用户可以选择答案
- 提交后显示对错
- 显示正确答案
- 统计总分
"""

import json
import re

# 添加到HTML中的CSS样式
QUIZ_CSS = """
        .option {
            padding: 12px 20px;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.2s;
            position: relative;
        }

        .option:hover {
            border-color: #667eea;
            background: #edf2f7;
        }

        .option.selected {
            border-color: #667eea;
            background: #e6f2ff;
        }

        .option.correct {
            border-color: #48bb78;
            background: #c6f6d5;
        }

        .option.incorrect {
            border-color: #f56565;
            background: #fed7d7;
        }

        .option.correct::after {
            content: '✓';
            position: absolute;
            right: 20px;
            color: #48bb78;
            font-weight: bold;
            font-size: 1.5em;
        }

        .option.incorrect::after {
            content: '✗';
            position: absolute;
            right: 20px;
            color: #f56565;
            font-weight: bold;
            font-size: 1.5em;
        }

        .submit-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1em;
            font-weight: 600;
            margin-top: 15px;
            transition: all 0.3s;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .submit-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .result-message {
            margin-top: 15px;
            padding: 15px;
            border-radius: 8px;
            font-weight: 600;
            display: none;
        }

        .result-message.correct {
            background: #c6f6d5;
            color: #22543d;
            border: 2px solid #48bb78;
            display: block;
        }

        .result-message.incorrect {
            background: #fed7d7;
            color: #742a2a;
            border: 2px solid #f56565;
            display: block;
        }

        .score-board {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            text-align: center;
        }

        .score-board h3 {
            margin-bottom: 10px;
            font-size: 1.5em;
        }

        .score-board .score {
            font-size: 2.5em;
            font-weight: bold;
        }
"""

# JavaScript代码
QUIZ_JS = """
        // 答题系统
        let answers = {};  // 存储正确答案
        let userAnswers = {};  // 存储用户答案
        let submitted = {};  // 跟踪哪些题目已提交

        // 加载答案数据
        async function loadAnswers() {
            try {
                const response = await fetch('../data/answers.json');
                const data = await response.json();
                answers = data.hoeren || {};
                console.log('答案加载成功', answers);
            } catch (error) {
                console.error('答案加载失败:', error);
            }
        }

        // 选择答案
        function selectOption(taskId, answer, element) {
            if (submitted[taskId]) return;  // 已提交的不能再选

            // 移除同题其他选项的选中状态
            const taskElement = element.closest('.task');
            taskElement.querySelectorAll('.option').forEach(opt => {
                opt.classList.remove('selected');
            });

            // 标记当前选项为选中
            element.classList.add('selected');
            userAnswers[taskId] = answer;

            // 启用提交按钮
            const submitBtn = taskElement.querySelector('.submit-btn');
            if (submitBtn) {
                submitBtn.disabled = false;
            }
        }

        // 提交答案
        function submitAnswer(taskId) {
            if (!userAnswers[taskId] || submitted[taskId]) return;

            const correctAnswer = answers[taskId];
            const userAnswer = userAnswers[taskId];
            const isCorrect = userAnswer === correctAnswer;

            submitted[taskId] = true;

            // 标记选项
            const taskElement = document.querySelector(`#task-${taskId}`);
            if (!taskElement) return;

            taskElement.querySelectorAll('.option').forEach(opt => {
                const optAnswer = opt.dataset.answer;
                if (optAnswer === correctAnswer) {
                    opt.classList.add('correct');
                }
                if (optAnswer === userAnswer && !isCorrect) {
                    opt.classList.add('incorrect');
                }
            });

            // 显示结果消息
            const resultMsg = taskElement.querySelector('.result-message');
            if (resultMsg) {
                resultMsg.className = 'result-message ' + (isCorrect ? 'correct' : 'incorrect');
                resultMsg.textContent = isCorrect ?
                    '✓ 回答正确！' :
                    `✗ 回答错误。正确答案是：${getOptionLabel(correctAnswer)}`;
            }

            // 禁用提交按钮
            const submitBtn = taskElement.querySelector('.submit-btn');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.textContent = '已提交';
            }

            // 更新分数
            updateScore();
        }

        // 获取选项标签
        function getOptionLabel(answer) {
            const mapping = {
                'a': 'a',
                'b': 'b',
                'c': 'c',
                'richtig': 'Richtig',
                'falsch': 'Falsch'
            };
            return mapping[answer] || answer;
        }

        // 更新分数
        function updateScore() {
            let correct = 0;
            let total = 0;

            Object.keys(submitted).forEach(taskId => {
                if (submitted[taskId]) {
                    total++;
                    if (userAnswers[taskId] === answers[taskId]) {
                        correct++;
                    }
                }
            });

            // 更新分数显示
            document.querySelectorAll('.score-value').forEach(el => {
                el.textContent = `${correct} / ${total}`;
            });

            // 计算百分比
            const percentage = total > 0 ? Math.round((correct / total) * 100) : 0;
            document.querySelectorAll('.score-percentage').forEach(el => {
                el.textContent = `(${percentage}%)`;
            });
        }

        // 重置所有答案
        function resetQuiz() {
            if (!confirm('确定要重置所有答案吗？')) return;

            userAnswers = {};
            submitted = {};

            // 清除所有标记
            document.querySelectorAll('.option').forEach(opt => {
                opt.classList.remove('selected', 'correct', 'incorrect');
            });

            // 清除结果消息
            document.querySelectorAll('.result-message').forEach(msg => {
                msg.className = 'result-message';
                msg.textContent = '';
            });

            // 重置提交按钮
            document.querySelectorAll('.submit-btn').forEach(btn => {
                btn.disabled = true;
                btn.textContent = '提交答案';
            });

            updateScore();
        }

        // 页面加载时初始化
        document.addEventListener('DOMContentLoaded', function() {
            loadAnswers();
        });
"""

print("✅ Quiz功能代码已准备")
print("📝 请手动将以下内容添加到HTML文件中：")
print("\n1. 在<style>标签中添加QUIZ_CSS")
print("2. 在<script>标签中添加QUIZ_JS")
print("3. 为每个option添加onclick和data-answer属性")
print("4. 为每个task添加id、提交按钮和结果消息区域")
