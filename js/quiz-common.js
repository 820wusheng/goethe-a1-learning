/**
 * 通用答题系统 - 适用于所有听力练习页面
 * 功能：选择答案、提交、显示对错、统计分数
 */

// 全局变量
let answers = {};           // 正确答案
let userAnswers = {};       // 用户答案
let submitted = {};         // 已提交的题目
let transcriptData = {};    // 听力原文数据

// === Teil 1 题目配置 ===
const TEIL1_QUESTIONS = [
    {id: 'bsp1', q: 'Welche Zimmernummer hat Herr Schneider?', opts: ['Zimmer 2.', 'Zimmer 245.', 'Zimmer 254.']},
    {id: '1_1', q: 'Was kostet der Pullover?', opts: ['Dreißig Euro.', 'Fünfundneunzig Euro.', 'Neunzehn Euro fünfundneunzig Cent.']},
    {id: '1_2', q: 'Wie spät ist es?', opts: ['15 Uhr.', 'Gleich 5 Uhr.', 'Halb 5 Uhr.']},
    {id: '1_3', q: 'Was isst die Frau im Restaurant?', opts: ['Pommes.', 'Fisch.', 'Wurst.']},
    {id: '1_4', q: 'In welche Klasse geht Frau Hegers Sohn?', opts: ['In die neunte Klasse.', 'In die dritte Klasse.', 'In die vierte Klasse.']},
    {id: '1_5', q: 'Wie kommt die Frau in den 2. Stock?', opts: ['Mit dem Aufzug.', 'Auf der Treppe um die Ecke.', 'Mit der Rolltreppe.']},
    {id: '1_6', q: 'Wohin fährt Herr Albers?', opts: ['In Urlaub ans Meer.', 'Zur Arbeit.', 'Zur Familie.']}
];

// === Teil 2 题目配置 ===
const TEIL2_QUESTIONS = [
    {id: 'bsp2', q: 'Die Reisende soll zur Information in Halle C kommen.'},
    {id: '2_1', q: 'Die Kunden sollen die Weihnachtsfeier besuchen.'},
    {id: '2_2', q: 'Die Fahrgäste sollen sich im Restaurant treffen.'},
    {id: '2_3', q: 'Die Fahrgäste sollen im Zug bleiben.'},
    {id: '2_4', q: 'Der Herr soll sofort zum Schalter kommen.'}
];

// === Teil 3 题目配置 ===
const TEIL3_QUESTIONS = [
    {id: '3_1', q: 'Die Nummer ist:', opts: ['11833.', '11883.', '12833.']},
    {id: '3_2', q: 'Wo genau treffen sich die Männer?', opts: ['Am Zug.', 'Am Bahnhof.', 'An der Information.']},
    {id: '3_3', q: 'Wie lange will der Mann noch warten?', opts: ['20 Minuten.', '2 Minuten.', '10 Minuten.']},
    {id: '3_4', q: 'An welchem Tag will die Frau kommen?', opts: ['Am Montag.', 'Am Sonntag.', 'Am Samstag.']},
    {id: '3_5', q: 'Was ist kaputt?', opts: ['Der Fernseher.', 'Der Computer.', 'Das Handy.']}
];

// 切换Teil
function showTeil(teilId) {
    document.querySelectorAll('.teil-section').forEach(section => {
        section.classList.remove('active');
    });
    document.querySelectorAll('.nav-tab').forEach(tab => {
        tab.classList.remove('active');
    });

    document.getElementById(teilId).classList.add('active');
    event.target.classList.add('active');
}

// 切换翻译显示
function toggleTranslation(taskId) {
    const element = document.getElementById('chinese-' + taskId);
    element.classList.toggle('show');

    const button = document.getElementById('btn-' + taskId);
    if (element.classList.contains('show')) {
        button.textContent = '隐藏翻译';
    } else {
        button.textContent = '显示翻译';
    }
}

// AI朗读
function speakGerman(text) {
    if ('speechSynthesis' in window) {
        window.speechSynthesis.cancel();
        const utterance = new SpeechSynthesisUtterance(text);
        utterance.lang = 'de-DE';
        utterance.rate = 0.85;
        window.speechSynthesis.speak(utterance);
    } else {
        alert('您的浏览器不支持语音合成功能');
    }
}

// === 答题系统 ===

