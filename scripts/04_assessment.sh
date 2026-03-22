#!/bin/bash

# Assembly quality assessment using QUAST and BUSCO

# QUAST - straightforward, no special configuration needed
echo "Running QUAST..."
mkdir -p ../results/assembly/quast_results

quast.py ../results/assembly/primary.fasta --glimmer -o ../results/assembly/quast_results

# BUSCO - more complex, requires proper environment setup
# Note: BUSCO has strict dependency requirements
# If this fails with import errors, try:
#   conda install -c bioconda -c conda-forge busco=5.4.3
# Or use conda environment file (see README)


echo "Running BUSCO..."

busco -i ../results/assembly/primary.fasta -l fungi_odb10 -o ../results/assessment/busco_candida -m genome --download_path ~/busco_downloads

# Check if BUSCO succeeded
if [ $? -ne 0 ]; then
    echo "BUSCO failed - this is common due to dependency issues"
    echo "Check README for troubleshooting steps"
    exit 1
fi
