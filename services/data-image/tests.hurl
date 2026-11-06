## Usage
# npm run test:local data-image
# npm run test:remote data-image

##################################################
## treatment
##################################################
POST {{host}}/v1/img-detect
content-type: application/x-tar
# x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,img-test.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists


POST {{host}}/v1/retrieve-all
content-type: application/json
[Options]
delay:20000
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
[Asserts]
bytes count > 1500000



POST {{host}}/v1/pdf-detect
content-type: application/x-tar
# x-hook: https://webhook.site/69300b22-a251-4c16-9905-f7ba218ae7e9
file,pdf-test.tar.gz;

HTTP 200
# Capture the computing token
[Captures]
computing_token: jsonpath "$[0].value"
[Asserts]
variable "computing_token" exists


POST {{host}}/v1/retrieve-all
content-type: application/json
[Options]
delay:30000
```
[
	{
		"value":"{{computing_token}}"
	}
]
```

HTTP 200
[Asserts]
bytes count > 10000000