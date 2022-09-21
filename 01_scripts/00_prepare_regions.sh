#!/bin/bash

# If some chromosomes need to be removed from SV calling, this script produces required bed files beforehand to indicate regions where SVs must NOT be called.
# WARNING : the 02_infos/excl_chrs.txt file mush be encoded in linux format, otherwise grep won't grep, AND have a newline at the end

# VARIABLES
GENOME="03_genome/genome.fasta"
CHR_LIST="02_infos/chr_list.txt"
BAM_DIR="04_bam"
CALLS_DIR="05_calls"
MERGED_DIR="06_merged"
FILT_DIR="07_filtered"


REGIONS_EX="02_infos/excl_chrs.txt"

if [[ -f 02_infos/excl_chrs.bed ]]
then
  rm 02_infos/excl_chrs.bed
fi

# 1. Create bed from genome index
less "$GENOME".fai | awk 'BEGIN {FS="\t"}; {print $1 FS "0" FS $2}' > "$GENOME".bed

# 2. Generate bed for excluded chromosomes
less $REGIONS_EX | while read REGION || [ -n "$line" ]
do
  grep -Fw $REGION "$GENOME".bed >> 02_infos/excl_chrs.bed
done

bgzip 02_infos/excl_chrs.bed -f
tabix -p bed 02_infos/excl_chrs.bed.gz -f
