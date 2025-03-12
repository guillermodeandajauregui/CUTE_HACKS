# Load libraries (biomaRt first!) ----
library(biomaRt)
library(tidyverse)

# Define output file ----
output_dir <- "~/DATA/BIOMART"  # Change this manually if needed
o_file     <- paste0("biomart_gene_dict_", Sys.Date(), ".txt")
output_file <- file.path(output_dir, o_file)

# Connect to Ensembl Biomart ----
mart <- 
  useMart("ensembl", dataset = "hsapiens_gene_ensembl")

# Retrieve gene mapping (Entrez → HGNC → Ensembl) ----
biomart_data <- 
  getBM(
    attributes = c("entrezgene_id", "hgnc_id", "hgnc_symbol", "ensembl_gene_id"),
    mart = mart
  )

biomart_data <- 
  biomart_data |> 
  as_tibble()

# Save the mapping to a TXT file ----
write_tsv(biomart_data, output_file)

# Preview the first few rows ----
head(biomart_data)
