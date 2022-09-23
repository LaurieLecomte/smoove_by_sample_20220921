# SV calling from short reads using **SMOOVE**

# Pipeline Overview

As recommended in [smoove's user manual](https://github.com/brentp/smoove/#population-calling), SV calling should be done separately for each sample for high coverage data. This pipeline thus parallelizes the SV calling step across **samples**.

1. Call SVs in all samples
2. Merge SV sites across samples
3. Genotype SVs at merged sites in each sample
4. Merge samples together into a single file


# Prerequisites

### Files 

* A **reference genome** (`.fasta`) and its **index** (`.fai`) in `03_genome`
* **Bam files** for all samples and their index. These can be soft-linked in the `04_bam` folder for easier handling : if `$BAM_PATH` is the remote path to bam files, use `for file in $(ls -1 $BAM_PATH/*); do ln -s $file ./04_bam; done`. These should be named as `SAMPLEID.bam` (see sample ID list below).
* A **bam files list** in `02_infos`. This list can be generated with the following command, where `$BAM_DIR` is the path of the directory where bam files are located : `ls -1 $BAM_DIR/*.bam > 02_infos/bam_list.txt`
* A sample IDs list in `02_infos`, one ID per line. This list can be used for renaming bam files symlinks in `$BAM_DIR`, adjust `grep` command as required (warning : use carefully): `less 02_infos/ind_ALL.txt | while read ID; do BAM_NAME=$(ls $BAM_DIR/*.bam | grep "$ID"); mv $BAM_NAME $BAM_DIR/"$ID".bam; done` and `less 02_infos/ind_ALL.txt | while read ID; do BAM_NAME=$(ls $BAM_DIR/*.bai | grep "$ID"); mv $BAM_NAME $BAM_DIR/"$ID".bam.bai; done`
* A **chromosomes list** (or contigs, or sites) in `02_infos`. This list is used for parallelizing the SV calling step. It can be produced from the indexed genome file ("$GENOME".fai) : `less "$GENOME".fai | cut -f1 > 02_infos/chr_list.txt`. 
* **If some chromosomes are to be excluded from the SV calling step**, these should be placed in `02_infos/excl_chrs.txt`, which needs to be encoded in linux format AND have a newline at the end.

* Optional : a list of samples IDs and their population (and/or sex) for popgen analysis, such as PCA or FST calculation, in `02_infos`. **WARNING** : the 02_infos/excl_chrs.txt file mush be encoded in linux format, otherwise grep won't grep, AND have a newline at the end


