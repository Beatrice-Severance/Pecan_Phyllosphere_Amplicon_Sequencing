# Pecan_Phyllosphere_Amplicon_Sequencing
Pipelines encompassing ITS and 16S community profiling for the pecan (Carya illinoinensis) phyllosphere, starting from demultiplexed reads. The scripts in this pipeline were originally run on the Alabama supercomputer and thus might make reproducibility difficult for users who do not utilize this system. The Alabama supercomputer recently shifted from DMC to ASAX. Currently, users can utilize the ASAX scripts to perform data processing, and these will be linked throughout the README file below. For reference, the DMC scripts previously used are linked here. Scripts for this pipeline are grouped in a folder along with the sample files from 2021 and 2022 leaf sequences extracted from pecan trees at the E.V. Smith facility in Alabama. The Alabama HPC utilizes a slurm queue system where jobs are submitted and run.

# Fungal ITS Profiling

## Creating a Samples File
In order for loops to be performed throughout the pipeline, a file was created to help the computer quickly identify files and how to rename them. This shortens sequence files from looking like this:
```
132BFT6_S134_L001_R1_001.fastq.gz
112CCT1_S186_L001_R1_001.fastq.gz
112CCT2_S157_L001_R1_001.fastq.gz
112CCT3_S266_L001_R1_001.fastq.gz
```
to this
```
132BFT6_S134
112CCT1_S186
112CCT2_S157
112CCT3_S266
```

## Strip Primers
This is a loop script that will remove primers that may be included in the demultiplexed reads. The sample files will be used in this step. Only forward (R1) reads are used in this fungal pipeline because ITS1 is the region of interest. The primer for this region is:
- CTTGGTCATTTAGAGGAAGTAA

## Combine Data
Before running statistics and filtering, it is necessary to combine the trimmed data from both the previous step. Stripped FASTQ files (*_trimmed.fastq) are concatenated into one file, trimmed_combined.fastq.

## Run Statistics
This is a script that uses VSEARCH to run statistics on the trimmed_combined.fastq file. Stats can be viewed to determine filtering parameters.

## Filter
This is a script that utilizes VSEARCH to filter out bad quality reads from the trimmed_combined.fastq file. Parameters are set at an e-value of 1.0 and a length of 263bp, parameters determined from the previous statistics step. The left side of the sequences are trimmed by 44 bases with the -fastq_stripleft command. FastQC is run on the data to provide statistics. Users can determine whether they need to filter further based on the results.

