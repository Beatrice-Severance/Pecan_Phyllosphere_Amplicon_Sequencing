#!/bin/bash

# This script is run from the scripts directory in the scratch. It loops over the names in samples.txt. samples.txt should be in the scripts directory
# samples.txt is made by simply running the command ls > samples.txt then using nano and editing the last listed file since this is samples.txt
# we are using linked primers because the 300 bp reads likely span the entire amplicon so we might expect both primers to be in the forward and reverse reads
# Primers are 515F = GTGCCAGCMGCCGCGGTAA RC-515R = TTACCGCGGCKGCTGGCAC and 806R = GGACTACHVGGGTWTCTAAT RC-806R = ATTAGAWACCCBDGTAGTCC

mkdir /scratch/aubbxs/noel_files/EVSMITH/workflow/trimmed

#  load the module
module load anaconda/2-4.2.0_cent

for sample in $(cat samples.txt)
do

    echo "On sample: $sample"
	  cutadapt -g GTGCCAGCMGCCGCGGTAA -a GGACTACHVGGGTWTCTAAT -f fastq -n 2 -m 20 --discard-untrimmed --match-read-wildcards /scratch/aubbxs/noel_files/EVSMITH/workflow/merged/${sample}_merged.fastq > ${sample}_trimmed.fastq
done
