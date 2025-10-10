POST {{host}}/v1/translit/cyr?indent=true
content-type: application/json
[
    {"id": 1, "value": "долгого ХVIII века"},
    {"id": 2, "value": "Эпоха Просвещения"},
    {"id": 3, "value": "Хороводные и игровые песни Сибири"},
    {"id": 4, "value": "Ежегодник книги СССР"},
    {"id": 5, "value": "Изданiя факультета восточныхъ языковъ императорскаго С.-Петербургскаго университета"},
    {"id": 6, "value": "Публицистика русского зарубежья,1920-1945"},
    {"id": 7, "value": "Современный русский литературный язык"},
    {"id": 8, "value": "Введение в современную российскую историю"},
    {"id": 9, "value": "Вестник истории мировой культуры"},
    {"id": 10, "value": "Журналъ Министерства внутреннихъ дѣлъ"}
]


HTTP 200
[{
    "id": 1,
    "value": "dolgogo XVIII veka"
},
{
    "id": 2,
    "value": "Èpoha Prosveŝeniâ"
},
{
    "id": 3,
    "value": "Horovodnye i igrovye pesni Sibiri"
},
{
    "id": 4,
    "value": "Ežegodnik knigi SSSR"
},
{
    "id": 5,
    "value": "Izdanìâ fakulʹteta vostočnyhʺ âzykovʺ imperatorskago S.-Peterburgskago universiteta"
},
{
    "id": 6,
    "value": "Publicistika russkogo zarubežʹâ,1920-1945"
},
{
    "id": 7,
    "value": "Sovremennyj russkij literaturnyj âzyk"
},
{
    "id": 8,
    "value": "Vvedenie v sovremennuû rossijskuû istoriû"
},
{
    "id": 9,
    "value": "Vestnik istorii mirovoj kulʹtury"
},
{
    "id": 10,
    "value": "Žurnalʺ Ministerstva vnutrennihʺ dělʺ"
}]