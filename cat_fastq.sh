#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate fastq_bam_env


echo ""
echo "cat_fastq.sh start"
echo ""


mkdir -p Fastq_cat

for i in *_R1_001.fastq.gz;


    do SAMPLE=${i%%_*};
    echo $SAMPLE
    cat "$SAMPLE"*_R1_001.fastq.gz > Fastq_cat/"$SAMPLE"_R1.fastq.gz;

done


for i in *_R2_001.fastq.gz;

    do SAMPLE=${i%%_*};
    echo $SAMPLE
    cat "$SAMPLE"*_R2_001.fastq.gz > Fastq_cat/"$SAMPLE"_R2.fastq.gz;

done


# rm *_L**_R*.fastq.gz


echo ""
echo "cat_fastq.sh job done!"
echo ""
