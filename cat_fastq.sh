#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate fastq_bam_env


echo ""c
echo "cat_fastq.sh start"
echo ""


for i in *_R1_001.fastq.gz;

    do SAMPLE=${i%%_*};
    echo $SAMPLE
    cat "$SAMPLE"_S**_L00*_R1_001.fastq.gz > "$SAMPLE"_R1_001.fastq.gz;

done


for i in *_R2_001.fastq.gz;

    do SAMPLE=${i%%_*};
    echo $SAMPLE
    cat "$SAMPLE"_S**_L00*_R2_001.fastq.gz > "$SAMPLE"_R2_001.fastq.gz;

done


rm *_L**_R*.fastq.gz


echo ""
echo "cat_fastq.sh job done!"
echo ""
