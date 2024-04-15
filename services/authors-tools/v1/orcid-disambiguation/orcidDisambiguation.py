#!/usr/bin/python3
from disambiguate import disambiguate
import sys
import json
import plac

@plac.annotations(
    nameDepth = ("Maximum number of people to check" ,"option", "p", int ),
    worksDepth = ("Maximum number of works we take for a person" ,"option", "q", int ),
)

def main(nameDepth = 20, worksDepth = 20):
    for line in sys.stdin:
        data = json.loads(line)
        infos = data['value']
        info = infos[0].copy()   
        db = disambiguate(info,nameDepth=nameDepth, worksDepth=worksDepth )
        result = db.disambiguation()
        if len(result)>0:
            data['value'] = result[0][0]
        else:
            data['value'] = "None"
        sys.stdout.write(json.dumps(data))
        sys.stdout.write('\n')

if __name__ == "__main__":
    plac.call(main)