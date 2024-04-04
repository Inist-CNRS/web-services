import json

class exportJson:
    def __init__(self,ignoreWords,nlp):
        self.nlp = nlp
        self.ignoreWords = ignoreWords
        self.listInist = []
        self.listPersee = []

    def posVerif(self,word,sents):
        newSents = []
        for text in sents:
            doc = self.nlp(text)
            for d in doc:
                if d.text == word and d._.melt_tagger == "NC":
                    newSents.append(text)
                    break     
        return newSents

    def toJson(self,dic,rmv,listText,listPage,idText,listTitle):
        siteDic = {"amathonte":"https://www.idref.fr/027523217","délos":"https://www.idref.fr/183212118","thasos":"https://www.idref.fr/182710335","delphes":"https://www.idref.fr/027322505","rome":"https://www.idref.fr/02724301X"}
        delimiter = "@"
        delimiterPersee = "@"
        copyDIc = dic.copy()
        for key in rmv: #~check
            if key[0] not in self.ignoreWords:
                copyDIc[key] = [{"ID":"", "value":"","confident":""}]
        idArticle = []
        word = []
        page = []
        idRef = []
        confident = []
        text = []

        title = " ".join(listTitle[0])

        for key in copyDIc:
            lid = []
            lconf = []
            ltext = []
            lpage = []
            for subDic in copyDIc[key]:
                lid.append(subDic["ID"])
                lconf.append(subDic["confident"])
            for i,pg in enumerate(listPage):
                if pg == key[2]:
                    sents = [sentence + '.' for sentence in listText[i].split('.') if " "+key[0]+" " in sentence]

                    if key[0] in ["ferme","porte","base","fort"]:
                        sents = self.posVerif(key[0],sents)

                    for i,s in enumerate(sents):
                        sents[i] = s.replace(" "+key[0]+" "," **"+key[0]+"** ")
                    ltext += sents
                    lpage += len(sents)*[str(key[2])]
            if key[2] == "Title":
                ltext.append(title)
                lpage.append("Title")
            if len(ltext) > 0:
                idRef.append(lid)
                confident.append(lconf)
                idArticle.append(key[1])
                word.append(key[0])
                text.append(ltext)
                page.append(lpage)

        jsonDic = {}
        jsonDicPersee = {}

        jsonDic["idArticle"] = idText
        jsonDicPersee["idArticle"] = idText

        jsonDic["title"] = title
        jsonDicPersee["title"] = title

        listDic = []
        listDicPersee = []

        dejaUse = []
        sites = []
        for i in range(len(idArticle)):
            if word[i] in dejaUse:
                for subDic in listDic:
                    if subDic["name"] == word[i]:
                        subDic["page"] += delimiter + delimiter.join(page[i])
                        subDic["text"] += delimiter + delimiter.join(text[i])
                for subDicPersee in listDicPersee:
                    if subDicPersee["name"] == word[i]:
                        for k in range(len(text[i])):
                            subDicPersee["occurences"].append({"page" : page[i][k], "text" : text[i][k]}) #a tester 
                
            else:
                if word[i] in siteDic: # https://www.idref.fr/027523217  https://www.idref.fr/183212118  https://www.idref.fr/182710335  https://www.idref.fr/027322505
                    sites.append(word[i])

                subDic = {}
                subDic["name"] = word[i]
                subDic["page"] = delimiter.join(page[i])
                subDic["text"] = delimiter.join(text[i])

                subDicPersee = {}
                subDicPersee["name"] = word[i] 
                subDicPersee["occurences"] = []
                for k in range(len(text[i])):
                    subDicPersee["occurences"].append({"page" : page[i][k], "text" : text[i][k]})

                if word[i] in siteDic:
                    subDic["notice"] = siteDic[word[i]]
                    subDic["score"] = ""
                    subDicPersee["notice"] = siteDic[word[i]]
                    subDicPersee["score"] = ""
                else:
                    subDic["notice"] = delimiter.join(idRef[i])
                    subDic["score"] = delimiter.join(confident[i])
                    subDicPersee["notice"] = delimiterPersee.join(idRef[i])
                    subDicPersee["score"] = delimiterPersee.join(confident[i])                        

                dejaUse.append(word[i])
                listDic.append(subDic)
                listDicPersee.append(subDicPersee)

        jsonDic["sites"] = list(set(sites))
        jsonDic["entite"] = listDic

        jsonDicPersee["sites"] = list(set(sites))
        jsonDicPersee["entite"] = listDicPersee

        self.listInist.append(jsonDic)
        self.listPersee.append(jsonDicPersee)

    def writeJson(self):
        with open('json_data.json', 'w') as outfile:
            json.dump(self.listInist, outfile,ensure_ascii=False, indent=4)

        with open('json_data_persee.json', 'w') as outfile:
            json.dump(self.listPersee, outfile,ensure_ascii=False, indent=4)