// 加载答案数据
async function loadAnswers() {
    try {
        const response = await fetch('../data/answers.json');
        const data = await response.json();
        answers = data.hoeren || {};
        console.log('✓ 答案数据加载成功');
    } catch (error) {
        console.error('答案加载失败:', error);
    }
}

// 选择答案
function selectOption(taskId, answer, element) {
    if (submitted[taskId]) return;

    const taskElement = element.closest('.task');
    taskElement.querySelectorAll('.option').forEach(opt => {
        opt.classList.remove('selected');
    });

    element.classList.add('selected');
    userAnswers[taskId] = answer;

    const submitBtn = taskElement.querySelector('.submit-btn');
    if (submitBtn) submitBtn.disabled = false;
}

// 提交答案
function submitAnswer(taskId) {
    if (!userAnswers[taskId] || submitted[taskId]) return;

    const correctAnswer = answers[taskId];
    const userAnswer = userAnswers[taskId];
    const isCorrect = userAnswer === correctAnswer;

    submitted[taskId] = true;

    const taskElement = document.getElementById('task-' + taskId);
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

    const resultMsg = taskElement.querySelector('.result-message');
    if (resultMsg) {
        resultMsg.className = 'result-message ' + (isCorrect ? 'correct' : 'incorrect');
        resultMsg.textContent = isCorrect ?
            '✓ 回答正确！' :
            `✗ 回答错误。正确答案是：${getOptionLabel(correctAnswer)}`;
    }

    const submitBtn = taskElement.querySelector('.submit-btn');
    if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.textContent = '已提交';
    }

    updateScore();
}

// 获取选项标签
function getOptionLabel(answer) {
    const mapping = {
        'a': 'a', 'b': 'b', 'c': 'c',
        'richtig': 'Richtig', 'falsch': 'Falsch'
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

    document.querySelectorAll('.score-value').forEach(el => {
        el.textContent = `${correct} / ${total}`;
    });

    const percentage = total > 0 ? Math.round((correct / total) * 100) : 0;
    document.querySelectorAll('.score-percentage').forEach(el => {
        el.textContent = `(${percentage}%)`;
    });
}

// === 数据加载和渲染 ===

// 加载数据并渲染页面
async function loadData() {
    try {
        const response = await fetch(DATA_FILE);
        const data = await response.json();
        transcriptData = data;
        renderTasks(data);
    } catch (error) {
        console.error('加载数据失败:', error);
        document.querySelector('.container').innerHTML = '<h2>加载失败，请确保数据文件存在</h2>';
    }
}

function renderTasks(data) {
    const teil1Tasks = renderTeil1(data);
    const teil2Tasks = renderTeil2(data);
    const teil3Tasks = renderTeil3(data);

    document.getElementById('teil1').innerHTML = teil1Tasks;
    document.getElementById('teil2').innerHTML = teil2Tasks;
    document.getElementById('teil3').innerHTML = teil3Tasks;
}

function renderTeil1(data) {
    let html = '<h2 style="color: #667eea; margin-bottom: 20px;">Teil 1: Gespräche 对话</h2>';

    TEIL1_QUESTIONS.forEach((q, index) => {
        const taskData = data[q.id];
        if (!taskData) return;

        const isExample = q.id.startsWith('bsp');
        const taskNum = isExample ? '示例' : `题目 ${index}`;

        // 音频文件路径
        const audioFile = q.id.startsWith('bsp') ?
            `../audio/audio_${q.id}.mp4` :
            `../audio/audio_${q.id}.mp4`;

        html += `
            <div class="task" id="task-${q.id}">
                <div class="task-header">
                    <div class="task-title">${taskNum}</div>
                    <div>
                        <button class="btn btn-primary" onclick="speakGerman(\`${taskData.german.replace(/`/g, "\\`")}\`)">
                            🔊 AI朗读
                        </button>
                        <audio controls style="max-width: 300px;">
                            <source src="${audioFile}" type="audio/mp4">
                        </audio>
                    </div>
                </div>

                <div class="task-question">${q.q}</div>

                <div class="options">
                    ${q.opts.map((opt, i) => `
                        <div class="option" data-answer="${String.fromCharCode(97 + i)}" onclick="selectOption('${q.id}', '${String.fromCharCode(97 + i)}', this)">
                            <strong>${String.fromCharCode(97 + i)}</strong> ${opt}
                        </div>
                    `).join('')}
                </div>

                <button class="submit-btn" disabled onclick="submitAnswer('${q.id}')">提交答案</button>
                <div class="result-message"></div>

                <div class="transcript">
                    <div class="transcript-header">
                        <span class="transcript-label">📝 听力原文</span>
                        <button id="btn-${q.id}" class="btn btn-secondary" onclick="toggleTranslation('${q.id}')">
                            显示翻译
                        </button>
                    </div>

                    <div class="german-text">${taskData.german}</div>
                    <div id="chinese-${q.id}" class="chinese-text">${taskData.chinese}</div>
                </div>
            </div>
        `;
    });

    return html;
}

