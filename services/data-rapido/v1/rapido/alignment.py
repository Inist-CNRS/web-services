import re 
from multiprocessing import Pool
from flair.data import Sentence

class alignWithText:
    def __init__(self,dfAnnotations,tagger=False):
        self.dfAnnotations = dfAnnotations
        if tagger:
            self.tagger = tagger
        pass

    def parr(self,obj):
        newDic = {}
        text = self.text
        annot = obj[0][0]
        trueAnnotation = obj[0][1]
        if len(annot) < 5:
            return newDic
        if "(" in annot or ")" in annot or "+" in annot or "*" in annot or "?" in annot or "|" in annot:
            return newDic
        starts = [m.span()[0] for m in re.finditer(annot,text)]
        if starts == []:
            return newDic
        newDic[(annot[1:-1],self.idText,self.page)] = [{"ID":id,"value":trueAnnotation,"start":starts} for id in obj[1]]
        return newDic
    
    def isAnnotationInText(self,text,page,dictionnary,idText,lAnnot):
        text = " " + " ".join(text) + " "
        self.text = text.lower()
        self.idText = idText
        self.page = page
        dic = dictionnary
        with Pool(5) as p:
            r = p.map(self.parr,lAnnot)
        for sDic in r:
            if len(sDic) > 0:
                key = [*sDic][0]
                if key in dic:
                    dic[key] += sDic[key]
                else:
                    dic[key] = sDic[key]
        return dic
    
    def isAnnotationInTextApp(self,text,page,dictionnary,idText,lAnnot, loc_remain_app):
        txt = " "+" ".join(text)
        sent= [x+" ." for x in txt.split(".")]
        sentences = [Sentence(sent[i]) for i in range(len(sent))]
        self.tagger.predict(sentences)
        newDic = dictionnary
        loc_remain = loc_remain_app
        for sentence in sentences:
            for entity in sentence.get_spans('ner'):
                added = False
                if entity.tag == "LOC":
                    entity_txt = entity.text
                    
                    #######Fix temporaire erreur model "d' => "d ' "
                    for err in ["d ' ","j ' ","l ' ", "D ' ","J ' ","L ' "]:
                        if err in entity_txt:
                            entity_txt = entity_txt.replace(err, err[0]+"' ")
                    #######
                            
                    for obj in lAnnot:
                        annot = obj[0][0]
                        trueAnnotation = obj[0][1]
                        if len(annot) < 5:
                            continue
                        if "(" in annot or ")" in annot or "+" in annot or "*" in annot or "?" in annot or "|" in annot:
                            continue
                        if annot.lower() == (" "+entity_txt+" ").lower():
                            if (annot[1:-1],idText,page) in newDic:
                                subDic0 = newDic[(annot[1:-1],idText,page)][0]
                                if subDic0["value"]==trueAnnotation and sentence.to_original_text() not in subDic0["text"]:
                                    for subDic in newDic[(annot[1:-1],idText,page)]:
                                        subDic["text"].append(sentence.to_original_text())

                            else:
                                newDic[(annot[1:-1],idText,page)] = [{"ID":id,"value":trueAnnotation,"start":entity.start_pos,"text":[sentence.to_original_text()]} for id in obj[1]]
                            added = True
                            break
                if not added:
                    if (entity_txt,idText) in loc_remain:
                        loc_remain[(entity_txt, idText)].append((page,sentence.to_original_text()))
                    else:
                        loc_remain[(entity_txt, idText)] = [(page,sentence.to_original_text())]

        return newDic, loc_remain

