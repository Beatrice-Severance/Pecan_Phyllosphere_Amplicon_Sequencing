#!/bin/bash

module load vsearch
mkdir /scratch/aubbxs/noel_files/EVSMITH/workflow/stats

cat /scratch/aubbxs/noel_files/EVSMITH/workflow/trimmed/*.fastq > /scratch/aubbxs/noel_files/EVSMITH/workflow/trimmed/trimmed.fastq

vsearch -fastq_stats /scratch/aubbxs/noel_files/EVSMITH/workflow/trimmed/trimmed.fastq -log stats_results.txt
