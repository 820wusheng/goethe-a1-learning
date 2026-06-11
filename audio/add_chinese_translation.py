#!/usr/bin/env python3
"""
使用MyMemory API为德语转录添加中文翻译
"""
import json
import time
import requests

def translate_text(german_text):
    """使用MyMemory API翻译德语到中文"""
    url = "https://api.mymemory.translated.net/get"

    # 将长文本分段翻译
    paragraphs = german_text.split('\n')
    translated = []

    for para in paragraphs:
        if not para.strip():
            translated.append('')
            continue

        params = {
            'q': para,
            'langpair': 'de|zh-CN'
        }

        try:
            response = requests.get(url, params=params, timeout=10)
            data = response.json()

            if data.get('responseStatus') == 200:
                chinese = data['responseData']['translatedText']
                translated.append(chinese)
                print(f"✅ 翻译: {para[:50]}...")
            else:
                print(f"❌ 翻译失败: {para[:50]}...")
                translated.append(para)  # 保留原文

            time.sleep(0.5)  # 避免API限流

        except Exception as e:
            print(f"❌ 错误: {e}")
            translated.append(para)

    return '\n'.join(translated)

def main():
    # 读取转录JSON
    with open('../transcripts.json', 'r', encoding='utf-8') as f:
        transcripts = json.load(f)

    translated_data = {}

    for task_id, task_data in transcripts.items():
        print(f"\n🔄 处理 {task_data['task']}...")

        german_text = task_data['text']
        chinese_text = translate_text(german_text)

        translated_data[task_id] = {
            'task': task_data['task'],
            'german': german_text,
            'chinese': chinese_text
        }

        print(f"✅ {task_data['task']} 完成")

    # 保存
    output_file = '../transcripts_with_translation.json'
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(translated_data, f, ensure_ascii=False, indent=2)

    print(f"\n✅ 已保存到: {output_file}")

if __name__ == '__main__':
    main()
