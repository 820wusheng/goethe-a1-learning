#!/usr/bin/env python3
"""
解析Archive中的3套题目，创建JSON数据文件
- Modellsatz (模拟题)
- Übungssatz 01 (练习题01)
- Übungssatz 02 (练习题02)
"""

import json

# === 模拟题数据（和现有的一样）===
modellsatz_data = {
    "bsp1": {
        "german": """Frau: Ach, Verzeihung, wo finde ich Herrn Schneider vom Betriebsrat?
Mann: Schneider. Warten Sie mal. Ich glaube, der ist in Zimmer Nummer 254. Ja, stimmt, Zimmer 254. Das ist im zweiten Stock. Da können Sie den Aufzug hier nehmen.
Frau: Zweiter Stock, Zimmer 254. Okay, vielen Dank.""",
        "chinese": """女士：哦，不好意思，我在哪里可以找到劳资委员会的施奈德先生？
男士：施奈德。等一下。我想他在254号房间。是的，没错，254号房间。在二楼。你可以乘这里的电梯。
女士：二楼，254号房间。好的，非常感谢。"""
    },
    # ... 其他题目（和现有的transcripts_with_translation.json一样）
}

# === 练习题01数据 ===
uebung01_data = {
    "bsp1": {
        "german": """Frau: Ach, Verzeihung, wo finde ich Herrn Schneider vom Betriebsrat?
Mann: Schneider. Warten Sie mal. Ich glaube, der ist in Zimmer Nummer 254. Ja, stimmt, Zimmer 254. Das ist im zweiten Stock. Da können Sie den Aufzug hier nehmen.
Frau: Zweiter Stock, Zimmer 254. Okay, vielen Dank.""",
        "chinese": """女士：哦，不好意思，我在哪里可以找到劳资委员会的施奈德先生？
男士：施奈德。等一下。我想他在254号房间。是的，没错，254号房间。在二楼。你可以乘这里的电梯。
女士：二楼，254号房间。好的，非常感谢。"""
    },
    "1_1": {
        "german": """Maria: Weißt du, wo es hier Kleidung für Kinder gibt?
Laura: Oh, das weiß ich auch nicht. Aber sehen wir einmal auf die Information – Kinderspielzeug gibt es im vierten Stock, Damenkleidung im ersten. Hier: Im zweiten Stock findest du Kinderkleidung.""",
        "chinese": """玛丽亚：你知道这里哪里有儿童服装吗？
劳拉：哦，我也不知道。但我们看看信息牌——儿童玩具在四楼，女装在一楼。这里：在二楼你能找到儿童服装。"""
    },
    "1_2": {
        "german": """Ober: Hier, bitte, die Speisekarte. Ich kann heute den Fisch empfehlen.
Dame: Nein, danke, ich mag keinen Fisch.
Ober: Dann vielleicht Hähnchen mit Pommes frites oder unseren Chefsalat mit Ei und Schinken?
Dame: Salat ist eine gute Idee. Den bringen Sie mir, bitte.""",
        "chinese": """服务员：这里，菜单。我今天推荐鱼。
女士：不，谢谢，我不喜欢鱼。
服务员：那也许鸡肉配薯条，或者我们的主厨沙拉配鸡蛋和火腿？
女士：沙拉是个好主意。请给我来一份。"""
    },
    "1_3": {
        "german": """Student: Bitte eine Eintrittskarte für Studenten.
Frau: Gern, aber das Museum schließt in einer halben Stunde.
Student: Ach, so früh schon!
Frau: Ja, am Mittwochnachmittag schließen wir schon um 15 Uhr, aber an den anderen Tagen ist bis 18 Uhr geöffnet und am Donnerstag schließen wir erst um 22 Uhr.""",
        "chinese": """学生：请给我一张学生票。
女士：好的，但博物馆半小时后就关门了。
学生：啊，这么早！
女士：是的，星期三下午我们3点就关门，但其他日子开到下午6点，星期四我们开到晚上10点。"""
    },
    "1_4": {
        "german": """Tim: Mein Arzt sagt, ich soll mehr Sport machen.
Klaus: Richtig! Komm in meinen Verein, da kannst du Fußball spielen. Und am Wochenende laufe ich immer eine Stunde.
Tim: Nein, für mich ist Rad fahren das Beste – sagt mein Arzt. Laufen ist nichts für mich.""",
        "chinese": """蒂姆：我的医生说我应该多运动。
克劳斯：对！来我的俱乐部，你可以踢足球。周末我总是跑步一小时。
蒂姆：不，对我来说骑自行车最好——我医生说的。跑步不适合我。"""
    },
    "1_5": {
        "german": """Herr: Guten Tag, Frau Bauer. Machen Sie dieses Jahr wieder Urlaub am Meer oder bleiben Sie zu Haus?
Dame: Nein. Wir waren in den letzten Jahren immer am Meer. Dieses Jahr besuchen wir unsere Verwandten in Süddeutschland. Die freuen sich schon sehr. Und wohin fahren Sie?""",
        "chinese": """先生：您好，鲍尔女士。今年您又去海边度假还是待在家里？
女士：不。过去几年我们总是去海边。今年我们要去南德看望亲戚。他们已经很期待了。您去哪里？"""
    },
    "1_6": {
        "german": """Dame: Du, Bruno, wie lange fliegst du von hier nach München?
Bruno: Nicht lange, nur 50 Minuten. Aber ich muss eine halbe Stunde vor dem Abflug im Flughafen sein und bis zum Flughafen brauche ich auch noch 45 Minuten.
Dame: Dann geht es doch nicht so schnell.""",
        "chinese": """女士：布鲁诺，你从这里飞到慕尼黑要多久？
布鲁诺：不长，只要50分钟。但我必须在起飞前半小时到机场，到机场还需要45分钟。
女士：那也不是那么快。"""
    },
    "bsp2": {
        "german": """Frau Katrin Gundlach, angekommen aus Budapest, wird zum Informationsschalter in der Ankunftshalle C gebeten. Frau Gundlach bitte zum Informationsschalter in der Ankunftshalle C.""",
        "chinese": """从布达佩斯抵达的卡特琳·贡德拉赫女士，请到C到达大厅的问讯处。贡德拉赫女士请到C到达大厅的问讯处。"""
    },
    "2_1": {
        "german": """Liebe Fahrgäste, herzlich willkommen an Bord des ICE 987 nach Frankfurt. Eine wichtige Information: Am nächsten Bahnhof müssen wir kurz anhalten. Es gibt Probleme mit dem Bordcomputer. Bitte steigen Sie nicht aus! Wir fahren gleich weiter.""",
        "chinese": """亲爱的乘客们，欢迎乘坐ICE 987次列车前往法兰克福。一个重要信息：我们必须在下一站短暂停留。车载电脑出现问题。请不要下车！我们马上继续前行。"""
    },
    "2_2": {
        "german": """Achtung! Eine Durchsage für die Gäste des Flugs LH 487 nach Rom. Bitte kommen Sie zu Ausgang B 18 im ersten Stock. Der Ausgang A 7 im zweiten Stock ist zurzeit besetzt. Ich wiederhole: Passagiere nach Rom bitte Ausgang B 18.""",
        "chinese": """注意！给LH 487次航班前往罗马的乘客的通知。请到一楼的B 18号出口。二楼的A 7号出口目前被占用。我重复：前往罗马的乘客请到B 18号出口。"""
    },
    "2_3": {
        "german": """Liebe Urlauber! Wir machen jetzt eine Pause von einer Stunde. Sie können einen Kaffee trinken oder das kleine Museum direkt am Meer besuchen. Aber bitte: Um 14 Uhr fahren wir weiter. Bitte, kommen Sie pünktlich zum Bus. Wir möchten nicht warten.""",
        "chinese": """亲爱的游客们！我们现在休息一小时。您可以喝杯咖啡或参观海边的小博物馆。但请注意：我们2点继续前行。请准时回到巴士。我们不想等待。"""
    },
    "2_4": {
        "german": """Liebe Kunden! Das waren unsere Sonderangebote für heute. Und nun noch eine dringende Ansage: Der kleine Mario sucht seinen Vater. Kommen Sie bitte schnell zum Informationsschalter im 1. Stock. Mario wartet dort auf Sie.""",
        "chinese": """亲爱的顾客！这些是我们今天的特价商品。现在还有一个紧急通知：小马里奥在找他的父亲。请快速到一楼的问讯处。马里奥在那里等您。"""
    },
    "3_1": {
        "german": """Autohaus Mayer. Guten Tag, Frau Krause. Wir haben noch eine Frage zu der Reparatur von Ihrem Wagen. Bitte rufen Sie uns nach 13 Uhr wieder zurück. Heute sind wir bis 19 Uhr hier. Nein, Entschuldigung, heute ist ja schon Freitag. Dann heute nur bis 18 Uhr. Danke!""",
        "chinese": """迈尔汽车行。您好，克劳泽女士。关于您汽车的维修我们还有一个问题。请您下午1点后再打电话给我们。我们今天营业到晚上7点。不，抱歉，今天已经是星期五了。那今天只到下午6点。谢谢！"""
    },
    "3_2": {
        "german": """Hallo Irene, hier Nina. Ich möchte heute Abend nicht zu Hause bleiben. Im Metropolis gibt es einen guten Film. Kommst du mit oder musst du lernen? Ruf mich bitte auf dem Handy an.""",
        "chinese": """你好伊蕾娜，我是妮娜。我今晚不想待在家里。大都会影院有一部好电影。你要一起去吗，还是你得学习？请打我手机。"""
    },
    "3_3": {
        "german": """Sarah, ich bin's, Christoph. Du, ist mein Wörterbuch vielleicht bei dir? Auf dem kleinen Schrank mit den CDs? Bitte bring es gleich in den Kurs mit. Und ich gebe dir heute natürlich dein Buch zurück! Bis dann!""",
        "chinese": """莎拉，是我，克里斯托夫。我的词典是不是在你那里？在放CD的小柜子上？请马上带到课上来。我今天当然会把你的书还给你！一会儿见！"""
    },
    "3_4": {
        "german": """Hallo Sabine! Maria hier. War total schön im Café gestern, danke noch mal! Ich gehe gleich mit Julia ins Konzert und danach so um elf in die Disco Aladin. Wir treffen dich dort, okay?""",
        "chinese": """你好萨宾娜！我是玛丽亚。昨天在咖啡馆很开心，再次感谢！我马上和朱莉娅去音乐会，之后11点左右去阿拉丁迪厅。我们在那里见你，好吗？"""
    },
    "3_5": {
        "german": """Guten Tag, Frau Solms, Heinze hier. Morgen habe ich bis 12 Uhr einen Termin. Aber nach der Mittagspause habe ich Zeit. Wollen wir uns um 13 Uhr treffen? Rufen Sie mich bitte bis 18 Uhr zurück.""",
        "chinese": """您好，索尔姆斯女士，我是海因策。明天我12点前有个约会。但午休后我有时间。我们1点见面好吗？请在下午6点前给我回电话。"""
    }
}

