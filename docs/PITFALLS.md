
## 🔴 2026-06-17 翻译按钮不响应 - 内联style覆盖class

### 问题
toggleTranslation按钮点击无反应

### 症状
- toggleTranslation函数存在
- CSS .show类存在  
- 点击按钮没有任何变化

### 根本原因
内联`style="display: none;"`覆盖了`.show`类的`display: block;`

CSS优先级：**内联style > class**

```html
❌ 错误:
<div id="artikel1_cn" class="task-text chinese" style="display: none;">
<!-- toggleTranslation添加.show类，但内联style优先级更高 -->

✅ 正确:
<div id="artikel1_cn" class="task-text chinese">
<!-- 通过CSS类控制，.chinese默认隐藏，.show显示 -->
```

### 解决方案
删除内联`display: none`，完全用CSS类控制

### 规则
🔴 **toggleTranslation的目标元素不能有内联display样式**
🔴 **隐藏/显示必须通过CSS类控制，不能用内联style**
🔴 **添加HTML时检查是否有内联display覆盖class**

