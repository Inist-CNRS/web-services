
# Test csv fields
POST {{host}}/v1/csv
[MultipartFormData]
file: file,test-file.csv; text/csv

HTTP 200
["id","value","test"]
