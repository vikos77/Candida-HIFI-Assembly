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

# Convert GFA to FASTA
# hifiasm outputs multiple files:
# - .p_ctg.gfa = primary contigs (what we want)
#
# GFA format has:
# - S lines: contig sequences
# - L lines: links between contigs (topology)
#
# Extract only sequences (S lines) for downstream analysis

echo "Converting GFA to FASTA..."
awk '/^S/{print ">"$2; print $3}' \
    ../results/assembly/candida_hifiasm.p_ctg.gfa \
    > ../results/assembly/primary.fasta
