#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate gatk4

echo ""
echo "bam_to_fastq.sh start"
echo ""

mkdir -p ../Fastq/

for bam_name in *Aligned.sortedByCoord.out.bam
do
    SAMPLE=${bam_name%%Aligned.sortedByCoord.out.bam}

    gatk SamToFastq \
        -I "$bam_name" \
        -F  "../Fastq/${SAMPLE}_R1.fastq.gz" \
        -F2 "../Fastq/${SAMPLE}_R2.fastq.gz" \
        --VALIDATION_STRINGENCY SILENT
done

echo ""
echo "bam_to_fastq.sh job done!"
echo ""
