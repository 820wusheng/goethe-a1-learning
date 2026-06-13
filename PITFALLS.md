# 🕳️ 踩坑记录 - 历史问题汇总

> **重要**: 每次开发新功能前必须阅读此文档，开发后必须review是否重复踩坑！

## 📋 开发流程（强制）

```
1. 开发前 → 阅读本文档所有踩坑项  ⚠️ 必须执行！
2. 开发中 → 对照踩坑清单避免重复错误
3. 开发后 → Review每一项，确认没有犯同样的错
4. 自测 → 自闭环检测，不能只运行代码就说完成  ⚠️ 必须执行！
5. 提交 → 更新本文档如果发现新坑
```

## 🔴 元坑：不遵守自己制定的流程 ❌❌❌

**最严重的问题**: 写了PITFALLS.md但自己开发时不遵守！

**症状** (持续发生 2026-06-11 → 06-12):
- 写了"开发前必读PITFALLS"，但自己开发时没读
- 写了"必须浏览器自测"，但直接说完成未实测
- 写了Skill流程，但从不执行，只是手动做
- 反复破坏已有功能：删除speakGerman、force push、不验证
- 用户反馈："之前绝对有正确的版本，为什么反复犯错？"

**2026-06-12新增症状**:
- ❌ 删除代码后不测试，导致朗读按钮消失
- ❌ force push破坏GitHub Pages部署（404错误）
- ❌ 回退到错误版本（28bc501只有框架无内容）
- ❌ 不做自闭环验证（本地+线上）就说"完成"
- ❌ 反复修改同一问题，每次都犯同样错误

**根本原因**:
- 写文档时很认真，开发时忘记流程
- 自以为记得内容，实际没有逐项检查
- 急于完成，跳过关键步骤
- **最关键：不使用git reflog查找历史正确版本**

**正确做法**:
```bash
# ✅ 每次开发前强制执行
Read PITFALLS.md  # 不能跳过！
# 对照每个检查点
# 在纸上或屏幕上打勾

# ✅ 开发后强制执行
python3 -m http.server 8080
# 浏览器逐页点击测试
# 所有功能验证通过

# ✅ 只有全部通过才告知用户完成
```

**检查点**:
- [ ] 开发前真的读了PITFALLS.md吗？（不是扫一眼）
- [ ] 每个检查项都确认了吗？（不是凭记忆）
- [ ] 浏览器真的测试了吗？（不是只运行代码）
- [ ] 所有链接都点击了吗？（不是假设有效）

---

---

## 🔴 关键踩坑（务必注意）

### 1. 【音频播放】音频无法播放 ❌

**症状**: 点击音频按钮报404 Not Found

**原因**: 
- CORS跨域限制
- 直接引用外部音频URL会被浏览器阻止

**错误做法**:
```html
<!-- ❌ 错误 -->
<button onclick="playAudio('https://bfu.goethe.de/...')">播放</button>
```

**正确做法**:
```html
<!-- ✅ 正确：双音频系统 -->
<!-- 方案1: AI朗读 - 直接在页面播放 -->
<button onclick="speakGerman(text)">🔊 AI朗读</button>

<!-- 方案2: 官方音频 - 新窗口打开 -->
<a href="官方音频URL" target="_blank">📻 官方音频</a>
```

**检查点**:
- [ ] 每个音频按钮都有AI朗读选项
- [ ] 官方音频使用`target="_blank"`新窗口打开
- [ ] 不要试图直接在页面内播放外部音频

**⚠️ 新坑（2026-06-11）: 外部音频链接失效**

**症状**: 官方Goethe网站音频链接返回404 Not Found

**原因**: 
- 外部网站链接不稳定
- URL可能变更或文件被删除
- 无法控制外部资源

**错误做法**:
```html
<!-- ❌ 错误：依赖外部链接 -->
<a href="https://bfu.goethe.de/medien/a1/audio_1_1.mp4">官方音频</a>
<!-- 外部链接随时可能失效！-->
```

**正确做法**:
```html
<!-- ✅ 方案1：本地音频播放器（推荐）-->
<audio controls>
    <source src="../archive_audio/sd1_modellsatz.mp4" type="audio/mp4">
</audio>

<!-- ✅ 方案2：AI朗读 -->
<button onclick="speakGerman(text)">🔊 朗读</button>
```

**检查点**:
- [ ] 使用本地音频文件，不依赖外部链接
- [ ] 提供AI朗读作为备选
- [ ] 每次部署后必须测试音频播放

---

### 2. 【翻译准确性】自动翻译错误 ❌

**症状**: 
- "Schneider"翻译成"裁缝"而不是人名"施奈德"
- "19,95 Euro"翻译成"1995年欧元"而不是"19.95欧元"
- 自动翻译生硬不自然

**原因**:
- Whisper AI语音识别有错误
- MyMemory API等自动翻译不理解上下文

**错误做法**:
```javascript
// ❌ 错误：直接使用Whisper转录 + 自动翻译
const transcript = whisper_result;  // Zimmer 250
const translation = auto_translate(transcript);  // 裁缝在等
```

