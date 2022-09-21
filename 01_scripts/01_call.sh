#!/bin/bash

# 1st of SV calling with smoove : call genotype for all samples and all sites 

# IF SOME CHROMOSOMES NEED TO BE EXCLUDED : add these chrs to excl_chrs.txt (1 per line)

# parallel -a 02_infos/ind_ALL.txt -k -j 10 srun -c 1 --mem=20G -p medium --time=7-00:00 -J 01_call_{} -log/01_call_{}_%j.log /bin/sh 01_scripts/01_call.sh {} &

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

# 1. Generate bed for excluded chromosomes
if [[ ! -f 02_infos/excl_chrs.bed ]]
then
  less $REGIONS_EX | while read REGION
  do
    less "$GENOME".fai | grep -Fw "$REGION" | cut -f1,3,4 >> 02_infos/excl_chrs.bed
  done
  bgzip 02_infos/excl_chrs.bed -f
  tabix -p bed 02_infos/excl_chrs.bed.gz -f
fi


# 1. Call genotypes by parallelizing by SAMPLE
#smoove call --outdir results-smoove/ --exclude $bed --name $sample --fasta $reference_fasta -p 1 --genotype /path/to/$sample.bam
smoove call --outdir $CALLS_DIR/raw --name $SAMPLE --fasta $GENOME -p 1 --genotype $sample

#ls ./00_sequences/*.bam | parallel -j 20 srun -p large -J smoove_{/.} -o smoove_{/.}_%j.log ./01_scripts/01.1_smoove_call.sh {} \; sleep 0.1 &