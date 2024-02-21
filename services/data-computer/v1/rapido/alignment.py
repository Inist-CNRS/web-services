import ast
import re 

class alignWithText:
    def __init__(self,dfAnnotations):
        self.dfAnnotations = dfAnnotations
        pass

    def isAnnotationInText(self,text,page,dictionnary,idText):
        text = " " + " ".join(text) + " "
        text = text.lower()
        dic = dictionnary
        for index, row in self.dfAnnotations.iterrows():
            annotations = ast.literal_eval(row["Annotation"])
            trueAnnotations = ast.literal_eval(row["trueAnnotation"])
            for i,annot in enumerate(annotations):
                annot = annot.lower()
                annot = " " + annot + " "
                if len(annot) < 5:
                    continue
                if "(" in annot:
                    continue
                starts = [m.span()[0] for m in re.finditer(annot,text)]
                if starts == []:
                    continue
                for start in starts:
                    inside = 0
                    if (annot[1:-1],idText,page) in dic:
                            for dico in dic[(annot[1:-1],idText,page)]:
                                if dico["ID"] == row["ID"] and dico["value"] == trueAnnotations[i]:
                                    inside = 1
                            if inside == 0:
                                dic[(annot[1:-1],idText,page)] += [{"ID":row["ID"], "value":trueAnnotations[i], "start":start}]
                    else:
                        dic[(annot[1:-1],idText,page)] = [{"ID":row["ID"], "value":trueAnnotations[i], "start":start}]
                        start += 1

        return dic

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
                ignoreList = ast.literal_eval(self.dfAnnotations[self.dfAnnotations["ID"] == subDic["ID"]].reset_index(drop=True)["Ignore"][0])
                listIdRef = ast.literal_eval(self.dfAnnotations[self.dfAnnotations["ID"] == subDic["ID"]].reset_index(drop=True)["Annotation"][0])
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
                    listIdRef = ast.literal_eval(self.dfAnnotations[self.dfAnnotations["ID"] == subDic["ID"]].reset_index(drop=True)["Annotation"][0])
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
                listIdRef = ast.literal_eval(self.dfAnnotations[self.dfAnnotations["ID"] == subDic["ID"]].reset_index(drop=True)["Annotation"][0])
                for annot in listIdRef:
                    if annot in apparatitionDic:
                        apparition += apparatitionDic[annot] 
                if (apparition - lenSubDic + 1 ) <= len(listIdRef):
                    subDic["confident"] = "PP("+str(0)+")"
                elif (apparition - lenSubDic + 1 ) < 2*len(listIdRef):
                    subDic["confident"] = "P("+str(apparition - lenSubDic + 1 - len(listIdRef))+")"
                else:
                    subDic["confident"] = "TP("+str(apparition - lenSubDic + 1 - len(listIdRef))+")"