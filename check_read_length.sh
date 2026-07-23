#!/bin/bash
set -euo pipefail

# Usage : ./check_read_length.sh /chemin/vers/dossier_fastq
# Si aucun argument n'est donné, utilise le dossier courant.

INPUT_DIR="${1:-.}"

cd "$INPUT_DIR"

shopt -s nullglob
FASTQ_FILES=(*.fastq.gz *.fq.gz)
shopt -u nullglob

if [ ${#FASTQ_FILES[@]} -eq 0 ]; then
    echo "Aucun fichier .fastq.gz ou .fq.gz trouvé dans $INPUT_DIR"
    exit 1
fi

printf "%-55s %-10s %-10s %-10s %-12s\n" "Fichier" "Min" "Max" "Moyenne" "Uniforme?"
printf "%-55s %-10s %-10s %-10s %-12s\n" "-------" "---" "---" "-------" "---------"

for f in "${FASTQ_FILES[@]}"; do
    stats=$(zcat "$f" | awk 'NR%4==2 {
        len = length($0)
        sum += len
        n++
        if (n==1) { min=len; max=len }
        if (len<min) min=len
        if (len>max) max=len
    }
    END {
        if (n>0) printf "%d %d %.1f", min, max, sum/n
        else printf "0 0 0"
    }')

    min=$(echo "$stats" | cut -d' ' -f1)
    max=$(echo "$stats" | cut -d' ' -f2)
    moy=$(echo "$stats" | cut -d' ' -f3)

    if [ "$min" == "$max" ]; then
        uniforme="oui"
    else
        uniforme="NON"
    fi

    printf "%-55s %-10s %-10s %-10s %-12s\n" "$f" "$min" "$max" "$moy" "$uniforme"
done
