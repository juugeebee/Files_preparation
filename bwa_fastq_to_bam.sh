#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate fastq_bam_env


REF="/media/jbogoin/Data1/References/fa_hg19/hg19_std_M-rCRS_Y-PAR-mask.fa"


echo ""
echo "bwa_fastq_to_bam.sh start"
echo ""


### ALIGNEMENT ###
for R1 in *_R1_001.fastq.gz; 
    do R2=${R1/.R1/.R2}; 
    SAMPLE=${R1%%.*}; 
    FLOWCELL="$(zcat $R1 | head -1 | awk '{print $1}' | cut -d ":" -f 3)";
    DEVICE="$(zcat $R1 | head -1 | awk '{print $1}' | cut -d ":" -f 1 | cut -d "@" -f 2)";
    BARCODE="$(zcat $R1 | head -1 | awk '{print $2}' | cut -d ":" -f 4)";
    RG=$(echo "\"@RG\tID:${DEVICE}.${FLOWCELL}.${SAMPLE}\tPU:${FLOWCELL}\tSM:${SAMPLE}\tPL:ILLUMINA\tLB:${SAMPLE}-${BARCODE}\"");
    MAPPING_CMD=$(echo "bwa mem -M -Y -t 24 -R $RG $REF $R1 $R2 | samtools sort -@ 6 -o ${SAMPLE}.bam -");
    eval $MAPPING_CMD;
done


### MARK DUPLICATES ###
for i in *.bam;
do SAMPLE=${i%.*};
sambamba markdup -t 36 ${SAMPLE}.bam ${SAMPLE}.dedup.bam;
done


### REMOVING BAM ###
rm -f --interactive=never *_001.bam


echo ""
echo "bwa_fastq_to_bam.sh job done!"
echo ""