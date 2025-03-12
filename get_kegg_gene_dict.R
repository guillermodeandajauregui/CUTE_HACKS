# Load libraries ----
library(tidyverse)
library(httr)

# Define output directory ----
output_dir <- "~/DATA/KEGG"  # Change this based on the machine
o_file     <- paste0("kegg_to_entrez_", Sys.Date(), ".txt")
output_file <- file.path(output_dir, o_file)


# Download KEGG Gene ID to Entrez Gene ID conversion table ----
url <- "https://rest.kegg.jp/conv/ncbi-geneid/hsa"
response <- GET(url)

# Parse response and convert to a tibble ----
kegg_entrez_data <- 
  content(response, "text") |>
  str_split("\n") |>
  unlist() |>
  as_tibble() |>
  filter(value != "") |>
  separate(value, into = c("kegg_id", "entrez_id"), sep = "\t") |>
  mutate(
    kegg_id_sans  = str_remove(kegg_id, "hsa:"),  # Remove 'hsa:' prefix
    entrez_id_sans = str_remove(entrez_id, "ncbi-geneid:")  # Remove 'ncbi-geneid:' prefix
  )

# Save the mapping to a TXT file ----
write_tsv(kegg_entrez_data, output_file)

# Preview the first few rows ----
head(kegg_entrez_data)
