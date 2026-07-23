#!/bin/bash
set -euo pipefail

# Usage : ./check_and_concat_fastq.sh /chemin/vers/Fastq
#
# Comportement :
#   - Les fichiers fusionnés (résultat de la concaténation) restent dans INPUT_DIR (ex: Fastq/)
#   - Les fichiers sources (lanes individuelles ayant servi à la concaténation)
#     sont déplacés dans INPUT_DIR/raw_lanes/
#   - Les échantillons à 1 seule lane (pas de concaténation nécessaire) restent
#     inchangés dans INPUT_DIR

INPUT_DIR="${1:-.}"
ARCHIVE_DIR="${INPUT_DIR}/raw_lanes"

mkdir -p "$ARCHIVE_DIR"

echo "Dossier Fastq (source + destination finale) : $INPUT_DIR"
echo "Dossier d'archive des fichiers non concaténés (lanes brutes) : $ARCHIVE_DIR"
echo ""

cd "$INPUT_DIR"

mapfile -t SAMPLES < <(ls *_R1_001.fastq.gz 2>/dev/null | sed -E 's/_L[0-9]+_R1_001\.fastq\.gz$//' | sort -u)

if [ ${#SAMPLES[@]} -eq 0 ]; then
    echo "Aucun fichier *_R1_001.fastq.gz trouvé dans $INPUT_DIR"
    exit 1
fi

for sample in "${SAMPLES[@]}"; do
    r1_files=($(ls "${sample}"_L*_R1_001.fastq.gz 2>/dev/null | sort))
    r2_files=($(ls "${sample}"_L*_R2_001.fastq.gz 2>/dev/null | sort))

    nb_total=$(( ${#r1_files[@]} + ${#r2_files[@]} ))

    echo "----------------------------------------"
    echo "Échantillon : $sample"
    echo "  R1 : ${#r1_files[@]} fichier(s)"
    echo "  R2 : ${#r2_files[@]} fichier(s)"

    if [ "$nb_total" -le 2 ]; then
        echo "  -> 1 seule lane, pas de concaténation nécessaire (fichier laissé tel quel)."
    else
        echo "  -> Plusieurs lanes détectées, concaténation en cours..."

        if [ ${#r1_files[@]} -gt 0 ]; then
            cat "${r1_files[@]}" > "${sample}_R1_001.fastq.gz.tmp"
            mv "${r1_files[@]}" "$ARCHIVE_DIR/"
            mv "${sample}_R1_001.fastq.gz.tmp" "${sample}_R1_001.fastq.gz"
            echo "     R1 concaténé -> ${sample}_R1_001.fastq.gz"
        fi

        if [ ${#r2_files[@]} -gt 0 ]; then
            cat "${r2_files[@]}" > "${sample}_R2_001.fastq.gz.tmp"
            mv "${r2_files[@]}" "$ARCHIVE_DIR/"
            mv "${sample}_R2_001.fastq.gz.tmp" "${sample}_R2_001.fastq.gz"
            echo "     R2 concaténé -> ${sample}_R2_001.fastq.gz"
        fi
    fi
done

echo "----------------------------------------"
echo "Terminé."
echo "Fichiers finaux (concaténés ou uniques) : $INPUT_DIR"
echo "Fichiers sources archivés (lanes brutes) : $ARCHIVE_DIR"
