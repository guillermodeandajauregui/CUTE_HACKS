library(biomaRt)
library(tidyverse)
library(vroom)

#some random genes in ensembel gene id
x <- c("ENSG00000141510", "ENSG00000130203", "ENSG00000111640", "ENSG00000232810", "ENSG00000146648")

#use this genome database
ensembl <- useEnsembl(biomart = "ensembl", 
                      dataset = "hsapiens_gene_ensembl", 
                      mirror = "useast")


# get the genome data 
mi_bm <- 
    getBM(attributes = c('entrezgene_id', 'ensembl_gene_id', 'ensembl_gene_id_version', "hgnc_id", "hgnc_symbol", "gene_biotype"), # the things you wanna get
      filters = 'ensembl_gene_id', #the type of identifier that you got 
      values = x, 
      mart = ensembl)


vroom_write(mi_bm, file = "my_biomart_dictionary.txt")
