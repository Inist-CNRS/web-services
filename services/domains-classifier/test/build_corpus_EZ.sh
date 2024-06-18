#!/bin/bash
#./test/build_corpus_EZ.sh corpus/data4.json
input="/applis/tools/home/models/FTClassifier/all_database/all_database.pp.csv"
nb=500
f=$1
echo "[" >| $f && shuf -n $nb $input | mawk -F "\t" '{gsub(" ","",$2);print("{\"idt\":\""$2"\",\"value\":\""$3." \
"$4"\"},") }'  >> $f && echo "]">> $f

