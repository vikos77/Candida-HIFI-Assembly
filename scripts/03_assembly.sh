#!/bin/bash

# Assembly of PacBio HiFi reads using hifiasm
# Generates assembly graph (GFA) and converts to FASTA format

# Create output directory
mkdir -p ../results/assembly

# Run hifiasm assembler
# -o: output prefix
# -t: number of threads (adjust based on available CPU cores)
echo "Running hifiasm assembly..."
hifiasm -o ../results/assembly/candida_hifiasm \
    -t 8 \
    --primary \
    ../data/SRR23724250.fastq

# Check if assembly succeeded
if [ $? -ne 0 ]; then
    echo "Error: hifiasm assembly failed"
    exit 1
fi

echo "Assembly completed"
