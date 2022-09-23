#!/bin/bash

# 4th step of SV calling with smoove : merge sites across samples

# IF SOME CHROMOSOMES NEED TO BE EXCLUDED : add these chrs to excl_chrs.txt and run 00_prepare_regions.sh beforehand, and uncomment line 33 

# srun -c 1 --mem=20G -p small -J 04_paste -o log/04_paste_%j.log /bin/sh 01_scripts/04_paste.sh &

# VARIABLES
GENOME="03_genome/genome.fasta"
CHR_LIST="02_infos/chr_list.txt"
BAM_DIR="04_bam"
CALLS_DIR="05_calls"
MERGED_DIR="06_merged"
FILT_DIR="07_filtered"

REGIONS_EX="02_infos/excl_chrs.txt"


#1. Paste all the single sample VCFs with the same number of variants to get a single, squared, joint-called file.
smoove paste --outdir $MERGED_DIR --name merged $CALLS_DIR/geno/*.vcf.gz

# 2. Clean up files from previous steps
#for file in $(ls -1 $CALLS_DIR/raw/*.bam); do rm $file; done