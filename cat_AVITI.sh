#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate fastq_bam_env


echo ""
echo "cat_aviti.sh start"
echo ""


for R1 in *-1_R1.fastq.gz;
    do L02=${R1/-1/-2};
    sample=${R1%%-*};
    cat $R1 $L02 > "$sample"_R1_001.fastq.gz; 
done


for R2 in *-1_R2.fastq.gz;
    do L02=${R2/-1/-2};
    sample=${R2%%-*};
    cat $R2 $L02 > "$sample"_R2_001.fastq.gz; 
done


### AVITI
# for R1 in *_R1.fastq.gz;
# do R2=${R1/_R1/_R2};
#    SAMPLE=${R1%%_*};
###


echo ""
echo "cat_aviti.sh job done!"
echo ""