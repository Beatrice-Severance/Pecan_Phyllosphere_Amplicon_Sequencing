#!/bin/bash

# This script is run from the scripts directory in the scratch. It loops over the names in samples.txt. samples.txt should be in the scripts directory
# samples.txt is made by simply running the command ls > samples.txt then using nano and editing the last listed file since this is samples.txt

mkdir /scratch/aubbxs/noel_files/EVSMITH/workflow/merged

#  load the module
module load vsearch

for sample in $(cat samples.txt)
do

    echo "On sample: $sample"
	  vsearch -fastq_mergepairs ~/noel_shared/Demultiplexed_050422_PecanSpermosphere_Bacteria_MigsOrder9721/${sample}_R1_001.fastq.gz -reverse ~/noel_shared/Demultiplexed_050422_PecanSpermosphere_Bacteria_MigsOrder9721/${sample}_R2_001.fastq.gz -fastqout ${sample}_merged.fastq -fastq_maxdiffs 20
done
