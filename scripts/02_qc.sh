#!/bin/bash

# Quality control for PacBio HiFi C. albicans data
# Checking read length distribution and quality scores

# Create output directory
mkdir -p ../results/qc

# Get basic statistics - checking if this is actually HiFi data
# (HiFi should have average read length > 10kb)
echo "Running seqkit stats..."
seqkit stats ../data/SRR23724250.fastq > ../results/qc/raw_stats.txt

# Check if seqkit worked
if [ ! -f ../results/qc/raw_stats.txt ]; then
    echo "Error: seqkit stats failed"
    exit 1
fi

# Run NanoPlot for detailed quality visualization
echo "Running NanoPlot for quality visualization..."
NanoPlot --fastq ../data/SRR23724250.fastq \
    --outdir ../results/qc/nanoplot_output \
    --prefix candida_hifi_

if [ $? -ne 0 ]; then
    echo "Error: NanoPlot failed"
    exit 1
fi

# Show summary
echo "QC complete. Basic statistics:"
cat ../results/qc/raw_stats.txt
