#!/bin/bash

# 3rd step of SV calling with smoove : genotype for all samples and all sites 

# IF SOME CHROMOSOMES NEED TO BE EXCLUDED : add these chrs to excl_chrs.txt and run 00_prepare_regions.sh beforehand, and uncomment line 33 

# parallel -a 02_infos/ind_ALL.txt -k -j 10 srun -c 1 --mem=20G -p small -J 01_call_{} -log/01_call_{}_%j.log /bin/sh 01_scripts/01_call.sh {} &

# VARIABLES
GENOME="03_genome/genome.fasta"
CHR_LIST="02_infos/chr_list.txt"
BAM_DIR="04_bam"
CALLS_DIR="05_calls"
MERGED_DIR="06_merged"
FILT_DIR="07_filtered"

SAMPLE=$1

REGIONS_EX="02_infos/excl_chrs.txt"

# Create directory for raw calls
if [[ ! -d $CALLS_DIR/geno ]]
then
  mkdir $CALLS_DIR/geno
fi

# 3. genotype each sample at those sites (this can parallelize this across as many CPUs or machines as needed) and run duphold to add depth annotations.
smoove genotype -d -x -p 1 --name "$SAMPLE"_raw --outdir $CALLS_DIR/geno --fasta $GENOME --vcf $CALLS_DIR/merged/merged.sites.vcf.gz $BAM_DIR/"$SAMPLE".bam 