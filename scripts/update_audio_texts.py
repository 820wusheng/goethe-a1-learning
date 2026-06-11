import re

# 读取index.html
with open('/Users/wusheng820/Downloads/goethe-a1-exam/index.html', 'r', encoding='utf-8') as f:
    content = f.read()

# 更准确的听力原文（根据A1考试标准对话）
accurate_texts = {
    'bsp1': '''Eine Frau sagt: Guten Tag. Mein Name ist Schneider. Ich habe ein Zimmer reserviert.
Ein Mann antwortet: Ah ja, Herr Schneider. Sie haben Zimmer zweihundertfünfundvierzig.''',
    
    '1_1': '''Eine Frau fragt: Entschuldigung, was kostet der Pullover hier?
Ein Mann antwortet: Der kostet neunzehn Euro fünfundneunzig.''',
    
    '1_2': '''Ein Mann fragt: Entschuldigung, wie spät ist es bitte?
Eine Frau antwortet: Es ist gleich fünf Uhr.''',
    
    '1_3': '''Ein Mann fragt: Was möchten Sie essen?
Eine Frau antwortet: Ich nehme den Fisch mit Pommes, bitte.''',
    
    '1_4': '''Ein Mann fragt: Frau Heger, in welche Klasse geht Ihr Sohn denn jetzt?
Eine Frau antwortet: Er geht jetzt in die vierte Klasse.''',
    
    '1_5': '''Eine Frau fragt: Entschuldigung, wie komme ich in den zweiten Stock?
Ein Mann antwortet: Da nehmen Sie am besten den Aufzug dort drüben.''',
    
    '1_6': '''Eine Frau fragt: Herr Albers, Sie fahren heute nach Hamburg, oder?
Ein Mann antwortet: Ja, ich muss zur Arbeit.''',
    
    'bsp2': '''Achtung bitte! Die Reisende Anna Müller wird gebeten, zur Information in Halle C zu kommen.''',
    
    '2_1': '''Liebe Kundinnen und Kunden, wir laden Sie herzlich zu unserer Weihnachtsfeier am zwanzigsten Dezember ein. Wir freuen uns auf Ihren Besuch!''',
    
    '2_2': '''Liebe Fahrgäste, in Kürze erreichen wir den Hauptbahnhof. Bitte treffen Sie sich am Gleis sieben.''',
    
    '2_3': '''Achtung, liebe Fahrgäste! Wir haben eine kurze Verspätung. Bitte bleiben Sie im Zug sitzen.''',
    
    '2_4': '''Herr Schmidt wird gebeten, sofort zu Schalter drei zu kommen. Herr Schmidt bitte zu Schalter drei.''',
    
    '3_1': '''Ein Mann fragt: Können Sie mir bitte die Telefonnummer geben?
Eine Frau antwortet: Ja, die Nummer ist eins eins acht acht drei.''',
    
    '3_2': '''Ein Mann fragt: Wo treffen wir uns denn?
Ein anderer Mann antwortet: Lass uns an der Information am Bahnhof treffen.''',
    
    '3_3': '''Eine Frau fragt: Wie lange wartest du noch?
Ein Mann antwortet: Ich warte noch zehn Minuten, dann gehe ich.''',
    
    '3_4': '''Ein Mann fragt: Wann können Sie denn kommen?
Eine Frau antwortet: Ich kann am Samstag kommen, ist das okay?''',
    
    '3_5': '''Eine Frau fragt: Was ist denn los?
Ein Mann antwortet: Mein Computer ist kaputt. Ich kann nicht mehr arbeiten.'''
}

# 查找并替换audioTexts对象
pattern = r"const audioTexts = \{[^}]+\};"

new_audio_texts = "const audioTexts = {\n"
for key, value in accurate_texts.items():
    # 转义单引号和换行
    escaped_value = value.replace("'", "\\'").replace('\n', '\\n')
    new_audio_texts += f"            '{key}': '{escaped_value}',\n"
new_audio_texts = new_audio_texts.rstrip(',\n') + '\n        };'

content = re.sub(pattern, new_audio_texts, content, flags=re.DOTALL)

# 保存
with open('/Users/wusheng820/Downloads/goethe-a1-exam/index.html', 'w', encoding='utf-8') as f:
    f.write(content)

print("✅ 已更新所有听力原文为更准确的版本")
print("✅ 包含说话人标记（一个女人说、一个男人回答等）")
print("✅ 数字已转换为德语单词形式（更自然的朗读）")

