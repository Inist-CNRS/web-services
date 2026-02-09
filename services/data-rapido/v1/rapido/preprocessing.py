import re
import pandas as pd
from itertools import chain
from lxml import etree

class extractTei:
    '''
    Class to extract informations from one or more TEI file, applying an xsl stylesheet.
    '''

    def __init__(self,files,tei_path):
        '''
        Constructs all the necessary attributes.

        Parameters
        ----------
            files : list of str
                list of tei file
            tei_path : str
                path of the xsl stylesheet
        '''
        self.files = files
        self.tei_path = tei_path

    def read_file(self,file):
        '''
        Apply an XSL stylesheet to one TEI file, and extract informations such as pages, article ID, texts and title.

        Parameters
        ----------
            file : str
                tei file
        '''
        title = "Titre non récupéré"
        pageNumberList = []
        pageNumberIdList = []
        pageSentenceList = []
        pageSentence = ""
        textPattern = "<p>(.*?)</p>" 
        pagePattern = '<pb xml:id="(.*)" n="(.*)"/>'

        xml_doc = etree.fromstring(file.encode())
        xsl_doc = etree.parse(self.tei_path) #path
        transform = etree.XSLT(xsl_doc)
        result = transform(xml_doc)
        file = str(result).split("\n")
        ind = 0
        lengt = len(file)
        while 1:
            if ind >= lengt:
                break
            line = file[ind]
            ind += 1

            xTitle = re.search('<title level="a" type="main">(.*)</title>',line)
            if xTitle != None:
                title = xTitle.group(1)
            
            xIdArticle = re.search('<idno type="local">(.*)</idno>',line) 
            if xIdArticle != None:
                idArticle = xIdArticle.group(1)

            if line.startswith("  <text>"):
                while 1:
                    line = file[ind]
                    ind += 1
                    if line.startswith("   <note"):
                        if line.endswith("/>\n"):
                            pass
                        else:
                            while 1:
                                line = file[ind]
                                ind += 1
                                if line.startswith("   </note>"):
                                    break
                    elif line.startswith("   <figure"):
                        while 1:
                            line = file[ind]
                            ind += 1
                            if line.startswith("   </figure"):
                                break
                    elif line.startswith('   <div type="abstract"'):
                        while 1:
                            line = file[ind]
                            ind += 1
                            if line.startswith("   </div"):
                                break
                    elif line.startswith("  </text>"):
                        break
                    
                    xText = re.search(textPattern,line)
                    if xText != None:
                        text = xText.group(1)
                        if text.startswith("ZZZZZZZZZZZZZZZZZZZZZZ"):
                            pass
                        else:
                            if line.endswith(" "):
                                pageSentence += text
                            else:
                                pageSentence += text + " "  

                    xPage = re.search(pagePattern,line)
                    if xPage != None:
                        pageSentenceList.append(pageSentence)
                        pageSentence = ""
                        pageNumberList.append(xPage.group(2))
                        pageNumberIdList.append(xPage.group(1))
                                                
                pageSentenceList.append(pageSentence)    
        return title,idArticle,pageSentenceList[1:],pageNumberList, pageNumberIdList

    def extract_files(self):
        '''
        Send TEIs one by one to the read_file method, and store the results on a Dataframe atribute.
        '''
        columns = ["Title","ID","listText","listPage","listPageId"]
        data = []
        for file in self.files:
            title,idArticle,texts,pages, pagesId = self.read_file(file)
            data.append([[title],idArticle,texts,pages,pagesId])
        self.df = pd.DataFrame(data,columns=columns)


class removeGreek:
    '''
    Class to remove sentences with a certain amount of greek from a list of sentences.
    '''
    def __init__(self,ratio):
        '''
        Constructs all the necessary attributes.

        Parameters
        ----------
            ratio : float
                the maximum ratio of greek we want to keep a sentence
        '''
        self.maxRatio = ratio
        greek_codes   = chain(range(0x370, 0x3e2), range(0x3f0, 0x400))
        greek_symbols = (chr(c) for c in greek_codes)
        self.greekLetters = [c for c in greek_symbols if c.isalpha()]

    def getGreekRatio(self,text):
        '''
        Return the ratio of greek letter in a text.

        Parameters
        ----------
            text : str
                text to extract the ratio of greek
        '''
        nbGreekLetter = 0
        nbSpace = 0
        for letter in text:
            if letter in self.greekLetters:
                nbGreekLetter += 1
            elif letter == " ":
                nbSpace += 1
        return (nbGreekLetter)/(len(text)-nbSpace)

    def rmvGreek(self,listText):
        '''
        Takes a list of text as input. Divide them into sentence and keep the ones with a ratio lower than ratio attribute.
        Return them as a list.

        Parameters
        ----------
            listText : list of str
                list of text
        '''
        listSent = []
        for text in listText:
            sentences = text.split(".")
            sent = ""
            for sentence in sentences:
                if sentence not in [""," ","  ","   ","    "]:
                    ratio = self.getGreekRatio(sentence)
                    if ratio < self.maxRatio:
                        sent += sentence + "."
            listSent.append(sent)
        return listSent

def dataToTxt(listTexts):
    '''
    Takes a list of text as input. Tokenize each text.
    Return a list of list containing tokenized text.
    
    Parameters
        ----------
            listText : list of str
                list of text 
    '''
    L = []
    for text in listTexts:
        finalFile = []
        end = ['.',',',";",":","»",")"]
        start = ["«","(","."]
        middle = ["l'","d'","j'","L'","D'","J'","l’","d’","j’","L’","D’","J’"]
        queue = []

        File = text.split()
        for Word in File:
            word = Word
            for execp in start:
                if word.startswith(execp):
                    finalFile.append(word[0])
                    word = word[1:]
            for execp in middle:
                if word.startswith(execp):
                    finalFile.append(word[:2])
                    word = word[2:]
            for execp in end:
                if word.endswith(execp):
                    queue.insert(0,word[-1])
                    word = word[:-1]
            
            finalFile.append(word)
            for i in queue:
                finalFile.append(i) 
            queue = []
        L.append(finalFile)
    return L