**正确做法**:
```javascript
// ✅ 正确：手动校对 + 人工翻译
// 1. 使用Whisper转录仅作参考
// 2. 对照PDF官方Transkriptionen手动修正
// 3. 手动翻译所有内容
const transcript = "Zimmer 254";  // 修正后
const translation = "254号房间";  // 人工翻译
```

**检查点**:
- [ ] 所有听力原文都对照过PDF官方文档
- [ ] 人名保持德文原文或正确音译（Schneider → 施奈德）
- [ ] 数字和价格正确（19,95 → 19.95）
- [ ] 翻译自然流畅，符合中文习惯

**关键修正清单**:
```
❌ Zimmer 250 → ✅ Zimmer 254
❌ 1995 Euro → ✅ 19,95 Euro
❌ 裁缝 → ✅ 施奈德先生
❌ Polo衫 → ✅ 毛衣(Pullover)
```

---

### 3. 【页面功能】页面不完整/功能缺失 ❌

**症状**:
- 页面只有部分内容（只有听力，缺少阅读/写作/口语）
- 按钮点不了、无响应
- 翻译功能缺失

**原因**:
- JavaScript函数未定义或引用错误
- HTML元素ID不匹配
- 数据文件路径错误

**错误做法**:
```html
<!-- ❌ 错误：功能不全 -->
<div onclick="someFunction()">...</div>  <!-- 函数未定义 -->
<script src="wrong-path.js"></script>     <!-- 路径错误 -->
```

**正确做法**:
```html
<!-- ✅ 正确：完整功能 -->
<!-- 1. 确保JS文件正确引入 -->
<script src="../js/quiz-common.js"></script>

<!-- 2. 确保函数已定义 -->
<div onclick="toggleTranslation('task-1')">...</div>

<!-- 3. 确保ID匹配 -->
<div id="task-1">...</div>
```

**检查点**:
- [ ] 所有按钮都有对应的JavaScript函数
- [ ] 所有页面包含完整的4部分（听力、阅读、写作、口语）
- [ ] 翻译按钮可切换显示/隐藏
- [ ] 数据文件路径正确（相对路径）

---

### 4. 【答题功能】提交答案后无反馈 ❌

**症状**:
- 点击选项无高亮
- 点击提交无反应
- 不显示对错
- 分数不更新

**原因**:
- 缺少答题系统JavaScript逻辑
- 选项没有`data-answer`属性
- 没有提交按钮或按钮禁用
- answers.json数据缺失

**错误做法**:
```html
<!-- ❌ 错误：无答题功能 -->
<div class="option">a) 答案A</div>  <!-- 没有data-answer和onclick -->
```

**正确做法**:
```html
<!-- ✅ 正确：完整答题系统 -->
<div class="option" 
     data-answer="a" 
     onclick="selectOption('task1', 'a', this)">
    <strong>a</strong> 答案A
</div>

<button class="submit-btn" 
        disabled 
        onclick="submitAnswer('task1')">
    提交答案
</button>

<div class="result-message"></div>
```

**检查点**:
- [ ] 每个选项有`data-answer`属性
- [ ] 每个选项有`onclick`事件
- [ ] 每个题目有提交按钮
- [ ] 每个题目有结果消息区域
- [ ] answers.json文件存在且格式正确
- [ ] 顶部有分数统计面板

---

### 5. 【文件路径】重构后路径失效 ❌

**症状**:
- 数据加载失败(404)
- 图片/CSS/JS无法加载
- 页面样式错乱

**原因**:
- 移动文件后相对路径未更新
- 使用了绝对路径
- 大小写错误（Mac不敏感但Linux敏感）

**错误做法**:
```javascript
// ❌ 错误：硬编码路径 / 未更新
fetch('vocabulary_data.json')  // 文件已移到data/目录
fetch('/data/file.json')        // 绝对路径，部署后失效
```

**正确做法**:
```javascript
// ✅ 正确：相对路径 + 正确目录
fetch('../data/vocabulary_data.json')  // 从html/目录访问data/
fetch('../data/transcripts_with_translation.json')
```

**检查点**:
- [ ] 所有数据文件使用相对路径
- [ ] 路径大小写正确
- [ ] 目录结构清晰：html/, data/, js/, audio/
- [ ] 移动文件后grep检查所有引用

---

### 6. 【自测不充分】只运行代码未实测 ❌

**症状**:
- 代码能运行但功能不对
- 浏览器报错但未发现
- 用户反馈功能异常

**原因**:
- 没有在浏览器中实际点击测试
- 只检查代码没有检查效果
- 没有对照历史踩坑清单

**错误做法**:
```
开发完成 → 直接提交 → 告诉用户"完成了" ❌
```

**正确做法**:
```
开发完成 → 
  1. 阅读PITFALLS.md所有检查点
  2. 启动HTTP服务器
  3. 浏览器逐页测试
  4. 对照测试清单打勾
  5. 所有功能验证通过
  6. 提交代码
  7. 告诉用户"已完成并自测通过"
```

