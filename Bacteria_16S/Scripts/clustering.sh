#!/bin/bash

#HAVE TO INSTALL USEARCH BEFORE USING

module load vsearch
mkdir /scratch/aubbxs/noel_files/EVSMITH/workflow/clustered

# dereplication
vsearch --derep_fulllength /scratch/aubbxs/noel_files/EVSMITH/workflow/filtered/filtered.fasta --output /scratch/aubbxs/noel_files/EVSMITH/workflow/filtered/uniques.fasta -sizeout

# de-noising (error correction), output is zero-radius OTUs
#usearch -unoise3 output/clustered/uniques_R1.fasta -tabbedout output/clustered/unoise_zotus_R1.txt -zotus output/clustered/zotus_R1.fasta

# clusters OTUs based on traditional 97% identity
usearch -cluster_otus /scratch/aubbxs/noel_files/EVSMITH/workflow/filtered/uniques.fasta -minsize 2 -otus /scratch/aubbxs/noel_files/EVSMITH/workflow/filtered/otus.fasta -uparseout /scratch/aubbxs/noel_files/EVSMITH/workflow/filtered/uparse_otus.txt -relabel BOTU_ --threads 20
