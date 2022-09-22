#!/bin/bash

# 1st of SV calling with smoove : call genotype for all samples and all sites 

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
if [[ ! -d $CALLS_DIR/raw ]]
then
  mkdir $CALLS_DIR/raw
fi

#if [[ ! -d $CALLS_DIR/raw/$SAMPLE ]]
#then
#  mkdir $CALLS_DIR/raw/$SAMPLE
#fi

# 1. Call genotypes by parallelizing by SAMPLE
#smoove call --outdir results-smoove/ --exclude $bed --name $sample --fasta $reference_fasta -p 1 --genotype /path/to/$sample.bam
smoove call --outdir $CALLS_DIR/raw --name $SAMPLE --fasta $GENOME -p 1 --genotype $BAM_DIR/"$SAMPLE".bam

# 2. Rename for easier scripting
mv "$CALLS_DIR/raw/"$SAMPLE"-smoove.genotyped.vcf.gz" "$CALLS_DIR/raw/"$SAMPLE"_raw.vcf.gz"
mv "$CALLS_DIR/raw/"$SAMPLE"-smoove.genotyped.vcf.gz.csi" "$CALLS_DIR/raw/"$SAMPLE"_raw.vcf.gz.csi"