class postProcessing:
    def __init__(self,dfAnnotations,dic):
        self.dfAnnotations = dfAnnotations
        self.dic = dic

    def removeDuplicate(self):
        popList = []
        for key1 in self.dic:
            for key2 in self.dic:
                if key1 != key2 and key1[2] == key2[2]:
                    if self.dic[key1][0]["start"] == self.dic[key2][0]["start"] or (self.dic[key1][0]["value"] in self.dic[key2][0]["value"]) or (self.dic[key2][0]["value"] in self.dic[key1][0]["value"]):
                        if len(self.dic[key1][0]["value"]) > len(self.dic[key2][0]["value"]):
                            popList.append(key2)
                        else:
                            popList.append(key1)
        popList = list(set(popList))
        for pop in popList:
            self.dic.pop(pop)

    def removeIgnore(self):
        allWord = []
        for key in self.dic:
            dicList = self.dic[key]
            for subDic in dicList:
                allWord.append(subDic["value"])

        cpyDic = {}
        rmvKey = []
        for key in self.dic:
            dicList = self.dic[key]
            lSubDic = []
            for subDic in dicList:
                inside = False
                ignoreList = self.dfAnnotations[self.dfAnnotations["ID"] == subDic["ID"]].reset_index(drop=True)["Ignore"][0]
                listIdRef = self.dfAnnotations[self.dfAnnotations["ID"] == subDic["ID"]].reset_index(drop=True)["Annotation"][0]
                if subDic["value"] in ignoreList:
                    for annot in listIdRef:
                        if annot != subDic["value"]:
                            if annot in allWord:
                                inside = True
                                break
                    if inside:
                        lSubDic.append(subDic)
                else:
                    lSubDic.append(subDic)
            if len(lSubDic) > 0:
                cpyDic[key] = lSubDic
            else:
                rmvKey.append(key)
        
        self.dic = cpyDic.copy()
        self.rmv = rmvKey

    def desambiguisation(self):
        finalDic = {}
        
        pageDic = {}
        countIdRef = {}
        for key in self.dic:
            pageDic[key] = self.dic[key]
            for value in self.dic[key]:
                if value["ID"] in countIdRef:
                    countIdRef[value["ID"]] += 1
                else:
                    countIdRef[value["ID"]] = 1
        countIdRefSorted =  dict(sorted(countIdRef.items(), key=lambda item: item[1]))
        for key in pageDic:
            max = 1
            trueIdRef = []
            if len(pageDic[key]) > 1:
                for value in pageDic[key]:
                    if value["ID"] in countIdRefSorted:
                        nb = countIdRefSorted[value["ID"]]
                        if nb > max:
                            max = nb
                            trueIdRef = [value]
                        elif nb == max:
                            trueIdRef.append(value)
                if max > 1:
                    finalDic[key] = trueIdRef
                else:
                    finalDic[key] = pageDic[key]

            else:
                finalDic[key] = pageDic[key]

        self.dic = finalDic.copy()

    def confident(self):
        listID = []
        allLen = 0
        apparatitionDic = {}
        for key in self.dic:
            for subDic in self.dic[key]:
                if subDic["ID"] not in listID:
                    listIdRef = self.dfAnnotations[self.dfAnnotations["ID"] == subDic["ID"]].reset_index(drop=True)["Annotation"][0]
                    allLen += len(listIdRef)
                    for annot in listIdRef:
                        if annot in apparatitionDic:
                            apparatitionDic[annot] += 1
                        else:
                            apparatitionDic[annot] = 1    
                    listID.append(subDic["ID"])
        for key in self.dic:
            for subDic in self.dic[key]:
                lenSubDic = len(subDic)
                apparition = 0
                listIdRef = self.dfAnnotations[self.dfAnnotations["ID"] == subDic["ID"]].reset_index(drop=True)["Annotation"][0]
                for annot in listIdRef:
                    if annot in apparatitionDic:
                        apparition += apparatitionDic[annot] 
                if (apparition - lenSubDic + 1 ) <= len(listIdRef):
                    subDic["confident"] = "PP("+str(0)+")"
                elif (apparition - lenSubDic + 1 ) < 2*len(listIdRef):
                    subDic["confident"] = "P("+str(apparition - lenSubDic + 1 - len(listIdRef))+")"
                else:
                    subDic["confident"] = "TP("+str(apparition - lenSubDic + 1 - len(listIdRef))+")"