# === 练习题02数据 ===
uebung02_data = {
    "bsp1": {
        "german": """Frau: Ach, Verzeihung, wo finde ich Herrn Schneider vom Betriebsrat?
Mann: Schneider. Warten Sie mal. Ich glaube, der ist in Zimmer Nummer 254. Ja, stimmt, Zimmer 254. Das ist im zweiten Stock. Da können Sie den Aufzug hier nehmen.
Frau: Zweiter Stock, Zimmer 254. Okay, vielen Dank.""",
        "chinese": """女士：哦，不好意思，我在哪里可以找到劳资委员会的施奈德先生？
男士：施奈德。等一下。我想他在254号房间。是的，没错，254号房间。在二楼。你可以乘这里的电梯。
女士：二楼，254号房间。好的，非常感谢。"""
    },
    "1_1": {
        "german": """Hanna: Wo wollen wir dieses Jahr unsere Party machen?
Steffi: Ich bin für eine Feier am See. Wir können schwimmen, grillen …
Hanna: Ich bin nicht dafür. Ich finde eine Party im Garten viel besser. Bei Regen können wir schnell ins Haus und im Haus schön weiter feiern.
Steffi: In Ordnung. Da können wir ja auch grillen.""",
        "chinese": """汉娜：我们今年在哪里办派对？
斯特菲：我赞成在湖边办。我们可以游泳、烧烤……
汉娜：我不赞成。我觉得在花园里办派对好得多。下雨的话我们可以快速进屋，在屋里继续愉快地庆祝。
斯特菲：好吧。那我们也可以在那里烧烤。"""
    },
    "1_2": {
        "german": """Martin: Möchtest du heute Abend mit mir in das Konzert von Rosenstolz gehen?
Luisa: Hmm. Gern. Aber wann beginnt das Konzert? Ich bin ja bis um halb acht im Spanisch-Kurs.
Martin: Dann gibt es kein Problem. Die fangen um neun Uhr an. Wollen wir uns um halb neun an der Kasse treffen?
Luisa: Ja, wunderbar. Dann bis heute Abend.""",
        "chinese": """马丁：今晚你想和我一起去Rosenstolz的音乐会吗？
路易莎：嗯。很乐意。但音乐会几点开始？我西班牙语课要上到7点半。
马丁：那没问题。他们9点开始。我们8点半在售票处见面好吗？
路易莎：好的，太好了。那今晚见。"""
    },
    "1_3": {
        "german": """Dame: Entschuldigen Sie bitte. Ich suche ein Taxi, vielleicht dort vorne rechts?
Herr: Nein, da vorne rechts gibt es keine. Gehen Sie hier geradeaus und an der Ecke nach links. Sie müssen dann noch circa 100 Meter gehen. Da stehen schon die Taxis.
Dame: Vielen Dank.""",
        "chinese": """女士：不好意思。我在找出租车，也许在前面右边？
先生：不，前面右边没有。您从这里直走，到拐角处左转。然后您还要走大约100米。出租车就停在那里。
女士：非常感谢。"""
    },
    "1_4": {
        "german": """Herr: Guten Tag. Ich möchte einen Sprachkurs besuchen. Wie lange dauern Ihre Kurse?
Dame: Die Sommerkurse jetzt im Juli und August zwei Wochen. Unsere normalen Kurse dauern aber drei oder vier Wochen.
Herr: Gut. Ich möchte einen Sommerkurs.
Dame: Im Juli oder August?
Herr: Anfang Juli.""",
        "chinese": """先生：您好。我想参加语言课程。你们的课程多长时间？
女士：7月和8月的暑期课程是两周。但我们的常规课程是三到四周。
先生：好的。我想参加暑期课程。
女士：7月还是8月？
先生：7月初。"""
    },
    "1_5": {
        "german": """Mann: Hallo Johanna, wir treffen uns heute Nachmittag im Park. Kommst du auch?
Frau: Ja, gerne. Soll ich was mitbringen?
Mann: Vielleicht ein Kartenspiel.
Frau: Okay. Und etwas zu essen?
Mann: Nein, das machen wir schon. Ich bringe Salat mit und Clara Saft.""",
        "chinese": """男士：你好约翰娜，我们今天下午在公园见面。你也来吗？
女士：好的，很乐意。我要带什么吗？
男士：也许一副纸牌。
女士：好的。还有吃的？
男士：不用，我们已经准备好了。我带沙拉，克拉拉带果汁。"""
    },
    "1_6": {
        "german": """Dame: Guten Tag. Ich möchte bitte Frau Horn sprechen.
Herr: Frau Horn ist leider nicht im Büro. Sie ist von Mittwoch bis Freitag im Urlaub. Aber am Montag kommt sie aus dem Urlaub zurück. Ab acht Uhr ist sie im Büro.
Dame: Aha, na dann rufe ich nächsten Mittwoch wieder an. Da habe ich Zeit.""",
        "chinese": """女士：您好。我想找霍恩女士。
先生：霍恩女士不在办公室。她从星期三到星期五在度假。但星期一她就度假回来了。8点开始她就在办公室。
女士：啊，那我下周三再打电话。那时我有时间。"""
    },
    "bsp2": {
        "german": """Frau Katrin Gundlach, angekommen aus Budapest, wird zum Informationsschalter in der Ankunftshalle C gebeten. Frau Gundlach bitte zum Informationsschalter in der Ankunftshalle C.""",
        "chinese": """从布达佩斯抵达的卡特琳·贡德拉赫女士，请到C到达大厅的问讯处。贡德拉赫女士请到C到达大厅的问讯处。"""
    },
    "2_1": {
        "german": """Liebe Fahrgäste, diese Straßenbahn hat ein Problem mit den Türen. Sie schließen nicht mehr richtig. Leider können wir nicht weiterfahren. Bitte steigen Sie an der nächsten Haltestelle aus. Dort haben Sie Anschluss an den Bus Linie 19.""",
        "chinese": """亲爱的乘客们，这辆有轨电车的门有问题。它们关不紧了。很抱歉我们不能继续行驶。请在下一站下车。您可以在那里换乘19路公交车。"""
    },
    "2_2": {
        "german": """Liebe Kunden, heute haben wir tolle Sonderangebote bei den Badmöbeln. Kommen Sie doch mal in den dritten Stock und sehen Sie sich um. Und am Wochenende feiert unser Möbelhaus Geburtstag. Sie sind herzlich eingeladen!""",
        "chinese": """亲爱的顾客们，今天我们的浴室家具有很棒的特价优惠。请到三楼来看看吧。周末我们的家具店过生日。诚挚邀请您光临！"""
    },
    "2_3": {
        "german": """Achtung. Hier spricht die Polizei. Es gibt ein großes Feuer in der Firma Chemotec. Bitte schließen Sie alle Türen und Fenster und gehen Sie nicht aus dem Haus.""",
        "chinese": """注意。这里是警察。Chemotec公司发生大火。请关闭所有门窗，不要出门。"""
    },
    "2_4": {
        "german": """Willkommen in Berlin Hauptbahnhof. Ihre nächsten Züge: ICE 389 nach Dresden 18.48 Uhr, Gleis 3. Intercity nach Innsbruck 18.52 Uhr fährt heute nicht. Fahrgäste nach Innsbruck benutzen bitte den ICE 346 nach München um 19.20 Uhr und steigen dort um.""",
        "chinese": """欢迎来到柏林中央火车站。您的下一班列车：ICE 389次前往德累斯顿，18:48，3号站台。前往因斯布鲁克的Intercity今天不开。前往因斯布鲁克的乘客请乘坐19:20的ICE 346次列车前往慕尼黑，然后在那里换乘。"""
    },
    "3_1": {
        "german": """Hallo Barbara, hier Greta. Ich will am Montagmorgen das Formular für die Wohnungsanmeldung holen. Möchtest du mitkommen? Du kannst dich ja dann auch gleich beim Amt anmelden. Bitte ruf mich noch heute Abend an. Morgen hat das Amt keine Sprechstunden. Tschüss.""",
        "chinese": """你好芭芭拉，我是格雷塔。我星期一早上要去取住房登记表。你想一起来吗？那你也可以直接在办公室登记。请今晚给我回电话。明天办公室不办公。再见。"""
    },
    "3_2": {
        "german": """Hallo Siggi, hier Heinz. Es geht um heute Abend. Ich sehe gerade, das Restaurant Zwiebel hat heute geschlossen. Können wir uns am Bahnhof treffen und dann zusammen ein anderes Restaurant suchen? Das italienische Restaurant um die Ecke soll gut und nicht teuer sein. Bis heute Abend. Tschüss.""",
        "chinese": """你好西吉，我是海因茨。关于今晚的事。我刚看到洋葱餐厅今天不营业。我们能在火车站见面然后一起找另一家餐厅吗？拐角处的意大利餐厅据说不错而且不贵。今晚见。再见。"""
    },
    "3_3": {
        "german": """Guten Tag, hier Eva Schmitz. Leider bin ich krank und kann morgen nicht kommen. Geht es auch am Mittwoch um 10 Uhr? Da habe ich sowieso einen Termin von 11.00 bis 12.00 Uhr in Ihrem Institut.""",
        "chinese": """您好，我是伊娃·施密茨。很抱歉我生病了，明天不能来。星期三10点可以吗？那时我本来就在您的机构有11点到12点的约会。"""
    },
    "3_4": {
        "german": """Guten Tag, Sie rufen wegen der Wohnungsanzeige an? Die genaue Adresse ist Am Achterkamp 5. Bitte sprechen Sie Ihre Nummer auf den Anrufbeantworter, ich rufe Sie dann zurück und sage Ihnen wann Sie die Wohnung sehen können. Bitte keine E-Mail-Adressen!""",
        "chinese": """您好，您是因为住房广告打电话来的吗？确切地址是Am Achterkamp 5。请把您的号码留在答录机上，我会给您回电话，告诉您什么时候可以看房。请不要留电子邮箱地址！"""
    },
    "3_5": {
        "german": """Guten Morgen, Frau Seiler. Hier Ernst Müller. Mein Auto ist leider kaputt. Ich muss das Fahrrad nehmen und komme also ein bisschen später ins Büro. Die Straßenbahn ist zu weit weg von mir zu Hause. Bitte entschuldigen Sie mich bei Herrn Krause. Danke.""",
        "chinese": """早上好，赛勒女士。我是恩斯特·穆勒。我的车不幸坏了。我得骑自行车，所以会晚一点到办公室。有轨电车离我家太远了。请向克劳泽先生为我道歉。谢谢。"""
    }
}

# 保存为JSON文件
with open('../data/archive_modellsatz.json', 'w', encoding='utf-8') as f:
    json.dump(modellsatz_data, f, ensure_ascii=False, indent=2)

with open('../data/archive_uebung01.json', 'w', encoding='utf-8') as f:
    json.dump(uebung01_data, f, ensure_ascii=False, indent=2)

with open('../data/archive_uebung02.json', 'w', encoding='utf-8') as f:
    json.dump(uebung02_data, f, ensure_ascii=False, indent=2)

print("✓ 3套题目数据已生成:")
print("  - data/archive_modellsatz.json")
print("  - data/archive_uebung01.json")
print("  - data/archive_uebung02.json")
