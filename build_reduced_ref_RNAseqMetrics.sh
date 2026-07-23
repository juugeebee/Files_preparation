#!/usr/bin/env bash

source ~/miniconda3/etc/profile.d/conda.sh

# ============================================================
# Script : build_reduced_reference.sh
# Objectif : créer une référence fasta réduite aux 25 contigs
#            présents dans le BAM (chr1-22, X, Y, M), avec son
#            index .fai et son dictionnaire .dict (GATK),
#            pour résoudre les mismatchs de dictionnaire de
#            séquences avec CollectRnaSeqMetrics.
# ============================================================

# --- Paramètres à adapter si besoin ---
REF_DIR="/media/jbogoin/Data1/References/fa_hg38/hg38_rnaseq"
FULL_FASTA="${REF_DIR}/GRCh38.v48.primary_assembly.genome.fa"
REDUCED_FASTA="${REF_DIR}/GRCh38.v48.primary_assembly.chr25.fa"
REDUCED_DICT="${REF_DIR}/GRCh38.v48.primary_assembly.chr25.dict"
CONTIGS_LIST="${REF_DIR}/contigs_25.txt"

BAM_EXAMPLE="/media/jbogoin/Data2/Donnees_brutes/hg38/Neuro/RNA-Seq/RNASeq-Cibles-0004_NextSeq/BAM/6624NG001960-MAligned.sortedByCoord.out.bam"


echo "=== Étape 1 : indexation de la fasta complète (si nécessaire) ==="
if [[ ! -f "${FULL_FASTA}.fai" ]]; then
    samtools faidx "${FULL_FASTA}"
else
    echo "Index .fai déjà présent, on passe."
fi

echo "=== Étape 1bis : extraction de la liste des 25 contigs depuis le BAM ==="
samtools view -H "${BAM_EXAMPLE}" \
    | grep "^@SQ" \
    | sed 's/.*SN://; s/\t.*//' > "${CONTIGS_LIST}"

echo "Contigs trouvés :"
cat "${CONTIGS_LIST}"
NB_CONTIGS=$(wc -l < "${CONTIGS_LIST}")
echo "Nombre de contigs : ${NB_CONTIGS}"

echo "=== Étape 2 : extraction des 25 contigs dans une nouvelle fasta ==="
samtools faidx "${FULL_FASTA}" $(cat "${CONTIGS_LIST}") > "${REDUCED_FASTA}"

echo "=== Étape 3 : indexation + dictionnaire de la fasta réduite ==="
samtools faidx "${REDUCED_FASTA}"


conda activate gatk4

gatk CreateSequenceDictionary \
    -R "${REDUCED_FASTA}" \
    -O "${REDUCED_DICT}"

conda deactivate


echo "=== Étape 4 : vérification ==="
NB_SQ_DICT=$(grep -c "^@SQ" "${REDUCED_DICT}")
echo "Nombre de séquences dans le nouveau dictionnaire : ${NB_SQ_DICT}"
grep "^@SQ" "${REDUCED_DICT}" | head -5

if [[ "${NB_SQ_DICT}" -eq "${NB_CONTIGS}" ]]; then
    echo "OK : le dictionnaire réduit correspond bien au nombre de contigs du BAM (${NB_CONTIGS})."
else
    echo "ATTENTION : le nombre de séquences ne correspond pas (${NB_SQ_DICT} vs ${NB_CONTIGS}). Vérifier manuellement."
fi

echo ""
echo "=== Terminé ==="
echo "Fasta réduite  : ${REDUCED_FASTA}"
echo "Dictionnaire   : ${REDUCED_DICT}"
echo "Utiliser -R ${REDUCED_FASTA} dans vos commandes GATK/Picard désormais."
