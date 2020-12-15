# Author: Julien BURATTI

source ~/miniconda3/etc/profile.d/conda.sh
conda activate fastq_bam_env

echo ""
echo "fastq_to_bam.sh start"
echo ""

DATA=$PWD

### REMOVE previous dedup.bam files ###
rm -f *.bam*

## MAPPING BWA SEQUENTIAL 
for R1 in *_R1_001.fastq.gz; 
    
    do 
    R2=${R1/_R1_/_R2_}; 

    SAMPLE=${R1%%_*};

    cd /media/Data1/jbogoin/ref/fa_hg19/;

    bowtie2 -p 36 -x hg19_std -1 $DATA/$R1 -2 $DATA/$R2 -S $DATA/$SAMPLE.sam;

    cd $DATA

    samtools view -@ 36 -bS $SAMPLE.sam -o $SAMPLE.bam;

    samtools sort -@ 36 $SAMPLE.bam -o $SAMPLE.sorted.bam;

    samtools index -@ 12 $SAMPLE.sorted.bam;

done

### MARK DUPLICATES
for i in *.sorted.bam; 
    
    do 
    SAMPLE=${i%.sorted.bam};
    
    sambamba markdup -t 36 ${SAMPLE}.bam ${SAMPLE}.dedup.bam;
    
done

rm *.sam
rm *.sorted.bam

echo ""
echo "fastq_to_bam.sh job done!"
echo ""
