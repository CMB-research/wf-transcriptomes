devtools::install_version("dbplyr", version = "2.3.4")
library(biomaRt)

input_path <- "results_dge.tsv"
output_path <- "results_dge_symbols.tsv"

genes_new <- read.table(path)
mart <- useDataset("hsapiens_gene_ensembl", useMart("ensembl"))
G_list <- getBM(filters= "ensembl_gene_id",
                attributes= c("hgnc_symbol", "ensembl_gene_id"),
                values=genes_new|>rownames(),
                mart= mart,
                uniqueRows = F,
                useCache = F)

out_i <- genes_new|>rownames()|>match(G_list$ensembl_gene_id)
# out_i|>length()
# genes_new|>rownames()|>length()

genes_new$Symbol <- G_list$hgnc_symbol[out_i]
write.table(genes_new, file = output_path, sep="\t")
