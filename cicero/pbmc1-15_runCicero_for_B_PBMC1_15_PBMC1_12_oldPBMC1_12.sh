#!/usr/bin/env bash

fine_pops=( naive_cd8_t plasma adaptive_NK ncMono cyto_cd8_t mem_b naive_b tReg cDC cyto_nk  mem_cd8_t naive_cd4_t  pDC)
broad_pops=(b cd4_t cd8_t mono nk cd4_AND_cd8_t)
chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
#!/usr/bin/env bash

RSCRIPT_NAME=/nfs/lab/jnewsome/scripts/cicero/pbmc_cicero_old_pbmc1-12/run_Cicero_oldPipeline.r
pops=(act_cd4_t cd4_AND_cd8_t cDC cyto_nk mem_cd8_t naive_b ncMono plasma adaptive_NK cd4_t cMono iMono mkc naive_cd4_t nk tReg b cd8_t cyto_cd8_t mem_b mono naive_cd8_t pDC)
chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
samples=(pbmc1 pbmc2 pbmc3 pbmc4 pbmc5 pbmc6 pbmc8 pbmc9 pbmc10 pbmc12 pbmc13 pbmc14 pbmc15)


inDir_chromsort=/nfs/lab/jnewsome/pbmc/cicero_v3/lft_mtx_origCode/
inDir_lftMtx_chrom=/nfs/lab/jnewsome/pbmc/cicero_v3/intersect_tag_mergedBareBed_lessCol_mergePeaks/
inDir_meta_chrom=/nfs/lab/jnewsome/pbmc/split_cicero_2/splitMeta/cellSplit/
outDir_cicero_chrom=/nfs/lab/jnewsome/pbmc/cicero_v4/conns/
lftmtxSortSuffix=.mergedBedIntersect.mergedCounts.sort.lft.mtx
samplePrefix=pbmc1-15.


mkdir=${outDir_cicero_chrom}
mkdir="${outDir_cicero_chrom}/log"

# pbmc1-15.b.chr10.mergedBedIntersect.mergedCounts.sort.lft.mtx





pbmc1_15_lft_mtx_Prefix="${inDir_chromsort}pbmc1-15."
pbmc1_15_lft_mtx_Suffix=.lft_mtx.mtx

# pbmc1_15_logDir=

# pbmc1_15_metadataFile_Prefix=
# pbmc1_15_metadataFile_Suffix=



# pbmc1_15_metadataFile_Prefix=
# pbmc1_15_metadataFile_Suffix=


pbmc1_12_lft_mtx_Prefix=/nfs/lab/jnewsome/pbmc/cicero_v3/lft_mtx_origCode/pbmc1_12/pbmc1_12.new.
pbmc1_12_lft_mtx_Suffix=.lft_mtx.mtx

# pbmc1_12_logDir=
pbmc1_12_out_prefix=/nfs/lab/jnewsome/pbmc/cicero_v4/conns_pbmc1_12/pbmc1_12.new.
# pbmc1_12_lft_mtx_Suffix=



# pbmc1_12_old_lft_mtx_Prefix=
# pbmc1_12_old_lft_mtx_Suffix=











# N=22
# cell=b
# for chr in ${chroms[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#         dt=$(date '+%d/%m/%Y %H:%M:%S');
#         echo "run cicero  $cell $chr        $dt"
        
#         lft_mtx_file="${inDir_lftMtx_chrom}pbmc1-15.${cell}.chr${chr}${lftmtxSortSuffix}"  # pbmc1-15.iMono.chr4.sort.lf_mtx
#         metafile="${inDir_meta_chrom}pbmc1-15.${cell}.metadata.txt" # pbmc1-15.mem_b.metadata.txt
#         outputFilePrefix="${outDir_cicero_chrom}pbmc1-15.${cell}.chr${chr}"
# #         logFile="${outDir_cicero_chrom}log/pbmc1-15.${cell}.chr${chr}.log"
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
#         # matrixFile = args[1]
        
        
        
#         # metafile = args[2]
#         # outputFilePrefix = args[3]
#         /usr/lib64/R/bin/Rscript ${RSCRIPT_NAME} ${lft_mtx_file} ${metafile}  ${outputFilePrefix} 2>&1 | tee ${logFile}
    
#     ) &

# done












N=22
cell=b
for chr in ${chroms[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "run cicero  $cell $chr        $dt"
        
        lft_mtx_file="${pbmc1_12_lft_mtx_Prefix}${cell}.chr${chr}${pbmc1_12_lft_mtx_Suffix}"  # pbmc1-15.iMono.chr4.sort.lf_mtx
        metafile=/nfs/lab/jnewsome/pbmc/split_cicero_2/splitMeta/cellSplit/pbmc1-12.b.metadata.txt
 # pbmc1-15.mem_b.metadata.txt
        outputFilePrefix="${pbmc1_12_out_prefix}${cell}.chr${chr}"
#         logFile="${outDir_cicero_chrom}log/pbmc1-15.${cell}.chr${chr}.log"
        
        
        
        
        
        # matrixFile = args[1]
        
        
        
        
        
        
        
        
        
        # metafile = args[2]
        # outputFilePrefix = args[3]
        /usr/lib64/R/bin/Rscript ${RSCRIPT_NAME} ${lft_mtx_file} ${metafile}  ${outputFilePrefix} 2>&1 | tee ${logFile}
    
    ) &

done












exit 0
