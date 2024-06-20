# ws-domains-classifier@0.0.0

Classification en domaines scientifiques

Utilise une succession arborescente de modèles de type Fasttext pour prédire un code de classement Pascal/Francis

Service de **classification de document en domaines scientifiques** qui utilise
une succession arborescente de modèles de type Fasttext (*embeddings* et
classification) pour prédire un code de classement.  
Les domaines scientifiques (codes) proposés proviennent du plan de classement
Pascal/Francis (<https://pascal-francis.inist.fr/aide-discipline/>).  Les modèles
ont été entraînés sur 10 années de notices issues de la base **Pascal et
Francis** (https://pascal-francis.inist.fr/cms/?lang=fr), soit 2.961.162
notices.

Prend en entrée un fichier json au format `id/value`

```json
[
{"idt":"11-0278198","value":"reduction fear child comparison positive information imagery control condition study
 effect ... "},
{"idt":"07-0413881","value":"avoidance hemodilution selective cerebral perfusion neurobehavioral outcome ... "}
]
```

Produit en sortie un fichier json avec n codes

```json
{"idt": "05-0473464", "value": [{"code": "001", "confidence": 1.0000014305114746, "rang": 1}, {"code": "001D"
, "confidence": 1.0000100135803223, "rang": 2}, {"code": "001D10", "confidence": 0.9192302227020264, "rang":
3}]}
{"idt": "05-0382444", "value": [{"code": "001", "confidence": 0.9999098777770996, "rang": 1}, {"code": "001B"
, "confidence": 1.000008225440979, "rang": 2}, {"code": "001B30", "confidence": 0.9999992847442627, "rang": 3
}]}
```

## Utilisation

### Sollicitation du WebService

<https://domains-classifier.services.inist.fr/v1/en/classify?indent=true&deep=2>

avec `deep = n`, n est profondeur de la prédiction, fournit n codes, de [ 1 - 3 ] (3 par défaut)

### Exemple d'appel au classifieur, avec profondeur=2

```bash
cat <<EOF | curl --proxy "" -X POST --data-binary @-  "https://domains-classifier-2.services.inist.fr/v1/en/classify?indent=true&deep=3"
[{
 "idt":"08-0245642","value":"Random walk of passive tracers among randomly moving obstacles. Background: This study is mainly motivated by the need of understanding how the diffusion behaviour of a biomolecule (or even of a larger object) is affected by other moving macromolecules, organelles, and so on, inside a living cell, whence the possibility of understanding whether or not a randomly walking biomolecule is also subject to a long-range force field driving it to its target. Method: By means of the Continuous Time Random Walk (CTRW) technique the topic of random walk in random environment is here considered in the case of a passively diffusing particle in a crowded environment made of randomly moving and interacting obstacles. Results: The relevant physical quantity which is worked out is the diffusion cofficient of the passive tracer which is computed as a function of the average inter-obstacles distance. Coclusions: The results reported here suggest that if a biomolecule, let us call it a test molecule, moves towards its target in the presence of other independently interacting molecules, its motion can be considerably slowed down. Hence, if such a slowing down could compromise the efficiency of the task to be performed by the test molecule, some accelerating factor would be required. Intermolecular electrodynamic forces are good candidates as accelerating factors because they can act at a long distance in a medium like the cytosol despite its ionic strength."
 },{
 "idt":"08-040289","value":"Planck 2015 results. XIII. Cosmological parameters.We present results based on full-mission Planck observations of temperature and polarization anisotropies of the CMB. These data are consistent with the six-parameter inflationary LCDM cosmology. From the Planck temperature and lensing data, for this cosmology we find a Hubble constant, H0= (67.8 +/- 0.9) km/s/Mpc, a matter density parameter Omega_m = 0.308 +/- 0.012 and a scalar spectral index with n_s = 0.968 +/- 0.006. (We quote 68% errors on measured parameters and 95% limits on other parameters.) Combined with Planck temperature and lensing data, Planck LFI polarization measurements lead to a reionization optical depth of tau = 0.066 +/- 0.016. Combining Planck with other astrophysical data we find N_ eff = 3.15 +/- 0.23 for the effective number of relativistic degrees of freedom and the sum of neutrino masses is constrained to < 0.23 eV. Spatial curvature is found to be |Omega_K| < 0.005. For LCDM we find a limit on the tensor-to-scalar ratio of r <0.11 consistent with the B-mode constraints from an analysis of BICEP2, Keck Array, and Planck (BKP) data. Adding the BKP data leads to a tighter constraint of r < 0.09. We find no evidence for isocurvature perturbations or cosmic defects. The equation of state of dark energy is constrained to w = -1.006 +/- 0.045. Standard big bang nucleosynthesis predictions for the Planck LCDM cosmology are in excellent agreement with observations. We investigate annihilating dark matter and deviations from standard recombination, finding no evidence for new physics. The Planck results for base LCDM are in agreement with BAO data and with the JLA SNe sample. However the amplitude of the fluctuations is found to be higher than inferred from rich cluster counts and weak gravitational lensing. Apart from these tensions, the base LCDM cosmology provides an excellent description of the Planck CMB observations and many other astrophysical data sets."
},{
 "idt":"06-0488289","value":"Weyl gravity and Cartan geometry. We point out that the Cartan geometry known as the second-order conformalstructure provides a natural differential geometric framework underlying gaugetheories of conformal gravity. We are concerned by two theories: the first onewill be the associated Yang-Mills-like Lagrangian, while the second, inspiredby J.T. Wheeler in Phys. Rev. D90 (2014), will be a slightly more general one which will relax theconformal Cartan geometry. The corresponding gauge symmetry is treated withinthe BRST language. We show that the Weyl gauge potential is a spurious degreeof freedom, analogous to a Stueckelberg field, that can be eliminated throughthe dressing field method. We derive sets of field equations for both thestudied Lagrangians. For the second one, they constrain the gauge field to bethe normal conformal Cartan connection. Finally, we provide in a Lagrangianframework a justification of the identification, in dimension $4$, of the Bachtensor with the Yang-Mills current of the normal conformal Cartan connection,as proved in Class"
}]
EOF
```
