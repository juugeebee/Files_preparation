#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate fastq_bam_env

echo ""
echo "bcl2fastq.sh start"
echo ""

bcl2fastq --barcode-mismatches 0 --minimum-trimmed-read-length 35 --no-lane-splitting -R "." \
--sample-sheet "SampleSheet.csv" -o ./Fastq

# CONCATENER
for i in *.fastq.gz;
do cat /media/jbogoin/Data2/Donnees_brutes/hg19/Nephro/NEPHRO_HE_12012022_1/Fastq/$i \
/media/jbogoin/Data2/Donnees_brutes/hg19/Nephro/NEPHRO_HE_12012022_2/Fastq/$i \
> /media/jbogoin/Data2/Donnees_brutes/hg19/Nephro/NEPHRO_HE_12012022_CAT/$i;
done

echo ""
echo "bcl2fastq.sh job done!"
echo ""