# Author: Julien Buratti

source ~/miniconda3/etc/profile.d/conda.sh
conda activate exome_targets_env

echo ""
echo "targets_preparation start"
echo ""

#### Préparation fichiers bed

DIC="/media/Data1/jbogoin/ref/fa_hg38/hg38_GenDev/hg38_GenDev.dict"

# Télécharger le fichier gencode.v34.basic.annotation.gff3 sur le site de GENECODE
#wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/gencode.v34.basic.annotation.gff3.gz

# Recupérer les CDS
# Ajouter une 4ème colonne et trier

zcat gencode.v34.basic.annotation.gff3.gz | \
    awk -F "\t" '{if ($3=="CDS"){print $1"\t"$4-1"\t"$5}}' |\
    sort -Vu > gencode.v34.basic.annotation.CDS.bed

# Supprimer les intervalles chevauchants
bedtools merge -i gencode.v34.basic.annotation.CDS.bed > gencode.v34.basic.annotation.CDS.merged.bed 

# Ajouter une colonne 4
awk -F "\t" '{print $1, $2, $3, "CDS"}' gencode.v34.basic.annotation.CDS.merged.bed > gencode.v34.basic.annotation.CDS.merged.4fields.bed

# Transformer bed en interval.list
gatk BedToIntervalList \
    -I gencode.v34.basic.annotation.CDS.merged.4fields.bed \
    -O gencode.v34.basic.annotation.CDS.merged.4fields.interval_list \
    -SD $DIC

# Faire un fichier cible par chromosome
#for i in {1..22} X Y; do grep "^chr${i}" gencode.v34.basic.annotation.CDS.merged.bed \
#   > gencode.v34.basic.annotation.CDS.chr${i}.bed; done

echo ""
echo "targets_preparation job done!"
echo ""

## QC ##
# zgrep "        CDS     " gencode.v36.basic.annotation.gff3.gz | grep -v ";level=3;" > gencode-v36.basic.annotation.CDS.lvl1-2.gff3

# awk -F "\t" '{print $1"\t"$4-1"\t"$5}' gencode-v36.basic.annotation.CDS.lvl1-2.gff3 | sort -Vu > gencode-v36.basic.annotation.CDS.lvl1-2.sortU.bed

# bedtools merge -i gencode-v36.basic.annotation.CDS.lvl1-2.sortU.bed > gencode-v36.basic.annotation.CDS.lvl1-2.sortU.merged.bed

# grep -v "^chrX" gencode-v36.basic.annotation.CDS.lvl1-2.sortU.merged.bed | grep -v "^chrY" > gencode-v36.basic.annotation.CDS.lvl1-2.sortU.merged.autosomes.bed

# java -jar ~/Programmes/gatk-4.1.8.1/gatk-package-4.1.8.1-local.jar BedToIntervalList -I gencode-v36.basic.annotation.CDS.lvl1-2.sortU.merged.autosomes.bed -O gencode-v36.basic.annotation.CDS.lvl1-2.sortU.merged.autosomes.intervalList -SD /home/jburatti/Programmes/reference_genome/hg38/GRCH38p13/GenDev/hg38_GenDev.fa.gz.dict

# ---------------------------

## CALLING ##
# zgrep "        CDS     " gencode.v36.basic.annotation.gff3.gz > gencode-v36.basic.annotation.CDS.lvl1-2-3.gff3

# awk -F "\t" '{print $1"\t"$4-1"\t"$5}' gencode-v36.basic.annotation.CDS.lvl1-2-3.gff3 | sort -Vu > gencode-v36.basic.annotation.CDS.lvl1-2-3.sortU.bed

# awk -F "\t" '{print $1"\t"$2-75"\t"$3+75}' gencode-v36.basic.annotation.CDS.lvl1-2-3.sortU.bed | sort -Vu > gencode-v36.basic.annotation.CDS.lvl1-2-3.sortU.pad75.bed

# bedtools merge -i gencode-v36.basic.annotation.CDS.lvl1-2-3.sortU.pad75.bed > gencode-v36.basic.annotation.CDS.lvl1-2-3.sortU.pad75.merged.bed

# for i in {1..22} X Y; do grep "^chr${i}	" gencode-v36.basic.annotation.CDS.lvl1-2-3.sortU.pad75.merged.bed > gencode-v36.basic.annotation.CDS.lvl1-2-3.sortU.pad75.merged.chr${i}.bed; done


