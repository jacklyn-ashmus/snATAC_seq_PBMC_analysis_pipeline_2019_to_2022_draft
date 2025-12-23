suppressPackageStartupMessages(library(cicero))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(parallel))

args<-commandArgs(TRUE)

print("         get arguments from command line:")      
matrixFile = args[1]
barfile = args[2]
peaksfile = args[3]
metafile = args[4]
clusterColName = args[5]
outputFilePrefix = args[6]

print(paste0("               1. matrixFile = ", matrixFile))
print(paste0("               2. barfile = ", barfile))
print(paste0("               3. peaksfile = ", peaksfile))
print(paste0("               4. metafile = ", metafile))
print(paste0("               5. clusterColName = ", clusterColName))
print(paste0("               6. outputFilePrefix = ", outputFilePrefix))

print("         set seed cluster")
clus <- makeCluster(32)



print("         set output names:")
out_rds_input_tableSuffix = '.inputDataTable.rds'
out_rds_cellinfo_tableSuffix = '.cellInfoTable.rds'
out_rds_dhsinfo_tableSuffix = '.dhsinfoTable.rds'
out_rds_umap_tableSuffix = '.umapTable.rds'
outRdsConnsSuffix = '.1MB_cicero_conns.rds'
outConnsSuffix = '.cicero_conns.txt'
outConnsDedupSuffix = '.cicero_conns_dedup.txt'

outputDedupeConnsName = paste0(outputFilePrefix, outConnsDedupSuffix)
outputConnsName = paste0(outputFilePrefix, outConnsSuffix)
output_conns_RDS_Name = paste0(outputFilePrefix, outRdsConnsSuffix)
output_cellinfo_RDS_Name = paste0(outputFilePrefix, out_rds_cellinfo_tableSuffix)
output_dhsinfo_RDS_Name = paste0(outputFilePrefix, out_rds_dhsinfo_tableSuffix)
output_input_table_RDS_Name = paste0(outputFilePrefix, out_rds_input_tableSuffix)
output_umap_RDS_Name = paste0(outputFilePrefix, out_rds_umap_tableSuffix)

print(paste0("               1. input_table rds file = ", output_input_table_RDS_Name))
print(paste0("               2. cellinfo rds file = ", output_cellinfo_RDS_Name))
print(paste0("               3. dhsinfo rds file = ", output_dhsinfo_RDS_Name))
print(paste0("               4. umap rds file = ", output_umap_RDS_Name))
print(paste0("               5. conns rds file = ", output_conns_RDS_Name))
print(paste0("               6. output connections file name = ", outputConnsName))
print(paste0("               7. output dedupe connections file name = ", outputDedupeConnsName))


print("         read metadata table")
sc.umap <- read.table( metafile, header=T, row.names=1)

print("         read market matrix file")
sc.data <- readMM(matrixFile)

print("         read peaks file")
peaks <- read.table(peaksfile, header=F)

print("         read barcodes file")
barcodes <- read.table(barfile, header=F)


print("         set counts dataframe row names , column names")
colnames(sc.data) <- paste0('chr', gsub('-','_', gsub(':','_',peaks[,1])))
rownames(sc.data) <- barcodes[,1]



print("         flip counts dataframe")
sc.data <- t(sc.data)

print("         makes cellinfo dataframe")
cellinfo <-data.frame(cells=colnames(sc.data))
cellinfo <- cbind(cellinfo, sc.umap[c(clusterColName,'log10_unique_usable_reads')])
row.names(cellinfo) <- cellinfo$cells
colnames(cellinfo) <- c('cells', 'cluster','log10_n_counts')



