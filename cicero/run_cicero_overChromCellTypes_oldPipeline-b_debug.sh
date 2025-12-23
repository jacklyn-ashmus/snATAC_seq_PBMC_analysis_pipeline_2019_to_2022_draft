#!/usr/bin/env bash

RSCRIPT_NAME=/nfs/lab/jnewsome/scripts/cicero/pbmc_cicero_old_pbmc1-12/run_Cicero_oldPipeline.r
pops=(act_cd4_t cd4_AND_cd8_t cDC cyto_nk mem_cd8_t naive_b ncMono plasma adaptive_NK cd4_t cMono iMono mkc naive_cd4_t nk tReg b cd8_t cyto_cd8_t mem_b mono naive_cd8_t pDC)
chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
samples=(pbmc1 pbmc2 pbmc3 pbmc4 pbmc5 pbmc6 pbmc8 pbmc9 pbmc10 pbmc12 pbmc13 pbmc14 pbmc15)


inDir_meta_chrom=/nfs/lab/jnewsome/pbmc/split_cicero_2/splitMeta/cellSplit/

outDir_cicero_chrom=/nfs/lab/jnewsome/pbmc/cicero_v3/debug/cicOut/


lftmtxSortPrefix=/nfs/lab/jnewsome/pbmc/cicero_v3/intersect_tag_mergedBareBed_lessCol_sort2/pbmc1-15.
lftmtxSortSuffix=.mergedBedIntersect.LessCol.sort.lft.mtx



logdir="${outDir_cicero_chrom}log/"
mkdir $logdir


lftmtxSortSuffix=.mergedBedIntersect.LessCol.sort.lft.mtx

samplePrefix=pbmc1-15.

cell=b

N=22

for chr in ${chroms[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
  
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "run cicero  $cell $chr        $dt"
        
        lft_mtx_file="${lftmtxSortPrefix}${cell}.chr${chr}${lftmtxSortSuffix}"  
        
        #                                        pbmc1-15.b.chr10.mergedBedIntersect.LessCol.sort.lft.mtx
        # /nfs/lab/jnewsome/pbmc/cicero_v3/intersect_tag_mergedBareBed_lessCol_sort2/pbmc1-15.b.chr12.sort.lf_mtx
        metafile="${inDir_meta_chrom}pbmc1-15.${cell}.metadata.txt" # pbmc1-15.mem_b.metadata.txt
        outputFilePrefix="${outDir_cicero_chrom}pbmc1-15.${cell}.chr${chr}"
        logFile="${outDir_cicero_chrom}log/pbmc1-15.${cell}.chr${chr}.log"
        # matrixFile = args[1]
        # metafile = args[2]
        # outputFilePrefix = args[3]
        /usr/lib64/R/bin/Rscript ${RSCRIPT_NAME} ${lft_mtx_file} ${metafile}  ${outputFilePrefix} 2>&1 | tee ${logFile}

    
    ) &

done



# N=8

# for cell in ${pops[@]}; do 
#     ((i=i%N)); ((i++==0)) && wait

#     (
#     for chr in ${chroms[@]}; do 
#         for sample in ${samples[@]}; do 
#             dt=$(date '+%d/%m/%Y %H:%M:%S');
#             echo "run cicero  $cell $chr  $sample      $dt"

#             lft_mtx_file="${inDir_lftMtx_chromsample}pbmc1-15.${cell}.${sample}.chr${chr}${lftmtxSortSuffix}"  
#             # pbmc1-15.adaptive_NK.pbmc4.chr7.sort.lf_mtx
            
#             metafile="${inDir_meta_chromSample}pbmc1-15.${cell}.${sample}.metadata.txt" # pbmc1-15.cyto_cd8_t.pbmc2.metadata.txt
#             outputFilePrefix="${outDir_cicero_chromSample}pbmc1-15.${cell}.${sample}.chr${chr}"
#             logFile="${outDir_cicero_chromSample}log/pbmc1-15.${cell}.${sample}.chr${chr}.log"
#             # matrixFile = args[1]
#             # metafile = args[2]
#             # outputFilePrefix = args[3]

#             /usr/lib64/R/bin/Rscript ${RSCRIPT_NAME} ${lft_mtx_file} ${metafile}  ${outputFilePrefix} 2>&1 | tee ${logFile}
#         done
#     done
    
#     ) &

# done



