#!/bin/bash
set +x
doc_en='[{"id":"PhnlUo_d6LoJPLN3YUjh5qBLc","value":"Non-local effects by homogenization or 3D–1D dimension reduction in elastic materials reinforced by stiff fibers.We first consider an elastic thin heterogeneous cylinder of radius of order ε: the interior of the cylinder is occupied by a stiff material (fiber) that is surrounded by a soft material (matrix). By assuming that the elasticity tensor of the fiber does not scale with ε and that of the matrix scales with ε2, we prove that the one dimensional model is a nonlocal system.We then consider a reference configuration domain filled out by periodically distributed rods similar to those described above. We prove that the homogenized model is a second order nonlocal problem.In particular, we show that the homogenization problem is directly connected to the 3D–1D dimensional reduction problem."}]'
#  ./test/test_predict_EZ.sh  ./test_predict_EZ.sh $HOME/data/data.json
url_dev="http://ft2c-01.tdmservices.intra.inist.fr/v1/en/classify?indent=true&deep=3"
url_prod="https://domains-classifier-2.services.inist.fr/v1/en/classify?indent=true&deep=3"
url_prod_sp="http://vptdmservices.intra.inist.fr:35268/"
#proxy : http://proxyout.inist.fr:8080/

echo "curl prod -------------"
echo $doc_en | curl  -i --proxy ""  -X POST --data-binary @- $url_prod
echo -e
echo -e
#echo "curl prod-sp -------------"
#echo $doc_en | curl  -i --proxy "" -X POST --data-binary @- $url_prod_sp
#echo -e
echo -e
echo "curl dev-------------"
echo $doc_en | curl  -i --proxy ""  -X POST --data-binary @- $url_dev