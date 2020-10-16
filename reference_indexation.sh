# Author: Julie BOGOIN

echo ""
echo "REFERENCE INDEXATION start"
echo ""

source ~/miniconda3/etc/profile.d/conda.sh
conda activate fastq_bam_env

echo ""
echo "Merci d'indiquer le nom de l'archive .fa.gz à traiter (sans extension):"
read reference 

gunzip $reference.fa.gz

bwa index -a bwtsw $reference.fa

samtools faidx $reference.fa

gatk CreateSequenceDictionary -R $reference.fa -O $reference.dict

conda deactivate

echo ""
echo "REFERENCE INDEXATION job done!"
echo ""