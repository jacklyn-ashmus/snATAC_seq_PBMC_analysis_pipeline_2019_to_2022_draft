suppressPackageStartupMessages(library(cicero))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(parallel))
suppressPackageStartupMessages(library(tidyr))

clus <- makeCluster(32)

args<-commandArgs(TRUE)

####### Args ############
print('     read args')
cell <- args[1]
prefix1 <- args[2]
wd <- args[3]
umapFile <- args[4]
input_mat <- args[5]


setwd(wd)

#### set names
prefix <- paste0(wd, 'islet_mult.')
out_prefix <- paste0(prefix, cell)

########### MAIN #################

# Read input matrix
print('     read matrix file')
data    = read.table( input_mat ,header=T,  sep="\t")
colnames(data) <- c('peak', 'barcode', 'value')
# read umap file
print('     read umap file')
sc.umap = read.table( umapFile, header=T, row.names=1,  sep="\t") ### map barcode to cluster 




### convert to sparse matrix peak x barcode
print('      convert to sparse matrix peak x barcode')
sc.data <- with(data, sparseMatrix(i=as.numeric(as.factor(peak)), j=as.numeric(as.factor(barcode)), 
                                   x=value, dimnames=list(levels(as.factor(peak)), levels(as.factor(barcode)))))
rownames(sc.data) <- paste0('chr', gsub('-','_', gsub(':','_',rownames(sc.data))))
sc.data.subset <- sc.data

print('      cellinfo')
cellinfo <-data.frame(cells=colnames(sc.data.subset))
row.names(cellinfo) <- cellinfo$cells
dhsinfo <- data.frame(site_name=rownames(sc.data.subset))
row.names(dhsinfo) <- dhsinfo$site_name
dhsinfo <- cbind(dhsinfo, stringr::str_split_fixed(dhsinfo$site_name, "_", 3))
names(dhsinfo) <- c('site_name','chr','bp1','bp2')
dhsinfo$chr <- gsub('chr','', dhsinfo$chr)
dhsinfo$bp1 <- as.numeric(as.character(dhsinfo$bp1))
dhsinfo$bp2 <- as.numeric(as.character(dhsinfo$bp2))


print('      newCellDataSet input_cds')
input_cds <- suppressWarnings(newCellDataSet(as(sc.data.subset, 'dgCMatrix'),
                                             phenoData = methods::new('AnnotatedDataFrame', data = cellinfo),
                                             featureData = methods::new('AnnotatedDataFrame', data = dhsinfo),
                                             expressionFamily=negbinomial.size(),
                                             lowerDetectionLimit=0))


print('      estimateSizeFactors input_cds')
input_cds@expressionFamily <- binomialff()
input_cds@expressionFamily@vfamily <- 'binomialff'
input_cds <- detectGenes(input_cds)
input_cds <- estimateSizeFactors(input_cds)


print('      umap_coords input_cds')
input_cds <- input_cds[fData(input_cds)$num_cells_expressed > 0,]
umap_coords <- sc.umap[colnames(sc.data.subset), c('wnn_UMAP1','wnn_UMAP2')]
colnames(umap_coords) <- NULL


print('      make_cicero_cds ')
cicero_cds <- make_cicero_cds(input_cds, reduced_coordinates = umap_coords, k=30)
window <- 1e6
data('human.hg19.genome')
print('      estimate_distance_parameter ')
distance_parameters <- estimate_distance_parameter(cicero_cds, window=window, maxit=100, sample_num=100, distance_constraint=500000, genomic_coords=human.hg19.genome)
mean_distance_parameter <- mean(unlist(distance_parameters))

print('      generate_cicero_models ')
cicero_out <- generate_cicero_models(cicero_cds, distance_parameter=mean_distance_parameter, window=window, genomic_coords=human.hg19.genome)
conns <- assemble_connections(cicero_out, silent=FALSE)



print('      dedupe ')
#saveRDS(conns, file.path(wd, paste0('cicero/', cluster, '.1MB_cicero_conns.rds')))
#write.table(conns, file.path(wd, paste0('output/', celltype, '.cicero_conns_dedup.txt')), sep='\t', quote=FALSE, row.names=FALSE)

## this step is to remove duplicated connections
conns = conns[order(-conns$coaccess),]
bed = cbind(str_split_fixed(conns[,1], "\\_", 3 ), str_split_fixed(conns[,2], "\\_", 3 ))

ord = matrix(parRapply(clus, bed, function(x) x[order(as.numeric(x))] ), ncol=6, byrow=T)

ord = cbind(ord[, c(5,1:2,5,3:4)], conns$coaccess)
dedup = ord[!duplicated(ord[,1:6]),]                      


############## dedupe wtvr


print('      dedupe wtvr ')
dist = as.numeric(dedup[,6])-as.numeric(dedup[,2])
dedup  = subset(dedup, dist >10000)
                       
dedup = data.frame( Peak1 = paste(dedup[,1], dedup[,2], dedup[,3], sep="_")  , 
                    Peak2 = paste(dedup[,4], dedup[,5], dedup[,6], sep="_") , coaccess = dedup[,7]  )


########### WRITE OUTPUTS
print('     WRITE OUTPUTS')
writeTableFile = paste0(out_prefix,  '.cicero_conns_dedup.txt')
writeSummaryFile = paste0(out_prefix,  '.summary')
write.table(dedup, writeTableFile, sep='\t', quote=FALSE, row.names=FALSE)



writeLines(c("tot_pairs", nrow(dedup),"coaccess", sum(as.numeric(dedup[,3])>0.05, na.rm=T))
           , writeSummaryFile)


print('     ...done')
                       