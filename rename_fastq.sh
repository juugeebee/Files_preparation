#!/bin/bash

for f in *.fastq.gz; do
    # Remplacer .R1. par _R1. et .R2. par _R2.
    newname=$(echo "$f" | sed -E 's/\.R1\./_R1./; s/\.R2\./_R2./')
    
    # Renommer seulement si le nom change
    if [[ "$f" != "$newname" ]]; then
        mv "$f" "$newname"
        echo "Renommé : $f -> $newname"
    fi
done