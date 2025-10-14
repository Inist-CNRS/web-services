import requests
import pandas as pd
from io import StringIO
from difflib import SequenceMatcher
import urllib.parse
import time
import sys
from requests.auth import HTTPBasicAuth
import os

def getPoints(liste):
    return liste[2]


class disambiguate:
    def __init__(self, infoDic, nameDepth = 20, worksDepth = 20):
        self.timeBetweenrequest = 0.01
        self.version = "v3.0"
        self.nameDepth = nameDepth
        self.worksDepth = worksDepth
        self.infoDic = {}
        self.extractInfoDic(infoDic)
        self.client_id = os.getenv('ORCID_CLIENT_ID')
        self.client_secret = os.getenv('ORCID_SECRET')
        self.access_token = self.getToken()
    
    def getToken(self):
        TOKEN_URL = "https://orcid.org/oauth/token"
        data = {"grant_type": "client_credentials", "scope": "/read-public"}
        response = requests.post( TOKEN_URL, auth=HTTPBasicAuth(self.client_id, self.client_secret), data=data)
        if response.status_code == 200:
            token_data = response.json()
            access_token = token_data["access_token"]
            print("Successfully access token!", file=sys.stderr)
            return access_token
        else:
            print("Failed to get token:", response.status_code, response.text, file=sys.stderr)
            return None
        


    def getDfFromName(self,name):
        url = "https://pub.orcid.org/v3.0/csv-search/?q="+urllib.parse.quote("(given-and-family-names:"+name+")")
        response = requests.get(url,headers={'Authorization': f'Bearer {self.access_token}', 'Accept':'text/csv'})
        df = pd.read_csv(StringIO(str(response.content,'utf-8')))
        return df

    def getWorksFromOrcid(self,orcid):
        url = "https://pub.orcid.org/"+self.version+"/"+orcid+"/works"
        response = requests.get(url,headers={'Authorization': f'Bearer {self.access_token}', 'Accept':'application/orcid+json'})
        works = response.json().get("group")
        return works

    def getCoAuthorsFromPutcode(self,putcode,orcid):
        url = "https://pub.orcid.org/"+self.version+"/"+orcid+"/work/"+str(putcode)
        response = requests.get(url,headers={'Authorization': f'Bearer {self.access_token}', 'Accept':'application/orcid+json'})
        contributors = response.json().get("contributors")
        try:
            coAuthors = [contributor["credit-name"]['value'] for contributor in contributors.get("contributor")]
        except:
            coAuthors = ""
        return coAuthors

    def extractInfoDic(self,dic):
        self.infoDic["firstName"] = dic["firstName"]
        self.infoDic["lastName"] = dic["lastName"]
        if "email" in dic:
            self.infoDic["email"] = dic["email"]
        if "affiliations" in dic:
            self.infoDic["affiliations"] = dic["affiliations"]
        if "titles" in dic:
            self.infoDic["titles"] = dic["titles"]
        if "coAuthors" in dic:
            self.infoDic["coAuthors"] = dic["coAuthors"]

    def extractDfInfos(self,df):
        infos = []
        for i in range(self.nameDepth):
            dic = {}

            dic["firstName"] = str(df["given-names"][i])
            dic["lastName"] = str(df["family-name"][i])
            dic["email"] = str(df["email"][i])

            try:
                dic["affiliations"] = df["current-institution-affiliation-name"][i].split(",")
            except:
                dic["affiliations"] = []

            try:
                dic["affiliations"] += df["past-institution-affiliation-name"][i].split(",")
            except:
                pass

            dic["orcid"] = df["orcid"][i]
            infos.append(dic)
        return infos

    def extractInfoFromWorks(self,works):
        dic = { "putcode" : [],
                "title" : [],
                "publicationDate" : [],
                "journal" : [],
                "externalIds" : []}

        for i,work in enumerate(works):
            if i > self.worksDepth:
                break
            workSummary = work.get('work-summary')
            for ws in workSummary :
                dic["putcode"].append(ws.get("put-code"))
                dic["title"].append(ws.get("title").get('title').get("value"))
                try:
                    dic["publicationDate"].append(ws.get("publication-date").get("year").get('value'))
                except:
                    dic["publicationDate"].append("Err")
                try:
                    dic["journal"].append(ws.get("journal-title"))
                except:
                    dic["journal"].append("Err")
                
                try:
                    dic["externalIds"].append([external_id['external-id-value'] for external_id in ws.get("external-ids")["external-id"]])
                except:
                    dic["externalIds"].append(["Err"])
        return dic

    def splitFirstName(self,name):
        choice = []
        nameSplit = name.lower().split(" ")
        try:
            while True:
                nameSplit.remove("")
        except ValueError:
            pass
        if len(nameSplit) > 2:
            nameSplit = [" ".join(nameSplit[:-1]),nameSplit[-1]]
        choice.append(name.lower())
        choice.append(nameSplit[1]+" "+nameSplit[0])
        fnSplit = nameSplit[0].split("-") #composed firstname with - in it
        if len(fnSplit) > 1: #composed firstname with - in it
            choice.append(nameSplit[1]+", "+fnSplit[0][0]+".-"+fnSplit[1][0]+".")
            choice.append(nameSplit[1]+", "+fnSplit[0][0]+"."+fnSplit[1][0]+".")
        else: #composed first name with space in it
            fnSplit = nameSplit[0].split(" ")    
            if len(fnSplit) > 1:
                choice.append(nameSplit[1]+", "+fnSplit[0]+".-"+fnSplit[1][0]+".") #lastname, Jaa.-P.
                choice.append(nameSplit[1]+", "+fnSplit[0]+" "+fnSplit[1][0]+".")#lastname, Jaa P.
                choice.append(nameSplit[1]+", "+fnSplit[0][0]+"."+fnSplit[1][0]+".") #lastname, Jaa.P. 
                choice.append(fnSplit[0]+" "+fnSplit[1][0]+". "+nameSplit[1])#Jaa P. lastname  
                choice.append(fnSplit[0][0]+"."+fnSplit[1][0]+". "+nameSplit[1])#J.P. lastname    
                choice.append(fnSplit[0][0]+fnSplit[1][0]+". "+nameSplit[1])#JP. lastname    
            else:       
                choice.append(nameSplit[1]+", "+nameSplit[0][0]+".")

        if len(fnSplit) == 1: #composed first name with space in it
            fnSplit = nameSplit[0].split("-")
        return choice
        
    def checkEmail(self,email):
        for em in self.infoDic["email"]:
            if em == email:
                return True,em
        return False,0

    def disambiguation(self):
        df = self.getDfFromName(self.infoDic["firstName"]+"+AND+"+self.infoDic["lastName"])
        time.sleep(self.timeBetweenrequest)
        personsInfos = self.extractDfInfos(df)
        for personInfos in personsInfos:
            orcid = personInfos["orcid"]
            matchArg = []
            points = 0

            if "email" in self.infoDic: #check email
                end,em = self.checkEmail(personInfos["email"])
                if end:
                    return [[orcid,["Email "+em],100]]

            works = self.getWorksFromOrcid(orcid)
            time.sleep(self.timeBetweenrequest)
            worksInfo = self.extractInfoFromWorks(works)

            if "titles" in self.infoDic: #check title
                for title in self.infoDic["titles"]:
                    for tit in [title.lower() for title in worksInfo["title"]]:
                        ratio = SequenceMatcher(None, title.lower(), tit).ratio() #check similarity between title
                        if ratio > 0.7:
                            return [[orcid,["title "+tit],100]]            

            if "coAuthors" in self.infoDic: #check coAuthors
                authorsPutcode = []
                for putcode in worksInfo["putcode"]:
                    authorsPutcode += self.getCoAuthorsFromPutcode(putcode,orcid)
                    time.sleep(self.timeBetweenrequest)
                authors = list(set(authorsPutcode))
                for author in self.infoDic["coAuthors"]:
                    choices = self.splitFirstName(author)
                    for choice in choices:
                        if choice in [auth.lower() for auth in authors]:
                            return [[orcid,["Co-authors "+choice],100]]

            if "affiliations" in self.infoDic: #check affiliations
                for affiliation in self.infoDic["affiliations"]:
                    if affiliation.lower() in [aff.lower() for aff in personInfos["affiliations"]]:
                        matchArg.append("Affiliation "+affiliation)
                        points += 10

            #check first and last name
            if self.infoDic["lastName"].lower() == personInfos["lastName"].lower():
                if self.infoDic["firstName"].lower() == personInfos["firstName"].lower():
                    points += 10
                    matchArg.append("Match First+LastName ")
                elif self.infoDic["firstName"].lower()[0] == personInfos["firstName"].lower()[0]:
                    points += 7
                    matchArg.append("Match FirstName First Letter+LastName ")               
                else:
                    points += 5
                    matchArg.append("Match LastName ")                    

            personInfos["points"] = points
            personInfos["matchArg"] = matchArg    

        #check first and last name
        finalReturn = []
        for personInfos in personsInfos:
            if personInfos["points"] != 0:
                finalReturn.append([personInfos["orcid"],personInfos["matchArg"],personInfos["points"]])

        finalReturn.sort(key=getPoints,reverse=True)
        return finalReturn
