#!/bin/bash

module load vsearch
mkdir /scratch/aubbxs/noel_files/EVSMITH/workflow/filtered

vsearch -fastq_filter /scratch/aubbxs/noel_files/EVSMITH/workflow/trimmed/trimmed.fastq -fastq_maxee 0.5 -fastq_trunclen 250 -fastq_maxns 0 -fastaout /scratch/aubbxs/noel_files/EVSMITH/workflow/filtered/filtered.fasta -fastqout /scratch/aubbxs/noel_files/EVSMITH/workflow/filtered/filtered.fastq
