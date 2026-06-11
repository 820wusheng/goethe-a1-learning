#!/usr/bin/env python3
"""
手动修正翻译错误，使用更准确的中文翻译
"""
import json

# 手动提供准确的中文翻译
ACCURATE_TRANSLATIONS = {
    "bsp1": {
        "task": "示例 1",
        "german": "Ach, Verzeihung. Wo finde ich Herrn Schneider vom Betriebsrat? \nSchneider... warten Sie mal. Ich glaube, der ist in Zimmernummer 250. \nJa, stimmt, Zimmer 250. Das ist im zweiten Stock. Da können Sie den Aufzug nehmen.\nZweiter Stock, Zimmer 250. Okay, vielen Dank.",
        "chinese": "啊，不好意思。请问劳资委员会的施奈德先生在哪里？\n施奈德...等一下。我想他在250号房间。\n是的，没错，250号房间。在二楼。您可以乘电梯。\n二楼，250号房间。好的，非常感谢。"
    },
    "1_1": {
        "task": "题目 1",
        "german": "Entschuldigung, was kostet dieser Pullover jetzt?\nEr kostet 30 Prozent billiger.\nEin Moment bitte.\n19,95.\n19,95 Euro.\nJa, Euro natürlich.\nOkay, den nehme ich.",
        "chinese": "不好意思，这件毛衣现在多少钱？\n便宜30%。\n请稍等。\n19.95。\n19.95欧元。\n是的，当然是欧元。\n好的，我要了。"
    },
    "1_2": {
        "task": "题目 2",
        "german": "Entschuldigen Sie bitte.\nJa bitte.\nHaben Sie eine Uhr?\nWie spät ist es bitte?\nJa.\nJetzt ist es gleich fünf Uhr.\nWas?\nSchon fünf?\nVielen Dank. Wiedersehen.",
        "chinese": "不好意思打扰一下。\n您好，什么事？\n您有手表吗？\n请问现在几点了？\n有的。\n现在快五点了。\n什么？\n已经五点了？\n非常感谢。再见。"
    },
    "1_3": {
        "task": "题目 3",
        "german": "Was wünschen Sie bitte? \nIch hätte gern die Salatplatte.\nEntschuldigung. Die Salatplatte ist leider aus, aber die Bratwurst kann ich Ihnen empfehlen. Ganz frisch heute.\nNein, danke. Ich esse kein Fleisch. Gibt es etwas ohne Fleisch?\nJa, nicht mehr viel. Fisch oder Pommes?\nFisch.\nJa, dann will ich Pommes.",
        "chinese": "您想要点什么？\n我想要沙拉拼盘。\n不好意思。沙拉拼盘已经售罄了，但我可以推荐烤香肠。今天很新鲜。\n不用了，谢谢。我不吃肉。有不含肉的吗？\n有的，但不多了。鱼还是薯条？\n鱼。\n那我要薯条吧。"
    },
    "1_4": {
        "task": "题目 4",
        "german": "Haben Sie Kinder, Frau Heger?\nJa, einen Sohn.\nUnd wie alt ist der?\n9 Jahre, seit gestern.\nAch, da geht der ja schon zur Schule.\nJa, klar, schon in die dritte Klasse.",
        "chinese": "您有孩子吗，黑格女士？\n有的，一个儿子。\n他多大了？\n从昨天起9岁了。\n哦，那他已经上学了。\n是的，当然，已经上三年级了。"
    },
    "1_5": {
        "task": "题目 5",
        "german": "Entschuldigen Sie, wie komme ich denn hier in den zweiten Stock? Die Rolltreppe ist kaputt.\nDa gehen Sie hier rechts um die Ecke und nehmen den Aufzug.\nUm die Ecke rechts.\nAh, danke.",
        "chinese": "不好意思，我怎么去二楼？自动扶梯坏了。\n您在这里右转拐角，然后乘电梯。\n拐角处右转。\n啊，谢谢。"
    },
    "1_6": {
        "task": "题目 6",
        "german": "Guten Morgen Herr Albers. So früh schon bei der Arbeit.\nJa, ich habe noch viel zu tun. Morgen fahre ich doch für drei Wochen weg.\nAch ja, das habe ich vergessen.\nWohin fahren Sie denn?\nZu meinen Verwandten, nach Polen.\nNa dann, schöne Zeit.",
        "chinese": "早上好，阿尔伯斯先生。这么早就来上班了。\n是的，我还有很多事要做。明天我要离开三周。\n哦对，我忘了。\n您要去哪里？\n去看我的亲戚，去波兰。\n那么，祝您玩得愉快。"
    },
    "bsp2": {
        "task": "示例 2",
        "german": "Frau Kathrin Gundlach, angekommen aus Budapest, wird zum Informationsschalter in der Ankunftshalle C gebeten.\nFrau Gundlach, bitte zum Informationsschalter in der Ankunftshalle C.",
        "chinese": "从布达佩斯抵达的卡特琳·贡德拉赫女士，请到C到达大厅的问讯处。\n贡德拉赫女士，请到C到达大厅的问讯处。"
    },
    "2_1": {
        "task": "题目 7",
        "german": "Liebe Kunden, zu Weihnachten bieten wir Ihnen super Preise an.\nZum Beispiel: erstklassiger italienischer Weißwein für 12,28 Euro die Flasche oder\nexklusiver argentinischer Rotwein für 9,68 Euro.\nBesuchen Sie uns im dritten Stock vor Weihnachten.",
        "chinese": "亲爱的顾客们，圣诞节我们为您提供超值优惠。\n例如：一级意大利白葡萄酒每瓶12.28欧元，或\n特选阿根廷红葡萄酒每瓶9.68欧元。\n圣诞节前请到三楼光顾我们。"
    },
    "2_2": {
        "task": "题目 8",
        "german": "Liebe Fahrgäste, wir sind kurz vor Würzburg, sicherlich haben Sie schon Hunger.\nAn der nächsten Raststätte halten wir für eine Stunde.\nWir treffen uns wieder um halb eins am Bus, aber bitte pünktlich sein.",
        "chinese": "亲爱的乘客们，我们马上就到维尔茨堡了，您肯定已经饿了。\n我们会在下一个休息站停留一小时。\n我们12点半在大巴旁集合，请务必准时。"
    },
    "2_3": {
        "task": "题目 9",
        "german": "Liebe Fahrgäste, bitte beachten Sie, das ist ein außerplanmäßiger Halt.\nBitte hier nicht aussteigen.\nIn ein paar Minuten erreichen wir den Bahnhof von Bad Rappenau.",
        "chinese": "亲爱的乘客们，请注意，这是临时停靠。\n请不要在这里下车。\n几分钟后我们将到达巴德拉佩瑙火车站。"
    },
    "2_4": {
        "task": "题目 10",
        "german": "Herr Stefan Jander, gebucht auf dem Flug LH737 nach Warschau, wird zum Schalter F7 gebeten.\nDer Flug wird in ein paar Minuten geschlossen. Herr Jander, gebucht nach Warschau, bitte nach F7.",
        "chinese": "预订了LH737航班飞往华沙的斯特凡·扬德先生，请到F7柜台。\n航班将在几分钟后关闭。扬德先生，预订飞往华沙的，请到F7。"
    },
    "3_1": {
        "task": "题目 11",
        "german": "Telefonansagedienst der deutschen Telekom. Die Rufnummer des Teilnehmers hat sich geändert.\nBitte rufen Sie die Telefonauskunft an unter 11833.",
        "chinese": "德国电信电话语音服务。用户的电话号码已更改。\n请拨打电话查询服务11833。"
    },
    "3_2": {
        "task": "题目 12",
        "german": "Hallo Jan, hier ist Boris.\nIch bin noch im Zug.\nDu holst mich doch vom Bahnhof ab.\nIch warte an der Information auf dich.",
        "chinese": "你好扬，我是鲍里斯。\n我还在火车上。\n你会来火车站接我吧。\n我在问讯处等你。"
    },
    "3_3": {
        "task": "题目 13",
        "german": "Mensch, Jan, hier nochmal Boris. Ich bin jetzt am Bahnhof und du, wo bist du denn?\nIch warte schon über 20 Minuten auf dich. Also 10 Minuten Zeit hast du noch, bis zwei, dann nehme ich ein Taxi.",
        "chinese": "天哪，扬，我是鲍里斯。我现在在火车站，你呢，你在哪里？\n我已经等你20多分钟了。你还有10分钟时间，到两点，然后我就打车走了。"
    },
    "3_4": {
        "task": "题目 14",
        "german": "Guten Tag, hier Rogala. Wir können am Samstag leider nicht zu Ihnen kommen. Am Sonntag haben wir aber Zeit.\nRufen Sie uns doch bitte zurück, ob Ihnen das passt. Danke.",
        "chinese": "您好，我是罗加拉。很遗憾我们周六不能去您那里。但我们周日有时间。\n如果您方便的话请给我们回电话。谢谢。"
    },
    "3_5": {
        "task": "题目 15",
        "german": "Hallo Alex, Walter hier. Kannst du schnell mal rüberkommen?\nMein Computer hat einen Fehler. Ich kann nichts drucken.\nMelde dich doch bitte gleich, wenn du nach Hause kommst.",
        "chinese": "你好亚历克斯，我是沃尔特。你能快点过来一下吗？\n我的电脑出故障了。我打印不了东西。\n你回家后请马上联系我。"
    }
}

def main():
    # 保存修正后的翻译
    with open('../transcripts_with_translation.json', 'w', encoding='utf-8') as f:
        json.dump(ACCURATE_TRANSLATIONS, f, ensure_ascii=False, indent=2)

    print("✅ 翻译已修正并保存到 transcripts_with_translation.json")
    print(f"📊 共修正 {len(ACCURATE_TRANSLATIONS)} 个题目")

if __name__ == '__main__':
    main()
