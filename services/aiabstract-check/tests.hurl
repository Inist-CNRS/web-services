POST {{host}}/v1/AiAbstract-check?indent=true
content-type: application/json
[
  {
    "id": 1,
    "value": "Conditional Lie‐Bäcklund symmetry (CLBS) method is developed to study system of evolution equations. It is shown that reducibility of a system of evolution equations to a system of ordinary differential equations can be fully characterized by the CLBS of the considered system. As an application of the approach, a class of two‐component nonlinear diffusion equations is studied. The governing system and the admitted CLBS can be identified. As a consequence, exact solutions defined on the polynomial, exponential, trigonometric, and mixed invariant subspaces are constructed due to the corresponding symmetry reductions."
  },
  {
    "id": 2,
    "value": "The Conditional Lie-Bäcklund Symmetry (CLBS) method is introduced to analyze systems of evolution equations. It is demonstrated that the ability to reduce a system of evolution equations to a system of ordinary differential equations can be entirely described by the CLBS of the given system. As an application, a specific class of two-component nonlinear diffusion equations is examined. The governing system and its corresponding CLBS are determined. Consequently, exact solutions are derived based on polynomial, exponential, trigonometric, and mixed invariant subspaces through symmetry reductions."
  }
]


HTTP 200
[{
    "id": 1,
    "value": {
        "isAiGenerated": false,
        "score": "1.000"
    }
},
{
    "id": 2,
    "value": {
        "isAiGenerated": true,
        "score": "1.000"
    }
}]