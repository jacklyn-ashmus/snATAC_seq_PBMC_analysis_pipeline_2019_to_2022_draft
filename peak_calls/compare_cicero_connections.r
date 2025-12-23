suppressPackageStartupMessages(library(cicero))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(parallel))
library(stringr)



args<-commandArgs(TRUE)

# print("         get arguments from command line:")      
connsFile1 = args[1]
connsFile2 = args[2]
outfilename = args[3]




newConns <- read.table( connsFile1, header=T)

oldConns <- read.table( connsFile2, header=T)

myvars <- c("Peak1", "Peak2", "coaccess")
oldConns <- oldConns[myvars]
myvars <- c("Peak1", "Peak2", "coaccess")
newConns <- newConns[myvars]



newConns$in_oldData <- compare_connections(newConns[,1:3], oldConns[,1:3])


newConns$start <- str_split_fixed(newConns$Peak1, "_", 3)[,2]
newConns$end <- str_split_fixed(newConns$Peak1, "_", 3)[,3]
# newConns$end <- str_split_fixed(newConns$Peak1, "_", 3)[3] , newConns$start, newConns$end 


newConns$diff <- as.numeric(as.character(newConns$end)) - as.numeric(as.character(newConns$start )) 


newConns$in_oldData <- compare_connections(newConns, oldConns)


write.table(newConns, outfilename, sep='\t', quote=FALSE, row.names=FALSE)    
      


