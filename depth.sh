#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate snpxplex


#Couverture totale à chaque position du bed
for bam_name in *.dedup.bam; \
do SAMPLE=${bam_name%%.dedup.bam} \

samtools depth \
    -a $bam_name \
    -b '/media/Data1/jbogoin/ref/SNPXPlex/snps.bed' \
    -o $SAMPLE-depth.txt \
    -q 0

done


echo ""
echo "depth.sh job done!"
echo ""


