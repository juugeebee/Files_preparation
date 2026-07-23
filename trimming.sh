#!/usr/bin/sudo bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq


echo ""
echo "trimming.sh start"
echo ""


cd Fastq
mkdir -p ../../cat_trimmed/Fastq


# trim the first 3 bases and the last 10 bases
for R1 in *_R1_001.fastq.gz;
do R2=${R1/_R1/_R2};
   SAMPLE=${R1%%_*};
   seqtk trimfq -b 3 -e 10 $R1 > ../../cat_trimmed/Fastq/${SAMPLE}_R1_001.fastq;
   gzip ../../cat_trimmed/Fastq/${SAMPLE}_R1_001.fastq;
   seqtk trimfq -b 3 -e 10 $R2 > ../../cat_trimmed/Fastq/${SAMPLE}_R2_001.fastq;
   gzip ../../cat_trimmed/Fastq/${SAMPLE}_R2_001.fastq;
done


cd ..


echo ""
echo "trimming.sh job done!"
echo ""