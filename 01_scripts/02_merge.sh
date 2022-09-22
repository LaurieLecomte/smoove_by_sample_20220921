#!/bin/bash

# 2nd step of SV calling with smoove : merge sites across samples

# IF SOME CHROMOSOMES NEED TO BE EXCLUDED : add these chrs to excl_chrs.txt and run 00_prepare_regions.sh beforehand, and uncomment line 33 

# srun -c 1 --mem=20G -p small -J 02_merge -o log/02_merge_%j.log /bin/sh 01_scripts/02_merge.sh &

# VARIABLES
GENOME="03_genome/genome.fasta"
CHR_LIST="02_infos/chr_list.txt"
BAM_DIR="04_bam"
CALLS_DIR="05_calls"
MERGED_DIR="06_merged"
FILT_DIR="07_filtered"

REGIONS_EX="02_infos/excl_chrs.txt"


if [[ ! -d $CALLS_DIR/merged ]]
then
  mkdir $CALLS_DIR/merged
fi

# 1. Get the union of sites across all samples (this can parallelize this across as many CPUs or machines as needed):
# smoove merge --name merged -f $reference_fasta --outdir ./ results-smoove/*.genotyped.vcf.gz 
smoove merge --name merged -f $GENOME --outdir $CALLS_DIR/merged $CALLS_DIR/raw/*.vcf.gz