POST {{host}}/v1/netscity/expand?indent=true
content-type: application/json
[
  { "value": "VANDOEUVRE" },
  { "value": "SACLAY"},
  { "value": "ORSAY"},
  { "value": "TOULOUSE"},
  { "value": "VILLEURBANNE"},
  { "value": "NANCY"}
]



POST {{host}}/v1/expand?indent=true
content-type: application/json
[
  { "value": "Baran, N (reprint author), Univ Zagreb, Dept Phys, Bijenieka Cesta 32, Zagreb 10000, Croatia."},
  { "value": "Harikane, Y (reprint author), Univ Tokyo, Inst Cosm Ray Res, 5-1-5 Kashiwanoha, Kashiwa, Chiba 2778582, Japan.; Harikane, Y (reprint author), Univ Tokyo, Grad Sch Sci, Dept Phys, Bunkyo Ku, 7-3-1 Hongo, Tokyo 1130033, Japan."},
  { "value": "Davidzon, I (reprint author), Aix Marseille Univ, LAM, CNRS, UMR 7326, F-13388 Marseille, France.; Davidzon, I (reprint author), INAF Osservatorio Astron Bologna, Via Ranzani 1, I-40127 Bologna, Italy."},
  { "value": "Zolotukhin, I (reprint author), IRAP, CNRS, 9 Ave Colonel Roche,BP 44346, F-31028 Toulouse 4, France.; Zolotukhin, I (reprint author), Moscow MV Lomonosov State Univ, Sternberg Astron Inst, Univ Skij Pr 13, Moscow 119992, Russia."},
  { "value": "Cooke, J (reprint author), Swinburne Univ Technol, Ctr Astrophys & Supercomp, Hawthorn, Vic 3122, Australia."},
  { "value": "van Uitert, E (reprint author), Argelander Inst Astron, Hugel 71, D-53121 Bonn, Germany."},
  { "value": "Harnois-Deraps, J (reprint author), Univ British Columbia, Dept Phys & Astron, Vancouver, BC V6T 1Z1, Canada."},
  { "value": "Ford, J (reprint author), Univ British Columbia, Dept Phys & Astron, 6224 Agr Rd, Vancouver, BC V6T 1Z1, Canada."},
  { "value": "Laigle, C (reprint author), Univ Paris 06, Sorbonne Univ, 98b Bd Arago, F-75014 Paris, France.; Laigle, C (reprint author), CNRS, UMR 7095, IAP, 98b Bd Arago, F-75014 Paris, France."}
]



POST {{host}}/v1/rnsr/json?indent=true
content-type: application/json
[
  { "id":1, "value": { "year": "2021", "address": "CNRS UMR AMAP MONTPELLIER FRA" } },
  { "id":2, "value": { "year": "2021", "address": "IRD UMR AMAP MONTPELLIER FRA" } },
  { "id":3, "value": { "year": "2021", "address": "University of Bordeaux, IMS, CNRS UMR5218, Talence, F-33405, France" } },
  { "id":4, "value": { "year": "2021", "address": "CENBG, CNRS/IN2P3, Chemin du Solarium B. P. 120, Gradignan, F-33175, France" } },
  { "id":5, "value": { "year": "2021", "address": "Nulle part" } },
  { "id":6, "value": { "address": "Intemporel" } },
  { "id":7, "value": { "address": "Inist-CNRS, UPS76, 2 rue Jean Zay, Vandoeuvre-lès-Nancy" } }
]



POST {{host}}/v1/rnsr/info?indent=true
content-type: application/json
[
  { "id":1, "value": { "year": "2021", "address": "CNRS UMR AMAP MONTPELLIER FRA" } },
  { "id":3, "value": { "year": "2021", "address": "University of Bordeaux, IMS, CNRS UMR5218, Talence, F-33405, France" } },
  { "id":4, "value": { "year": "2021", "address": "CENBG, CNRS/IN2P3, Chemin du Solarium B. P. 120, Gradignan, F-33175, France" } },
  { "id":5, "value": { "year": "2021", "address": "Nulle part" } },
  { "id":6, "value": { "address": "Intemporel" } },
  { "id":7, "value": { "address": "Inist-CNRS, UPS76, 2 rue Jean Zay, Vandoeuvre-lès-Nancy" } }
]



POST {{host}}/v1/rnsr/csv
content-type: text/csv
```
Année,Adresse
2015,CNRS UMR AMAP MONTPELLIER FRA
2015,IRD UMR AMAP MONTPELLIER FRA
2015,"University of Bordeaux, IMS, CNRS UMR5218, Talence, F-33405, France"
2015,"CENBG, CNRS/IN2P3, Chemin du Solarium B. P. 120, Gradignan, F-33175, France"
```



POST {{host}}/v1/rnsr/conditor
content-type: application/json
[{
  "xPublicationDate": ["2012-01-01"],
  "authors": [{
    "affiliations": [{
      "address": "GDR 2989 Université Versailles Saint-Quentin-en-Yvelines, 63009"
    }]
  }]
}]



POST {{host}}/v1/addresses/parse?indent=true
content-type: application/json
[
  {
    "value": "Barboncino 781 Franklin Ave, Crown Heights, Brooklyn, NY 11238"
  }
]