function renderTeil2(data) {
    let html = '<h2 style="color: #667eea; margin-bottom: 20px;">Teil 2: Durchsagen 通知</h2>';

    TEIL2_QUESTIONS.forEach((q, index) => {
        const taskData = data[q.id];
        if (!taskData) return;

        const isExample = q.id.startsWith('bsp');
        const taskNum = isExample ? '示例' : `题目 ${index + 6}`;

        const audioFile = `../audio/audio_${q.id}.mp4`;

        html += `
            <div class="task" id="task-${q.id}">
                <div class="task-header">
                    <div class="task-title">${taskNum}</div>
                    <div>
                        <button class="btn btn-primary" onclick="speakGerman(\`${taskData.german.replace(/`/g, "\\`")}\`)">
                            🔊 AI朗读
                        </button>
                        <audio controls style="max-width: 300px;">
                            <source src="${audioFile}" type="audio/mp4">
                        </audio>
                    </div>
                </div>

                <div class="task-question">${q.q}</div>

                <div class="options">
                    <div class="option" data-answer="richtig" onclick="selectOption('${q.id}', 'richtig', this)"><strong>a</strong> Richtig 正确</div>
                    <div class="option" data-answer="falsch" onclick="selectOption('${q.id}', 'falsch', this)"><strong>b</strong> Falsch 错误</div>
                </div>

                <button class="submit-btn" disabled onclick="submitAnswer('${q.id}')">提交答案</button>
                <div class="result-message"></div>

                <div class="transcript">
                    <div class="transcript-header">
                        <span class="transcript-label">📝 听力原文</span>
                        <button id="btn-${q.id}" class="btn btn-secondary" onclick="toggleTranslation('${q.id}')">
                            显示翻译
                        </button>
                    </div>

                    <div class="german-text">${taskData.german}</div>
                    <div id="chinese-${q.id}" class="chinese-text">${taskData.chinese}</div>
                </div>
            </div>
        `;
    });

    return html;
}

function renderTeil3(data) {
    let html = '<h2 style="color: #667eea; margin-bottom: 20px;">Teil 3: Telefonansagen 电话留言</h2>';

    TEIL3_QUESTIONS.forEach((q, index) => {
        const taskData = data[q.id];
        if (!taskData) return;

        const audioFile = `../audio/audio${q.id}.mp4`;

        html += `
            <div class="task" id="task-${q.id}">
                <div class="task-header">
                    <div class="task-title">题目 ${index + 11}</div>
                    <div>
                        <button class="btn btn-primary" onclick="speakGerman(\`${taskData.german.replace(/`/g, "\\`")}\`)">
                            🔊 AI朗读
                        </button>
                        <audio controls style="max-width: 300px;">
                            <source src="${audioFile}" type="audio/mp4">
                        </audio>
                    </div>
                </div>

                <div class="task-question">${q.q}</div>

                <div class="options">
                    ${q.opts.map((opt, i) => `
                        <div class="option" data-answer="${String.fromCharCode(97 + i)}" onclick="selectOption('${q.id}', '${String.fromCharCode(97 + i)}', this)">
                            <strong>${String.fromCharCode(97 + i)}</strong> ${opt}
                        </div>
                    `).join('')}
                </div>

                <button class="submit-btn" disabled onclick="submitAnswer('${q.id}')">提交答案</button>
                <div class="result-message"></div>

                <div class="transcript">
                    <div class="transcript-header">
                        <span class="transcript-label">📝 听力原文</span>
                        <button id="btn-${q.id}" class="btn btn-secondary" onclick="toggleTranslation('${q.id}')">
                            显示翻译
                        </button>
                    </div>

                    <div class="german-text">${taskData.german}</div>
                    <div id="chinese-${q.id}" class="chinese-text">${taskData.chinese}</div>
                </div>
            </div>
        `;
    });

    return html;
}
