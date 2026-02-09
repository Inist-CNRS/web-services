import json
import sys

class exportJson:
    '''
    Class to transform aligned datas on an exploitable form by Persee.
    '''
    def __init__(self,ignoreWords,nlp):
        '''
        Constructs all the necessary attributes.

        Parameters
        ----------
            ignoreWords : list of str
                list of word to ignore when encountered during alignment
            nlp : spacy model
                spacy model used in certain cases for pos tagging
        '''
        self.nlp = nlp
        self.ignoreWords = ignoreWords
        self.listInist = []
        self.listPersee = []

    def posVerif(self,word,sents):
        '''
        Verify if a word is a "Nom commun", in french, or not, based of his context in a sentence.
        Return the sentences where the word is classified as "NC".

        Parameters
        ----------
            word: str
                the word to check if appear as "NC" or not
            sents: list of str
                list of sentence containing the word
        '''
        newSents = []
        for text in sents:
            doc = self.nlp(text)
            for d in doc:
                if d.text == word and d._.melt_tagger == "NC":
                    newSents.append(text)
                    break     
        return newSents

    def toJson(self,dic,rmv,listText,listPage,idText,listTitle,loc_remain_app = False, app = False):
        '''
        Transform the aligned datas of a document into an exploitable form by Persee.
        
        Parameters
        ----------
            dic : dic
                dictionnary where aligned results are
            rmv : dic
                list of removed keys during removeIgnore step in postProcessing
            listText : list of str
                list of tokenized text 
            listPage : list of str
                list of pages
            idText : str
                id of the document
            listTitle : list of str
                list containing the title of the document
            loc_remain_app : False or dic
                dictionnary where entity detected that where not aligned are storer (Defaut is False)
            app : bool
                whether or not it's phase 2 (Machine Learning phase) (Default is False)
        '''
        siteDic = {"amathonte":"https://www.idref.fr/027523217","délos":"https://www.idref.fr/183212118",
                   "thasos":"https://www.idref.fr/182710335","delphes":"https://www.idref.fr/027322505",
                   "rome":"https://www.idref.fr/02724301X", "italie":"https://www.idref.fr/027235408"}
        copyDIc = dic.copy()
        for key in rmv: #~check
            if key[0] not in self.ignoreWords:
                copyDIc[key] = [{"ID":"", "value":"","score":""}]
        idArticle = []
        word = []
        page = []
        idRef = []
        score = []
        text = []
        entity_score = []

        title = " ".join(listTitle[0])
        for key in copyDIc:
            lid = []
            lconf = []
            ltext = []
            lpage = []
            lentity_score = []
            for subDic in copyDIc[key]:
                lid.append(subDic["ID"])
                lconf.append(subDic["score"])
            for i,pg in enumerate(listPage):
                if pg == key[2]:
                    if loc_remain_app != False:
                        sents = copyDIc[key][0]["text"]
                        for i,s in enumerate(sents):
                            sents[i] = s.lower().replace(" "+key[0]+" "," **"+key[0]+"** ")
                        lentity_score += copyDIc[key][0]["entity_score"]
                    else:
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
                if loc_remain_app != False:
                    lentity_score.append(copyDIc[key][0]["entity_score"])
            if len(ltext) > 0:
                idRef.append(lid)
                score.append(lconf)
                idArticle.append(key[1])
                word.append(key[0])
                text.append(ltext)
                page.append(lpage)
                if loc_remain_app != False:
                    entity_score.append(lentity_score)

        jsonDicPersee = {}

        jsonDicPersee["idArticle"] = idText

        jsonDicPersee["title"] = title

        listDicPersee = []

        dejaUse = []
        sites = []
        for i in range(len(idArticle)):
            if word[i] in dejaUse:
                for subDicPersee in listDicPersee:
                    if subDicPersee["name"] == word[i]:
                        for k in range(len(text[i])):
                            if loc_remain_app != False:
                                subDicPersee["occurences"].append({"page" : page[i][k], "entity_score":entity_score[i][k], "text" : text[i][k]}) #a tester 
                            else:
                                subDicPersee["occurences"].append({"page" : page[i][k], "text" : text[i][k]})
            else:
                if word[i] in siteDic: # https://www.idref.fr/027523217  https://www.idref.fr/183212118  https://www.idref.fr/182710335  https://www.idref.fr/027322505
                    sites.append(word[i])

                subDicPersee = {}
                subDicPersee["name"] = word[i] 
                subDicPersee["occurences"] = []
                for k in range(len(text[i])):
                    if loc_remain_app != False:
                        subDicPersee["occurences"].append({"page" : page[i][k], "entity_score":entity_score[i][k], "text" : text[i][k]})
                    else:
                        subDicPersee["occurences"].append({"page" : page[i][k], "text" : text[i][k]})

                if word[i] in siteDic:
                    subDicPersee["notices"] = [{"notice":siteDic[word[i]],"score": '%.2f' % 1}]
                else:
                    subDicPersee["notices"] = [{"notice":idRef[i][k], "score":score[i][k]} for k in range(len(idRef[i]))]                      

                dejaUse.append(word[i])
                listDicPersee.append(subDicPersee)

        if loc_remain_app:
            listRemainPersee = []
            for key in loc_remain_app:
                listRemainPersee.append({"name":key[0], "occurences":[{"page":p,"entity_score":s, "text":t.replace(" "+key[0]+" "," **"+key[0]+"** ")} for p,t,s in loc_remain_app[key]],
                                         "notices":[{"notice":"None(apprentissage)","score":"None"}]})
            listDicPersee += listRemainPersee

        jsonDicPersee["sites"] = list(set(sites))
        jsonDicPersee["entite"] = listDicPersee

        self.listPersee.append(jsonDicPersee)
