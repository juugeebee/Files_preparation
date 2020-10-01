#!/bin/bash

run_dir=$1

bcl2fastq --use-bases-mask Y*,I*,I*,Y* --ignore-missing-bcls --ignore-missing-filter --ignore-missing-positions --ignore-missing-controls --barcode-mismatches 0 --adapter-stringency 0.9 --mask-short-adapter-reads 35 --minimum-trimmed-read-length 35 --no-lane-splitting --loading-threads 4 --processing-threads 4 -R $run_dir --sample-sheet "${run_dir}/SampleSheet.csv" -o "${run_dir}/Fastq" #-i "${run_dir}/Data/Intensities/BaseCalls" --find-adapters-with-sliding-window

# Basespace
# bcl2fastq  --ignore-missing-bcls --ignore-missing-filter --ignore-missing-positions --ignore-missing-controls --auto-set-to-zero-barcode-mismatches --find-adapters-with-sliding-window --adapter-stringency 0.9 --mask-short-adapter-reads 35 --minimum-trimmed-read-length 35 --loading-threads 1 -R "/data/scratch/workspace/RunFolder" --sample-sheet "/data/scratch/workspace/RunFolder/SampleSheet.csv" -o "/data/scratch/workspace/RunFolder/Analysis/Temp_01.01-GenerateFASTQ.FastqGeneration"

# Alban
# bcl2fastq --ignore-missing-positions --ignore-missing-controls --ignore-missing-filter --ignore-missing-bcls -R 171206_NB501346_0163_AHVY3MAFXX/ --sample-sheet 171206_NB501346_0163_AHVY3MAFXX/ SampleSheet.csv -o 171206_NB501346_0163_AHVY3MAFXX/Fastq/ --use-bases-mask Y151,I8,I8,Y151 --no-lane-splitting

# cd ${run_dir}/Fastq/SeqCap_EZ_MedExome*

# for i in `ls *.fastq.gz`; do sample=$(echo $i | cut -f 1 -d '_'); if [ $sample != "Undetermined" ] && [ ! -d $sample ]; then mkdir $sample; mv ${sample}*.fastq.gz ${sample}/; fi; done
