#!/bin/bash

module load vsearch
mkdir /scratch/aubbxs/noel_files/EVSMITH/workflow/taxonomy

# Assign taxonomy using SINTAX algorithm
vsearch -sintax /scratch/aubbxs/noel_files/EVSMITH/workflow/clustered/otus.fasta -db ~/noel_shared/db_bacteria/SILVA_138.1_SSURef_NR99_tax_silva_newheaders.fasta -tabbedout /scratch/aubbxs/noel_files/EVSMITH/workflow/taxonomy/16s_taxonomy.txt -strand both -sintax_cutoff 0.8 