**自测清单**:
- [ ] 主页所有链接可点击
- [ ] 每套题能正常加载
- [ ] AI朗读功能正常
- [ ] 官方音频链接有效
- [ ] 翻译按钮切换正常
- [ ] 答题流程完整（选择→提交→对错→分数）
- [ ] 所有页面在浏览器控制台无错误
- [ ] 关键词检查（施奈德、19.95欧元）

---

### 7. 【数据完整性】内容简化/缺失 ❌

**症状**:
- 听力原文不完整（缺少部分对话）
- 例句缺失
- 题目数量不对

**原因**:
- 自以为简化了更好
- 解析脚本有bug跳过了内容
- 没有验证总数

**错误做法**:
```python
# ❌ 错误：跳过长文本
if len(text) > 100:
    continue  # 丢失数据！
```

**正确做法**:
```python
# ✅ 正确：完整保留
all_text = extract_all()  # 不简化
assert len(all_text) == EXPECTED_COUNT  # 验证总数
```

**检查点**:
- [ ] 听力原文完整（包含所有角色对话）
- [ ] 词汇表100%有例句
- [ ] 题目数量正确（Teil1:6题, Teil2:4题, Teil3:5题）
- [ ] 与官方PDF对照验证

---

## 📊 质量检查清单（每次开发后必查）

### 代码检查
- [ ] 所有音频按钮都是双系统（AI+官方）
- [ ] 所有翻译都经过人工校对
- [ ] 所有页面功能完整（4部分）
- [ ] 所有数据文件路径正确
- [ ] 所有选项有答题功能

### 内容检查
- [ ] 关键词：施奈德（不是裁缝）
- [ ] 关键词：19.95欧元（不是1995）
- [ ] 关键词：Zimmer 254（不是250）
- [ ] 听力原文完整（无简化）
- [ ] 题目总数正确（15题）

### 浏览器测试
- [ ] 主页导航正常
- [ ] 题库页面正常
- [ ] 每套题加载正常
- [ ] AI朗读有效
- [ ] 官方音频有效
- [ ] 翻译切换正常
- [ ] 答题功能完整
- [ ] 控制台无错误

### 文档检查
- [ ] README.md更新
- [ ] CHANGELOG.md记录
- [ ] 本文档PITFALLS.md更新（如有新坑）

---

## 🎯 新功能开发SOP

1. **开发前**
   - [ ] 阅读PITFALLS.md全文
   - [ ] 列出可能踩的坑
   - [ ] 制定预防措施

2. **开发中**
   - [ ] 对照踩坑清单编码
   - [ ] 避免已知错误模式
   - [ ] 及时记录新发现的问题

3. **开发后**
   - [ ] Review所有踩坑检查点
   - [ ] 自闭环测试（不能只运行代码）
   - [ ] 浏览器完整测试
   - [ ] 更新文档

4. **提交前**
   - [ ] 所有检查项通过
   - [ ] Git commit message清晰
   - [ ] 告知用户已自测通过

---

## 🔄 持续改进

**发现新坑时**:
1. 立即记录到本文档
2. 分析根本原因
3. 提供错误和正确做法对比
4. 添加检查点
5. 提交更新

**定期Review**:
- 每月回顾是否有重复踩坑
- 总结新的模式和最佳实践
- 优化开发流程

---

**最后更新**: 2026-06-11  
**版本**: v1.0  
**状态**: ✅ 所有已知坑已记录

## 🔴 2026-06-12 新坑：使用错误的参考文件

**问题**: 使用exam-complete.html作为参考，但它本身就没有交互功能

**症状**:
- 阅读部分无法选择答案
- 选项没有onclick和data-answer
- 复制后的页面全都没有交互

**根本原因**:
- exam-complete.html只是静态展示，没有JS交互
- listening-complete.html才有完整的selectOption/submitAnswer
- skill没有验证参考文件是否有交互功能

**正确做法**:
```bash
# ✅ 使用listening-complete.html作为参考
REFERENCE="html/listening-complete.html"

# ✅ 验证参考文件有交互
HAS_SELECT=$(grep -c "function selectOption" "$REFERENCE")
if [ "$HAS_SELECT" -eq 0 ]; then
    echo "❌ 参考文件缺少交互"
    exit 1
fi
```

**Skill自我修正**:
- auto-fix-exam.sh必须验证参考文件
- check-full-features.sh必须检查onclick存在
- 错误发生后立即更新PITFALLS

## 🔴 2026-06-13 核心错误：没有完整参考文件

**问题**: 项目中没有任何HTML同时具备4部分和交互功能

**现状**:
- listening-complete.html: 只有听力，但有交互JS
- exam-complete.html: 有4部分，但无交互JS
- 所有试卷: 复制单一参考导致不完整

**根本原因**:
Skill假设存在"完整参考文件"，但实际不存在

**正确做法**:
```bash
# ✅ 不能只复制一个文件
# ✅ 需要合并两个文件的优势

# 从exam-complete获取4部分结构
cp exam-complete.html target.html

# 从listening-complete提取交互JS
extract_js listening-complete.html >> target.html
```

**Skill修正**:
build-complete-exam.sh会合并两个参考文件