## Cluster
This is a script that utilizes VSEARCH to dereplicate, and USEARCH to cluster and remove chimeras.
- De-noising step will provide zero-radius OTUs (zOTUs).
- Clustering will provide OTUs based on traditional 97% identity.
- USEARCH is a program that is utilized for the de-noising and clustering steps. For more information on these programs the following links can be used:
- [UPARSE vs. UNOISE](http://www.drive5.com/usearch/manual/faq_uparse_or_unoise.html)
- [otutab command](http://www.drive5.com/usearch/manual/cmd_otutab.html)
- [Sample identifiers in read labels](http://www.drive5.com/usearch/manual/upp_labels_sample.html)
- [Bugs and fixes for USEARCH v11](http://drive5.com/usearch/manual/bugs.html)
- [Technical support](http://drive5.com/usearch/manual/support.html) 

### NBC Taxonomy
This script requires the R script [dada2_assigntax_NBC.R](https://github.com/Beatrice-Severance/Fungal-Amplicon-Sequencing/blob/main/ASAX_Scripts/dada2_assigntax_NBC.R) which will use the database provided to create taxonomy based on the NBC algorithm. This script requires a large amount of memory in order to run, so should be taken into account when attempting to replicate this pipeline. 1 core and 32gb of memory produced parallel efficiency of 99.37% and memory efficiency of 60.63%. The script creates an .rds file which will allow users to view the taxonomy in R or RStudio. The database that was used for this script is located [here](https://doi.plutof.ut.ee/doi/10.15156/BIO/2483914). The following release was used for analysis: 29.11.2022
Mock sequences in NBC format can be found [here](https://github.com/Beatrice-Severance/Fungal-Amplicon-Sequencing/blob/main/Mock_Sequences/mocksequencesNBC.txt).

### SINTAX Taxonomy
This script utilizes the SINTAX algorithm to create a fungal taxonomy. VSEARCH is the medium used to achieve this goal. The database that was used for this script is located [here](https://doi.plutof.ut.ee/doi/10.15156/BIO/2483924). The following release was used for analysis: 29.11.2022
Mock sequences in SINTAX format can be found [here](https://github.com/Beatrice-Severance/Fungal-Amplicon-Sequencing/blob/main/Mock_Sequences/mocksequencesSINTAX.txt).

##
Combined, these steps provide the following output files that can be utilized in a phyloseq object in R:
- [OTU table](https://github.com/Beatrice-Severance/Fungal-Amplicon-Sequencing/blob/main/EV_21-22/EV_21-22_phyloseq_input/otu.table.csv)
- ITS taxonomy files (from SINTAX and [NBC](https://github.com/Beatrice-Severance/Fungal-Amplicon-Sequencing/blob/main/EV_21-22/EV_21-22_phyloseq_input/NBC.csv))
- [otus.fasta](https://github.com/Beatrice-Severance/Fungal-Amplicon-Sequencing/blob/main/EV_21-22/EV_21-22_phyloseq_input/otus_R1.fasta) file

## R Analysis: Fungi
R Analysis for this project starts with the creation of a phyloseq object. In addition to the files above, a [metadata](https://github.com/Beatrice-Severance/Fungal-Amplicon-Sequencing/blob/main/EV_21-22/EV_21-22_phyloseq_input/21-22_Metadata.csv) file will be necessary to run analysis. The [R Markdown file](https://github.com/Beatrice-Severance/Fungal-Amplicon-Sequencing/blob/main/EV_21-22/EV_21-22_Fungi.Rmd) will execute the following steps:
- Load dependencies
  - Dependencies used for analysis:
    - phyloseq [version 1.44.0](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0061217#s6) 
    - vegan [version 2.6-4](https://github.com/vegandevs/vegan/releases/tag/v2.6-4)
    - tidyverse [version 2.0.0](https://github.com/tidyverse/tidyverse/releases/tag/v2.0.0)
    - ggplot2 [version 3.4.2](https://cloud.r-project.org/web/packages/ggplot2/index.html)
    - Biostrings [version 2.68.1](https://bioconductor.org/packages/release/bioc/html/Biostrings.html)
    - ggpubr [version 0.6.0](https://cran.r-project.org/web/packages/ggpubr/index.html)
    - decontam [version 1.20.0](https://github.com/benjjneb/decontam)
    - metagenomeSeq [version 1.42.0](https://github.com/HCBravoLab/metagenomeSeq)
    - indicspecies [version 1.7.14](https://cran.r-project.org/web/packages/indicspecies/index.html)
- Utilize a colorblind palette
- Load in [files](https://github.com/Beatrice-Severance/Fungal-Amplicon-Sequencing/tree/main/EV_21-22/EV_21-22_phyloseq_input) to create a phyloseq object
- Decontaminate samples 
  - Take out controls
  - Remove low-quality reads (<5000)
  - Subset to kingdom Fungi
- Provide read distribution for the dataset, including a histogram
- Rarefaction analysis, including line graphs
- Alpha diversity analysis
  - Shannon
  - Inverse Simpson
  - Richness
- Cumulative sum scaling (CSS) Normalization
- Beta diversity analysis
  - Principal coordinates analysis (PCoA) plot with Bray-Curtis distances
- PERMANOVA to test for differences in centroids

# Bacterial 16S Profiling

## Merging Reads
This is a loop script that will merge forward and reverse reads from a set of samples. The file "samples.txt" includes sample identifiers to run this script.

## Stripping Primers
This is a loop script that will remove primers that may be included in the output from the merging reads step. The "samples.txt" file will be used in this step as well.
Linked primers are used because the 300 bp demultiplexed reads likely span the entire amplicon, and it is expected that both primers might be in the forward and reverse reads. The primers used in this code are:
- 515F = GTGCCAGCMGCCGCGGTAA RC-515R = TTACCGCGGCKGCTGGCAC
- 806R = GGACTACHVGGGTWTCTAAT RC-806R = ATTAGAWACCCBDGTAGTCC

## Run Statistics
This is a script that allows users to view some statistics on their dataset. If data is consistent with what users are expecting, the pipeline can be continued.

## Filter
This is a script that will filter out bad quality reads from the previous step. Parameters are set at an e-value of 0.5 and a length of 250bp. Parameters can be edited based on user needs.

## Cluster
This is a script that can dereplicate, cluster, and remove chimeras. Dereplication and clustering were performed from the original code. Denoising was commented out, but can be run if necessary for user's purpose.
- De-noising step will provide zero-radius OTUs (zOTUs).
- Clustering will provide OTUs based on traditional 97% identity.
- USEARCH is a program that is utilized for the de-noising and clustering steps. For more information on these programs the following links can be used:
- [UPARSE vs. UNOISE](http://www.drive5.com/usearch/manual/faq_uparse_or_unoise.html)
- [otutab command](http://www.drive5.com/usearch/manual/cmd_otutab.html)
- [Sample identifiers in read labels](http://www.drive5.com/usearch/manual/upp_labels_sample.html)
- [Bugs and fixes for USEARCH v11](http://drive5.com/usearch/manual/bugs.html)
- [Technical support](http://drive5.com/usearch/manual/support.html)

## Mapping
This is a script that will create an OTU table that can be used for further downstream analysis. A [Python script](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/Scripts/replacefastaheaders_filename.py) is used to edit filenames so that headers are appropriate for this analysis. The mapping script utilizes the input from the merge reads step and aligns these reads back to the clustered OTUs or zOTUs.

## Taxonomy
This is a script that utilizes the SINTAX algorithm to create a taxonomy for the otus.fasta file created in the clustering step. The SINTAX algorithm is used because it predicts taxonomy for marker genes like 16S.

##
Combined, these steps should provide output files that can be utilized in a phyloseq object in R.

## R Analysis: Bacteria
R analysis begins by creating a phyloseq object. Before beginning, ensure that you have the following files downloaded and in an appropriate directory so that R can utilize them:
- [otu_table_16s.csv](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/phyloseq_input/otu_table_16s.csv)
- [16s_taxonomy.csv](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/phyloseq_input/16s_taxonomy.csv)
- [metadata2021.csv](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/phyloseq_input/metadata2021.csv)
- [otus.fasta](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/phyloseq_input/otus.fasta)

The [R markdown file](https://github.com/Beatrice-Severance/Bacteria-Amplicon-Sequcencing/blob/main/Scripts/Phyloseq_Analysis.Rmd) will execute the following steps:
- Load Dependencies
- Utilize a colorblind palette
- Load the above files to create a phyloseq object
- Remove mitrochondria, chloroplasts, or taxa not assigned at domain level
- Decontaminate the data
- Provide read distribution for the dataset (including a histogram)
- Rarefaction analysis (including line graphs)
- Alpha diversity analysis, including "richness over time" and "richness over treatment" plots
- Cumulative sum scaling (CSS) Normalization
- Beta diversity analysis, including a principal coordinates analysis (PCoA) plot with Bray-Curtis distances and a detrended correspondence analysis (DCA, to eliminate time as a factor)
- PERMANOVA to test for differences in centroids