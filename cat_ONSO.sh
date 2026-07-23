#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate fastq_bam_env


echo ""
echo "cat_onso.sh start"
echo ""


for R1 in FC0000342-BCC_L01_Read1_Sample_Library_*.fastq.gz; 
    do L02=${R1/_L01/_L02};
    FILE="$(awk -F\_ ' { print $(NF) } ' <<< "${R1}")";
    sample=${FILE%%.*}; 
    cat $R1 $L02 > "$sample"_R1_001.fastq.gz; 
done


for R2 in FC0000342-BCC_L01_Read2_Sample_Library_*.fastq.gz; 
    do L02=${R2/_L01/_L02};
    FILE="$(awk -F\_ ' { print $(NF) } ' <<< "${R2}")";
    sample=${FILE%%.*}; 
    cat $R2 $L02 > "$sample"_R2_001.fastq.gz; 
done


### ONSO    
# for R1 in FC0000342-BCC_L0*_Read1_Sample_Library_*.fastq.gz;
# do R2=${R1/_Read1/_Read2};
   # FILE="$(awk -F\_ ' { print $(NF) } ' <<< "${R1}")";
   # SAMPLE=${FILE%%.*};
###


echo ""
echo "cat_fastq.sh job done!"
echo ""