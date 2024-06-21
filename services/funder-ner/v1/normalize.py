#!/usr/bin/env python
# -*- coding: utf-8 -*-

def normalize(words):
    L = []
    for word in words:
        save = word
        finalFile = []
        end = ['.', ',', ";", ":", "»", ")", "’"]
        start = ["«", "(", ".", "‘"]
        middle = ["l'", "d'", "j'", "L'", "D'", "J'", "l’", "d’", "j’", "L’", "D’", "J’"]
        queue = []

        File = word.split()
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
                    queue.insert(0, word[-1])
                    word = word[:-1]

            finalFile.append(word)
            for i in queue:
                finalFile.append(i)
            queue = []

        if finalFile == ["a"]:
            # print("word = ",save)
            pass

        L.append(" ".join(finalFile))
    return L
