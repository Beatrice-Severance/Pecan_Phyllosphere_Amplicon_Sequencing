#!/bin/bash 

############################################
#     Bioinformatic pipeline               #
#     R analysis ANCOM      	           #
#   Differential abundance test		   #
# To run this script you must edit the ancom_v2.1.R script to the appropriate variables    #
############################################ 

source /apps/profiles/modules_asax.sh.dyn
module load R/4.1.0

R CMD BATCH dada2_assigntax_NBC.R
