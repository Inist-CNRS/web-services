POST {{host}}/v1/tagger?indent=true
content-type: application/json
[
    {"id": "1", "value": "V643 Orionis is a binary star system located in the Orion constellation, offering valuable insightsinto stellar evolution."},
    {"id": "2", "value": "If these planets had isothermal atmospheres, the light curves obtained during those occultations would have been smooth. Hence the presence of spikes in the light curves demonstrates immediately that the atmospheres of Jupiter and Neptune are not isothermal over distances much smaller than a scale height"},
    {"id": "3", "value": "This did not occur accidentally since Carinae is one of the most luminous stars of the Galaxy. The environment of this extended object can be observed in very high angular (spatial) and spectral resolution simultaneously using the Hubble Space Telescope (HST) with its Space Telescope Imaging Spectrograph (STIS) on board (Kimble et al., 1988)."},
    {"id": "4", "value": "The purportedly fastest star in the Gaia catalogue, Gaia DR2 5932173855446728064 (Bromley et al. 2018; Marchetti et al. 2019), has been found to be spurious (Boubert et al. 2019)."}
]


HTTP 200
[{
    "id": "1",
    "value": {
        "Etoiles binaires (et pulsars)": [
            "V643 Orionis"
        ],
        "Constellations": [
            "Orion"
        ]
    }
},
{
    "id": "2",
    "value": {
        "Planete": [
            "Jupiter",
            "Neptune"
        ]
    }
},
{
    "id": "3",
    "value": {
        "Objets artificiels": [
            "Hubble Space Telescope",
            "HST"
        ],
        "Nebuleuse et region apparentes": [
            "Carinae"
        ]
    }
},
{
    "id": "4",
    "value": {
        "Objets artificiels": [
            "Gaia"
        ],
        "Etoiles": [
            "Gaia DR2 5932173855446728064"
        ]
    }
}]