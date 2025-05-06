POST {{host}}/v1/csv?id=title&value=rating
content-type: text/csv
```
title,year,director/firstName,director/LastName,actors,rating,imdb
Rocky,1976,John G.,Avildsen,Sylvester Stallone/Talia Shire/Carl Weathers/Burt Young,"8,1",http://www.imdb.com/title/tt0075148/
Rocky 2,1979,Sylvester,Stallone,Sylvester Stallone/Talia Shire/Carl Weathers/Burt Young/Burgess Meredith/Tony Burton/Frank Stallone/Stu Nahan,"7,2",http://www.imdb.com/title/tt0079817/
Rocky 3,1982,Sylvester,Stallone,Sylvester Stallone/Talia Shire/Carl Weathers/Burt Young/Burgess Meredith/Mister T./Hulk Hogan/Tony Burton,"6,7",http://www.imdb.com/title/tt0084602/
Last Action Hero,1993,John,McTierman,Arnold Schwarzenegger/Austin O'Brien/Charles Dance/Bridget Wilson-Sampras,"6,2",http://www.imdb.com/title/tt0107362/
```

HTTP 200
Content-type: application/gzip

##########################################

POST {{host}}/v1/fields/csv?indent=true
content-type: text/csv
```
title,year,director/firstName,director/LastName,actors,rating,imdb
Rocky,1976,John G.,Avildsen,Sylvester Stallone/Talia Shire/Carl Weathers/Burt Young,"8,1",http://www.imdb.com/title/tt0075148/
Rocky 2,1979,Sylvester,Stallone,Sylvester Stallone/Talia Shire/Carl Weathers/Burt Young/Burgess Meredith/Tony Burton/Frank Stallone/Stu Nahan,"7,2",http://www.imdb.com/title/tt0079817/
Rocky 3,1982,Sylvester,Stallone,Sylvester Stallone/Talia Shire/Carl Weathers/Burt Young/Burgess Meredith/Mister T./Hulk Hogan/Tony Burton,"6,7",http://www.imdb.com/title/tt0084602/
Last Action Hero,1993,John,McTierman,Arnold Schwarzenegger/Austin O'Brien/Charles Dance/Bridget Wilson-Sampras,"6,2",http://www.imdb.com/title/tt0107362/
```

HTTP 200
[{
    "value": "title"
},
{
    "value": "year"
},
{
    "value": "director/firstName"
},
{
    "value": "director/LastName"
},
{
    "value": "actors"
},
{
    "value": "rating"
},
{
    "value": "imdb"
}]

##########################################

POST {{host}}/v1/tar-tei2json
content-type: application/x-tar
file,example-tei.tar.gz;

HTTP 200
Content-type: application/gzip

##########################################

POST {{host}}/v1/tar-tei2xml
content-type: application/x-tar
file,example-tei.tar.gz;

HTTP 200
Content-type: application/gzip

##########################################

POST {{host}}/v1/no-convert
content-type: application/gzip
file,example-tei.tar.gz;

HTTP 200
Content-type: application/gzip
[Asserts]
sha256 == hex,8725be350c86b8e7ded291b42b01fdb94255dfa4cfc152c6743df8e334e59782;

##########################################

POST {{host}}/v1/tar-txt2json
content-type: application/gzip
file,texts.tar.gz;

HTTP 200
Content-type: application/gzip
[Asserts]
bytes count >= 480
bytes count <= 495
bytes startsWith hex,1f8b0800;
bytes endsWith hex,00140000;
