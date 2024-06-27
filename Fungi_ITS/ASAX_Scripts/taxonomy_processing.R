#libraries
library(Biostrings)
library(dplyr)

# Load in otus.fasta
FASTA.fungi <- readDNAStringSet("/Users/beatr/Documents/College/Masters/Noel Lab/Fungal-Amplicon-Sequencing/GAUSDA/otus_R1.fasta", seek.first.rec=TRUE, use.names=TRUE)
FASTA.fungi.dataframe <- as.data.frame(FASTA.fungi)
FASTA.fungi.dataframe$OTU <- rownames(FASTA.fungi.dataframe)

# Load in NBCtaxa
NBC_taxonomy <- read.csv("/Users/beatr/Documents/College/Masters/Noel Lab/Fungal-Amplicon-Sequencing/GAUSDA/NBCtaxa.csv")
head(NBC_taxonomy)

# NBC taxonomy does not contain the OTUs associated with our sequences so we use the otus.fasta and taxonomy to align OTU# and sequence together in a column called OTU_sequence
NBC_taxonomy2 <- left_join(FASTA.fungi.dataframe, NBC_taxonomy, by = c("x"))
head(NBC_taxonomy2)

# Taxonomy 
#Edit the taxonomy file to remove unnecessary aspects. We clean the taxonomy table for ease of use.

nbc.tax.fungi <- as.data.frame(NBC_taxonomy2)

rownames(nbc.tax.fungi) <- nbc.tax.fungi$OTU
nbc.tax.fungi$Kingdom <- gsub('k__','', nbc.tax.fungi$Kingdom)
nbc.tax.fungi$Phylum <- gsub('p__','', nbc.tax.fungi$Phylum)
nbc.tax.fungi$Class <- gsub('c__','', nbc.tax.fungi$Class)
nbc.tax.fungi$Order <- gsub('o__','', nbc.tax.fungi$Order)
nbc.tax.fungi$Family <- gsub('f__','', nbc.tax.fungi$Family)
nbc.tax.fungi$Genus <- gsub('g__','', nbc.tax.fungi$Genus)
nbc.tax.fungi$Species <- gsub('s__','', nbc.tax.fungi$Species)
# here we replace the na with unidentified
nbc.tax.fungi <- replace(nbc.tax.fungi, is.na(nbc.tax.fungi), "unidentified")
#here we moved the unidentified to a column called lowest taxonomic rank
nbc.tax.fungi$Lowest_Taxnomic_Rank <- ifelse(nbc.tax.fungi$Phylum == "unidentified", nbc.tax.fungi$Kingdom,
                                             ifelse(nbc.tax.fungi$Class == "unidentified", nbc.tax.fungi$Phylum,
                                                    ifelse(nbc.tax.fungi$Order == "unidentified", nbc.tax.fungi$Class,
                                                           ifelse(nbc.tax.fungi$Family == "unidentified", nbc.tax.fungi$Order,
                                                                  ifelse(nbc.tax.fungi$Genus == "unidentified", nbc.tax.fungi$Family,
                                                                         ifelse(nbc.tax.fungi$Species == "unidentified", nbc.tax.fungi$Genus, 
                                                                                paste(nbc.tax.fungi$Genus, nbc.tax.fungi$Species, sep = "_")))))))

nbc.tax.fungi$Label <- paste(nbc.tax.fungi$OTU, nbc.tax.fungi$Lowest_Taxnomic_Rank, sep = "_")
#now since we want to use the NBC taxa.we picked out the mock communities from Syntax taxonomy and put them in OTU.mock. this way we can tell R which otus to look for when subtituting 
#the unidentified for mock

SINTAXa <- read.csv("/Users/beatr/Documents/College/Masters/Noel Lab/Fungal-Amplicon-Sequencing/GAUSDA/SINTAXtable.csv")

#basically what this is doing is putting both taxa(nbc and sintax together. So then we can  run below ifelse. we are basically saying "if nbc taxa OTU match the OTU from the sintax 
#substitute with the sintax taxa (which it the Mock) if its different do not change and leave it as it was (which is the nbc taxa).
mock.OTU <- SINTAXa[SINTAXa$Kingdom == "Mocki",]

nbc.tax.fungi0 <- left_join(nbc.tax.fungi, mock.OTU, by = "OTU")

OTU.mock <- mock.OTU$OTU

nbc.tax.fungi4 <- nbc.tax.fungi0
#BAsically here we are telling: if mocki otu is found in the nbc.tax.fungi subtitute with kingdom_sintax (that sintax is where the mock communities are found)
#and if its not a mock keep it the same as the nbc taxonomy.
nbc.tax.fungi4$Kingdom.x <- ifelse(nbc.tax.fungi4$OTU %in% OTU.mock, nbc.tax.fungi4$Kingdom.y, nbc.tax.fungi4$Kingdom.x)
nbc.tax.fungi4$Phylum.x <- ifelse(nbc.tax.fungi4$OTU %in% OTU.mock, nbc.tax.fungi4$Phylum.y, nbc.tax.fungi4$Phylum.x)
nbc.tax.fungi4$Class.x <- ifelse(nbc.tax.fungi4$OTU %in% OTU.mock, nbc.tax.fungi4$Class.y, nbc.tax.fungi4$Class.x)
nbc.tax.fungi4$Order.x <- ifelse(nbc.tax.fungi4$OTU %in% OTU.mock, nbc.tax.fungi4$Order.y, nbc.tax.fungi4$Order.x)
nbc.tax.fungi4$Family.x <- ifelse(nbc.tax.fungi4$OTU %in% OTU.mock, nbc.tax.fungi4$Family.y, nbc.tax.fungi4$Family.x)
nbc.tax.fungi4$Genus.x <- ifelse(nbc.tax.fungi4$OTU %in% OTU.mock, nbc.tax.fungi4$Genus.y, nbc.tax.fungi4$Genus.x)
nbc.tax.fungi4$Species.x <- ifelse(nbc.tax.fungi4$OTU %in% OTU.mock, nbc.tax.fungi4$Species.y, nbc.tax.fungi4$Species.x)

# getting rid of the sintax portion 
nbc.tax.fungi5 <- nbc.tax.fungi4 %>%
  select(OTU:Label)
rownames(nbc.tax.fungi5) <- nbc.tax.fungi5$OTU

# Check for unclassified (unidentified) OTUs and remove them
nbc.tax.fungi5 <- subset(nbc.tax.fungi5, Kingdom.x %in% c("Fungi", "Mocki"))
unique(nbc.tax.fungi5$Kingdom)

#The taxonomy modified and that you will use for there is this one "nbc.tax.fungi5"

TAX.fungi.NBC <- phyloseq::tax_table(as.matrix(nbc.tax.fungi5))



physeq_fungi_nonfilt <- phyloseq::phyloseq(OTU.fungi, TAX.fungi.NBC, FASTA.fungi, SAMP.fungi)

taxa_names(TAX.fungi.NBC)
