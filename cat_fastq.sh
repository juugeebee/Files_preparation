#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate fastq_bam_env


REF="/media/jbogoin/Data1/References/fa_hg19/hg19_std_M-rCRS_Y-PAR-mask.fa"


echo ""
echo "cat_fastq.sh start"
echo ""


for i in *_R1_001.fastq.gz;

    do SAMPLE=${i%%_*};
    cat "$SAMPLE"_S*_R1_001.fastq.gz > "$SAMPLE"_R1_001.fastq.gz;

done

for i in *_R2_001.fastq.gz;

    do SAMPLE=${i%%_*};
    cat "$SAMPLE"_S*_R2_001.fastq.gz > "$SAMPLE"_R2_001.fastq.gz;

done


echo ""
echo "cat_fastq.sh job done!"
echo ""
