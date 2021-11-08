#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate gatk_env

echo ""
echo "fastq_to_bam.sh start"
echo ""

REF="/media/Data1/jbogoin/ref/fa_hg19/hg19_std/hg19_std.fa"

for R1 in *_R1_001.fastq.gz; 

do R2=${R1/.R1/.R2};

SAMPLE=${R1%%_*};

bwa mem -M $REF $R1 $R2 | samtools view -Shb - > $SAMPLE.bam;

done


for bam_name in *.bam;

do SAMPLE=${bam_name%%.*};

echo $SAMPLE;

gatk SortSam \
	-I $bam_name \
        -O $SAMPLE.sorted.bam \
        --SORT_ORDER coordinate \
        --VALIDATION_STRINGENCY SILENT \
        --VERBOSITY ERROR \
        --QUIET true \
        --COMPRESSION_LEVEL 0;

gatk MarkDuplicates \
        -I $SAMPLE.sorted.bam \
        -O $SAMPLE.marked_duplicates.bam \
	--ASSUME_SORTED true \
        --METRICS_FILE $SAMPLE.marked_dup_metrics.txt \
        --VALIDATION_STRINGENCY SILENT;

# gatk MarkDuplicates \
#         -I $bam_na \
#         -O $SAMPLE.marked_duplicates.bam \
#         --METRICS_FILE $SAMPLE.marked_dup_metrics.txt \
#         --VALIDATION_STRINGENCY SILENT;

samtools index $SAMPLE.marked_duplicates.bam;

done

echo ""
echo "fastq_to_bam.sh job done!"
echo ""




