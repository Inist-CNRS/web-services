POST {{host}}/v1/validate?indent=true
content-type: application/json
[
  {
    "value": "J. A. TORRES, A. GARCIA-FUENTES, C. SALAZAR, E. CANO & F. VALLE - Caracterizacion de los pinares de Pil1l1s halepellsis Mill. en el sur de la Peninsula Iberica"
  },
  {
    "value":"Y. B. LINHART. L. CHAOUNI-BENABDALLAH, J.-M. PARRY & J. D. THOMPSON - Selective herbivory of thyme chemotypes by a mollusk and a grasshopper"
  },
  {
    "value": "https://doi.org/10.1016\/b978-0-323-90638-8.00002-3"
  },
  {
    "value": "RETRACTED > Gerris Caucasicus, Primary Prevention of Cardiovascular Disease with a Mediterranean Diet, 10.1056/nejmoa1200303"
  },
  {
    "value": "HALLUCINATED > Zohuri, B. (2019). A Comparison of Molten Salt Reactors to Light Water Reactors: Pros and Cons. In Molten Salt Reactors and Thorium Energy (pp. 81-98). Woodhead Publishing. https://doi.org/10.1016/B978-0-08-102337-2.00006-9"
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
        "doi": "10.3406/ecmed.1999.1878",
        "status": "found"
    }
},
{
    "value": {
        "doi": "10.3406/ecmed.1999.1879",
        "status": "found"
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
        "doi": "",
        "status": "halucinated"
    }
},
{
    "value": {
        "doi": "",
        "status": "not_found"
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