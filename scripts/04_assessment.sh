#!/bin/bash

# Assembly quality assessment using QUAST and BUSCO

# QUAST - straightforward, no special configuration needed
echo "Running QUAST..."
mkdir -p ../results/assessment/quast

quast.py ../results/assembly/ecoli_assembly.fasta \
    -o ../results/assessment/quast

# BUSCO - more complex, requires proper environment setup
# Note: BUSCO has strict dependency requirements
# If this fails with import errors, try:
#   conda install -c bioconda -c conda-forge busco=5.4.3
# Or use conda environment file (see README)

#We use quast tool to analyse the assembled data 
quast.py ../results/assembly/ecoli_assembly.fasta --glimmer -o ../results/assembly/quast_results

echo "Running BUSCO..."

busco -i ../results/assembly/ecoli_assembly.fasta -l bacteria_odb10 -o ../results/assessment/busco_ecoli -m genome --download_path ~/busco_downloads

# Check if BUSCO succeeded
if [ $? -ne 0 ]; then
    echo "BUSCO failed - this is common due to dependency issues"
    echo "Check README for troubleshooting steps"
    exit 1
fi
