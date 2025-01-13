import re 
from multiprocessing import Pool
from flair.data import Sentence
import sys

class alignWithText:
    '''
    Class to align text with idRef notices for phase 1 and phase 2 of RAPIDO project.
    '''
    def __init__(self,dfAnnotations,tagger=False):
        '''
        Constructs all the necessary attributes.

        Parameters
        ----------
            dfAnnotations : dataframe
                dataframe containing all informations about the notices to align with
            tagger : false or flair tagger
                flair tagger (Default is False)
        '''
        self.dfAnnotations = dfAnnotations
        if tagger:
            self.tagger = tagger
        pass

    def parr(self,obj):
        '''
        Function to align notices with a text for phase 1
        Return a dictionnary where results are stored.

        Parameters
        ----------
            obj: list of list
                list of list from lAnnot in isAnnotationInText function
        '''
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
        '''
        Function to parallelize phase 1 algorithme. Parallelization is applied to the notices.
        Return a dictionnary where results are stored.

        Parameters
        ----------
            obj: list of list
                list of list from lAnnot in isAnnotationInText function
            text : list of str
                list of tokenized sentences
            page : str
                page of the sentences
            dictionnary : dic
                dictionnary to store and return the result
            idText : str
                id of the text where sentence is from
            lAnnot : list
                list of the notices made up to speed up computation 
        '''
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
        '''
        Function to align notices with a text for phase 2 using a ML model trained on custom datas.
        Return a dictionnary where results are stored.

        Parameters
        ----------
            text : list of str
                list of tokenized sentences
            page : str
                page of the sentences
            dictionnary : dic
                dictionnary to store and return the result
            idText : str
                id of the text where sentence is from
            lAnnot : list
                list of the notices made up to speed up computation 
            loc_remain_app : dic
                dictionnary to store remaining entity detected that where not aligned
        '''
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
                    entity_score = '%.3f' % entity.score
                    
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
                                        subDic["entity_score"].append(entity_score)

                            else:
                                newDic[(annot[1:-1],idText,page)] = [{"ID":id,"value":trueAnnotation,"start":entity.start_pos,
                                                                      "text":[sentence.to_original_text()], "entity_score":[entity_score]} for id in obj[1]]
                            added = True
                            break
                if not added:
                    if (entity_txt,idText) in loc_remain:
                        loc_remain[(entity_txt, idText)].append((page,sentence.to_original_text(), entity_score))
                    else:
                        loc_remain[(entity_txt, idText)] = [(page, sentence.to_original_text(), entity_score)]

        return newDic, loc_remain

class postProcessing:
    '''
    Class to clean up and add more informations on the datas after the alignment step.
    '''
    def __init__(self,dfAnnotations,dic):
        '''
        Constructs all the necessary attributes.

        Parameters
        ----------
            dfAnnotations : dataframe 
                dataframe containing all informations about the notices to align with
            dic : dic
                dic containing aligned datas
        '''
        self.dfAnnotations = dfAnnotations
        self.dic = dic

    def removeDuplicate(self):
        '''
        Remove entity detected and aligned if they are also part of a bigger entity.
        For example "Temple of Athena" would be removed if "Temple of Athena in Sparte" was also detected and aligned. 
        '''
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
        '''
        Remove entity detected and aligned if they are in the ignored words list.
        '''
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
        '''
        Desambiguate and make a choice if an entity got multiples notices align with her.
        Based mainly on whether or not other words from the notices appear in the text.
        '''
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

    def score(self,dicAnnot):
        '''
        Give a score to an alignment.
        Based mainly on whether or not other words in the notice appear, and the apparition frequency of the aligned word.

        Parameters
        ----------
            dicAnnot : dic
                dic of the notices made up to speed up score computation
        '''
        countIdRef = {}
        already_in = {}
        for key in self.dic:
            for value in self.dic[key]:
                if value["ID"] in countIdRef:
                    if key[0] not in already_in[value["ID"]]:
                        countIdRef[value["ID"]] += 1
                        already_in[value["ID"]].append(key[0])
                else:
                    countIdRef[value["ID"]] = 1
                    already_in[value["ID"]] = [key[0]]

        for key in self.dic:
            for subDic in self.dic[key]:
                listIdRef = self.dfAnnotations[self.dfAnnotations["ID"] == subDic["ID"]].reset_index(drop=True)["Annotation"][0]
                score = 0.7*((countIdRef[subDic["ID"]]/len(listIdRef))**(0.25))+0.3*((1/len(dicAnnot[key[0]]))**(0.5))
                subDic["score"] = '%.3f' % score
