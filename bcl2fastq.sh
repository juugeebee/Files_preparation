#!/bin/bash

source ~/miniconda3/etc/profile.d/conda.sh
conda activate fastq_bam_env

echo ""
echo "bcl2fastq.sh start"
echo ""

bcl2fastq --barcode-mismatches 0 --minimum-trimmed-read-length 35 --no-lane-splitting -R "." \
--sample-sheet "SampleSheet.csv" -o ./Fastq

echo ""
echo "bcl2fastq.sh job done!"
echo ""