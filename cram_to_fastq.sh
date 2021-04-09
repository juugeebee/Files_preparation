#!/bin/bash

echo ""
echo "cram_to_fastq.sh start"

#ref="/media/Data1/jbogoin/ref/fa_hg19/hg19_ref/hg19_std.fa.gz"
#ref="/media/Data1/jbogoin/ref/fa_hg19/re-index/hg19_std.fa"
ref="/media/Data1/jbogoin/ref/fa_hg19/hg19_std/hg19_std.fa"

for cram_name in *.cram; \

do SAMPLE=${cram_name%%_*_*.cram}; \

echo "";	
echo "Sample name:"
echo $SAMPLE;

samtools fastq --reference $ref -1 $SAMPLE.R1.fastq -2 $SAMPLE.R2.fastq $cram_name;

done

echo ""
echo "cram_to_fastq.sh job done!"
echo ""
