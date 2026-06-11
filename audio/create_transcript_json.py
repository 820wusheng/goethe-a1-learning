#!/usr/bin/env python3
"""
整理Whisper转录的文本，生成包含所有听力原文的JSON
"""
import json
import os
from pathlib import Path

def read_transcript(filename):
    """读取转录文本文件"""
    filepath = Path('transcripts') / filename
    if filepath.exists():
        with open(filepath, 'r', encoding='utf-8') as f:
            return f.read().strip()
    return ""

def main():
    # 定义所有音频文件的映射
    audio_map = {
        # Teil 1
        'bsp1': 'Beispiel 1',
        '1_1': 'Aufgabe 1',
        '1_2': 'Aufgabe 2',
        '1_3': 'Aufgabe 3',
        '1_4': 'Aufgabe 4',
        '1_5': 'Aufgabe 5',
        '1_6': 'Aufgabe 6',
        # Teil 2
        'bsp2': 'Beispiel 2',
        '2_1': 'Aufgabe 7',
        '2_2': 'Aufgabe 8',
        '2_3': 'Aufgabe 9',
        '2_4': 'Aufgabe 10',
        # Teil 3
        '3_1': 'Aufgabe 11',
        '3_2': 'Aufgabe 12',
        '3_3': 'Aufgabe 13',
        '3_4': 'Aufgabe 14',
        '3_5': 'Aufgabe 15',
    }

    transcripts = {}

    for audio_id, task_name in audio_map.items():
        # 处理文件名
        if audio_id.startswith('3_'):
            # Teil 3 文件名格式不同
            filename = f'audio{audio_id}.txt'
        else:
            filename = f'audio_{audio_id}.txt'

        text = read_transcript(filename)
        if text:
            transcripts[audio_id] = {
                'task': task_name,
                'text': text
            }
            print(f"✅ {task_name}: {len(text)} 字符")
        else:
            print(f"❌ {task_name}: 文件不存在 ({filename})")

    # 保存为JSON
    output_file = '../transcripts.json'
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(transcripts, f, ensure_ascii=False, indent=2)

    print(f"\n✅ 已保存到: {output_file}")
    print(f"📊 共 {len(transcripts)} 个转录")

if __name__ == '__main__':
    main()
