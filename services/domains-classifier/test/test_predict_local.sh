#!/bin/bash
#ex : ./test/test_predict_local.sh corpus/data3.json

sed -e '1d; $d' $1 | sed  's/\,$/ /g' | $python3 public/classify.py -p 3