print("         makes dhsinfo dataframe")
dhsinfo <- data.frame(site_name=rownames(sc.data))
dhsinfo <- cbind(dhsinfo, stringr::str_split_fixed(dhsinfo$site_name, "_", 3))
row.names(dhsinfo) <- dhsinfo$site_name
names(dhsinfo) <- c('site_name','chr','bp1','bp2')
dhsinfo$chr <- gsub('chr','', dhsinfo$chr)
dhsinfo$bp1 <- as.numeric(as.character(dhsinfo$bp1))
dhsinfo$bp2 <- as.numeric(as.character(dhsinfo$bp2))

print("         makes umap_coords dataframe")
umap_coords <- sc.umap[colnames(sc.data), c('UMAP1','UMAP2')]
colnames(umap_coords) <- NULL



print("         save input_table rds")
saveRDS(sc.data, output_input_table_RDS_Name)

print("         save cellinfo rds")
saveRDS(cellinfo, output_cellinfo_RDS_Name)

print("         save dhsinfo rds")
saveRDS(dhsinfo, output_dhsinfo_RDS_Name)

print("         save umap_coords rds")
saveRDS(umap_coords, output_umap_RDS_Name)

print("")
print("")
print("         making input_cds")
input_cds <- suppressWarnings(newCellDataSet(as(sc.data, 'dgCMatrix'),
                            phenoData = methods::new('AnnotatedDataFrame', data = cellinfo),
                            featureData = methods::new('AnnotatedDataFrame', data = dhsinfo),
                            expressionFamily=negbinomial.size(),
                            lowerDetectionLimit=0))

print("         filter input_cds")
input_cds@expressionFamily <- binomialff()
input_cds@expressionFamily@vfamily <- 'binomialff'
input_cds <- detectGenes(input_cds)
input_cds <- estimateSizeFactors(input_cds)
input_cds <- input_cds[fData(input_cds)$num_cells_expressed > 0,]



print("")
print("")
print("         make cicero_cds")
cicero_cds <- make_cicero_cds(input_cds, reduced_coordinates = umap_coords, k=30)
print("")
print("")



print("")
print("")
window <- 1e6
data('human.hg19.genome')
print("         estimate_distance_parameter")
distance_parameters <- estimate_distance_parameter(cicero_cds, window=window, maxit=100, sample_num=100, distance_constraint=500000, genomic_coords=human.hg19.genome)
mean_distance_parameter <- mean(unlist(distance_parameters))
print("")
print("")



print("")
print("")
print("         generate_cicero_models")
cicero_out <- generate_cicero_models(cicero_cds, distance_parameter=mean_distance_parameter, window=window, genomic_coords=human.hg19.genome)
conns <- assemble_connections(cicero_out, silent=FALSE)
print("")
print("")

print("         save conns rds")
saveRDS(conns, output_conns_RDS_Name)
print("         save connections file")
write.table(conns, outputConnsName, sep='\t', quote=FALSE, row.names=FALSE)   

print("        filter connections:")
print("                 remove duplicated connections")
conns = conns[order(-conns$coaccess),]
print("                 bed = cbind")
bed = cbind(str_split_fixed(conns[,1], "\\_", 3 ), str_split_fixed(conns[,2], "\\_", 3 ))
    #### mistake here because the order was not numeric ### must fix it
print("                 ord = matrix")
ord = matrix(parRapply(clus, bed, function(x) x[order(x)] ), ncol=6, byrow=T)
print("                 ord = cbind")
ord = cbind(ord[, c(5,1:2,5,3:4)], conns$coaccess)
print("                 dedup = ord[!duplicated")
dedup = ord[!duplicated(ord),]

print("                 dedup = data.frame")
dedup = data.frame( Peak1 = paste(dedup[,1], dedup[,2], dedup[,3], sep="_")  , 
                    Peak2 = paste(dedup[,4], dedup[,5], dedup[,6], sep="_") , coaccess = dedup[,7]  )

                       
                       
print("        write.table dedupe connections file")
write.table(dedup, outputDedupeConnsName, sep='\t', quote=FALSE, row.names=FALSE)    
                       
print("        DONE!")
                       
