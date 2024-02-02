POST {{host}}/v1/validate?indent=true
content-type: application/json
[
  {
    "value": "Zohuri, B. (2019). A Comparison of Molten Salt Reactors to Light Water Reactors: Pros and Cons. In Molten Salt Reactors and Thorium Energy (pp. 81-98). Woodhead Publishing. https://doi.org/10.1016/B978-0-08-102337-2.00006-9"
  },
  {
    "value": "Please see https://doi.org/10.1016\/b978-0-323-90638-8.00002-3"
  },
  {
    "value": "Gerris Caucasicus, Primary Prevention of Cardiovascular Disease with a Mediterranean Diet, 10.1056/nejmoa1200303"
  },
  {
    "value": ["bad","input","type"]
  },
  {
    "value": "nothing here"
  }
]

HTTP 200
[{
    "value": {
        "doi": "",
        "status": "not_found"
    }
},
{
    "value": {
        "doi": "10.1016/b978-0-323-90638-8.00002-3",
        "status": "found"
    }
},
{
    "value": {
        "doi": "10.1056/nejmoa1200303",
        "status": "retracted"
    }
},
{
    "value": {
        "doi": "",
        "status": "error_data"
    }
},
{
    "value": {
        "doi": "",
        "status": "not_found"
    }
}]