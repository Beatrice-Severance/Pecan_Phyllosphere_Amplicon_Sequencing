#!/bin/bash

############################################
#     Bioinformatic pipeline               #
#     16S amplicon sequences               #
#            MAPPING                       #
############################################

# First use seqtk to convert all the merged reads into fasta on a loop.
# Use samples.txt like we did for cutadapt

# Load the modules
module load gcc/11.2.0
module load seqtk/1.3-olt7cls
source /apps/profiles/modules_dmc.sh.dyn
module load python/3.3.2
module load anaconda/3-2023.03

#mkdir /scratch/aubbxs/noel_files/EVSMITH/workflow/mapped

for sample in $(cat samples.txt)
do

    echo "On sample: $sample"
    seqtk seq -a /home/aubbxs/noel_shared/Demultiplexed_2022-05-04_PecanSpermosphere_Bacteria_MigsOrder9721/${sample}*.fastq.gz > ${sample}.fasta
    
# We have to replace the beginning of the fasta headers with the file name for mapping. Otherwise we get one sample with all the read counts, which is not what we want. 
# We use a python script to append the filename so that headers are appropriate for analysis in R. 

    python3 ~/noel_shared/python_scripts/replacefastaheaders_filename.py ${sample}.fasta

done

# have to create one file containing all the reads from the demultiplexed reads
cat /home/aubbxs/noel_work/EVSMITH/bacteria/bacteria_workflow_2021/merged/*_new.fasta > /home/aubbxs/noel_work/EVSMITH/bacteria/bacteria_workflow_2021/merged/merged_new1.fasta

# align the demultiplexed reads back to the now clustered OTUs or ZOTUs (ESV)
module load anaconda/3-2021.11
module load vsearch
module load usearch
vsearch -usearch_global /home/aubbxs/noel_work/EVSMITH/bacteria/bacteria_workflow_2021/merged/merged_new1.fasta -db /home/aubbxs/noel_work/EVSMITH/bacteria/bacteria_workflow_2021/clustered/otus.fasta -strand plus -id 0.97 -otutabout /home/aubbxs/noel_work/EVSMITH/bacteria/bacteria_workflow_2021/mapped/otu_table_16s.txt

