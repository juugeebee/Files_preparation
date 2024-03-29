#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate gatk4

echo ""
echo "bam_to_fastq.sh start"
echo ""

for bam_name in *.dedup.bam; \

do SAMPLE=${bam_name%%.dedup.bam} \

gatk SamToFastq -I $bam_name -F $SAMPLE.R1.fastq.gz -F2 $SAMPLE.R2.fastq.gz --VALIDATION_STRINGENCY SILENT

done

echo ""
echo "bam_to_fastq.sh job done!"
echo ""
