POST {{host}}/v1/classif?indent=true
content-type: application/json
[
	{"id": "W2154889144", "value": "high-speed tracking with kernelized correlation filters the core component of most modern trackers is a discriminative classifier , tasked with distinguishing between the target and the surrounding environment . to cope with natural image changes , this classifier is typically trained with translated and scaled sample patches . such sets of samples are riddled with redundancies-any overlapping pixels are constrained to be the same . based on this simple observation , we propose an analytic model for datasets of thousands of translated patches . by showing that the resulting data matrix is circulant , we can diagonalize it with the discrete fourier transform , reducing both storage and computation by several orders of magnitude . interestingly , for linear regression our formulation is equivalent to a correlation filter , used by some of the fastest competitive trackers . for kernel regression , however , we derive a new kernelized correlation filter ( kcf ) , that unlike other kernel algorithms has the exact same complexity as its linear counterpart . building on it , we also propose a fast multi-channel extension of linear correlation filters , via a linear kernel , which we call dual correlation filter ( dcf ) . both kcf and dcf outperform top-ranking trackers such as struck or tld on a 50 videos benchmark , despite running at hundreds of frames-per-second , and being implemented in a few lines of code ( algorithm 1 ) . to encourage further developments , our tracking framework was made open-source" },
	{"id": "W1596397105", "value": "an international randomized trial comparing four thrombolytic strategies for acute myocardial infarction the findings of this large-scale trial indicate that accelerated t-pa given with intravenous heparin provides a survival benefit over previous standard thrombolytic regimens"},
	{"id": "W2089949851", "value": "reducing behavior problems through functional communication training it is generally agreed that serious misbehavior in children should be replaced with socially appropriate behaviors , but few guidelines exist with respect to choosing replacement behaviors . we address this issue in two experiments . in experiment 1 , we developed an assessment method for identifying situations in which behavior problems , including aggression , tantrums , and self-injury , were most likely to occur . results demonstrated that both low level of adult attention and high level of task difficulty were discriminative for misbehavior . in experiment 2 , the assessment data were used to select replacements for misbehavior . specifically , children were taught to solicit attention or assistance or both verbally from adults . this treatment , which involved the differential reinforcement of functional communication , produced replicable suppression of behavior problems across four developmentally disabled children . the results were consistent with an hypothesis stating that some child behavior problems may be viewed as a nonverbal means of communication . according to this hypothesis , behavior problems and verbal communicative acts , though differing in form , may be equivalent in function . therefore , strengthening the latter should weaken the former"},
	{"id": "W2311203695", "value": "mega7 : molecular evolutionary genetics analysis version 7.0 for bigger datasets we present the latest version of the molecular evolutionary genetics analysis ( mega ) software , which contains many sophisticated methods and tools for phylogenomics and phylomedicine . in this major upgrade , mega has been optimized for use on 64-bit computing systems for analyzing larger datasets . researchers can now explore and analyze tens of thousands of sequences in mega the new version also provides an advanced wizard for building timetrees and includes a new functionality to automatically predict gene duplication events in gene family trees . the 64-bit mega is made available in two interfaces : graphical and command line . the graphical user interface ( gui ) is a native microsoft windows application that can also be used on mac os x. the command line mega is available as native applications for windows , linux , and mac os x. they are intended for use in high-throughput and scripted analysis."}
]


HTTP 200
[{
    "id": "W2154889144",
    "value": {
        "domain": "physical sciences",
        "field": "computer science"
    }
},
{
    "id": "W1596397105",
    "value": {
        "domain": "health sciences",
        "field": "medicine"
    }
},
{
    "id": "W2089949851",
    "value": {
        "domain": "social sciences",
        "field": "psychology"
    }
},
{
    "id": "W2311203695",
    "value": {
        "domain": "life sciences",
        "field": "biochemistry genetics and molecular biology"
    }
}]