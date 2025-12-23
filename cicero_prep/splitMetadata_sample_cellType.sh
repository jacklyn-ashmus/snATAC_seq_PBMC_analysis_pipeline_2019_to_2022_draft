#!/usr/bin/env bash




PY_SCRIPT=/nfs/lab/jnewsome/scripts/cicero/pbmc_cicero_2021/subset_Cluster_Metadata_File_withBarList_barcodeOrdered.py

pops=(act_cd4_t cd4_AND_cd8_t cDC cyto_nk mem_cd8_t naive_b ncMono plasma adaptive_NK cd4_t cMono iMono mkc naive_cd4_t nk tReg b cd8_t cyto_cd8_t mem_b mono naive_cd8_t pDC)
chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
samples=(pbmc1 pbmc2 pbmc3 pbmc4 pbmc5 pbmc6 pbmc8 pbmc9 pbmc10 pbmc12 pbmc13 pbmc14 pbmc15)

IN_META_FILE=/nfs/lab/projects/pbmc_snATAC/pipeline/snATAC/cluster_analysis/pbmc1-15.barcodeClusterNames.FINAL.AllCellTypes.txt

# chrom_sampleSplit            pbmc1-15.adaptive_NK.barcodes  pbmc1-15.cd8_t.barcodes  pbmc1-15.cyto_cd8_t.barcodes  pbmc1-15.mem_b.barcodes      pbmc1-15.mono.barcodes         pbmc1-15.naive_cd8_t.barcodes  pbmc1-15.pDC.barcodes
# chromSplit

barcodeDir=/nfs/lab/jnewsome/pbmc/split_cicero_2/barcodes/
sortBarcodeDir=/nfs/lab/jnewsome/pbmc/split_cicero_2/barcodes/sort/
splitBarcodeDir=/nfs/lab/jnewsome/pbmc/split_cicero_2/barcodes/sampleSplit/


outCellSplitDir=/nfs/lab/jnewsome/pbmc/split_cicero_2/splitMeta/cellSplit/
outCellSampleSplitDir=/nfs/lab/jnewsome/pbmc/split_cicero_2/splitMeta/cellSampleSplit/
  

# conda activate py37








# sort barcode files
# N=8

# for cell in ${pops[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#         echo "sort  $cell        $dt"
#         inbarfile="${barcodeDir}pbmc1-15.${cell}.barcodes"
#         outbarfile="${sortBarcodeDir}pbmc1-15.${cell}.barcodes"
#         sort  -V ${inbarfile} > ${outbarfile}
    
#     ) &

# done







# split barcode by sample
# N=8

# for cell in ${pops[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#         for sample in  ${samples[@]}; do 
#             echo "split barcode  $cell ${samples}       $dt"
#             inbarfile="${sortBarcodeDir}pbmc1-15.${cell}.barcodes"
#             outbarfile="${splitBarcodeDir}pbmc1-15.${cell}.${sample}.barcodes"
#             grepThing="${sample}_"
#             grep ${grepThing} ${inbarfile} > ${outbarfile}
#         done
    
#     ) &

# done


outCellSplitDir=/nfs/lab/jnewsome/pbmc/split_cicero_2/splitMeta/cellSplit/
outCellSampleSplitDir=/nfs/lab/jnewsome/pbmc/split_cicero_2/splitMeta/cellSampleSplit/
  


N=8

for cell in ${pops[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "split meta  $cell       $dt"
        inbarfile="${sortBarcodeDir}pbmc1-15.${cell}.barcodes"
        outMetaFile="${outCellSplitDir}pbmc1-15.${cell}.metadata.txt"
#         echo "$inbarfile   $outMetaFile     $IN_META_FILE"
#         parser.add_argument('-i', '--inputFile', required=True, type=str, default='stdin', help="input metadata file")
#         parser.add_argument('-o', '--outputFile', required=True, type=str, help="output subset metadata file name")
#         parser.add_argument('-b', '--barcodeFile', required=True, type=str, default='stdin',
        python ${PY_SCRIPT} -i ${IN_META_FILE} -b ${inbarfile} -o ${outMetaFile}
    
    ) &

done






N=8

for cell in ${pops[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    for sample in ${samples[@]}; do 
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "split meta  $cell $sample        $dt"
        inbarfile="${splitBarcodeDir}pbmc1-15.${cell}.${sample}.barcodes"
        outMetaFile="${outCellSampleSplitDir}pbmc1-15.${cell}.${sample}.metadata.txt"
        python ${PY_SCRIPT} -i ${IN_META_FILE} -b ${inbarfile} -o ${outMetaFile}

    done
    
    ) &

done









# N=8

# for cell in ${fine_pops[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#     for chr in ${chroms[@]}; do 
#         dt=$(date '+%d/%m/%Y %H:%M:%S');
#         echo "run cicero  $cell $chr        $dt"
#         lft_mtx_file="${fine_mtx_prefix}${cell}.chr${chr}${mtx_suffix}" 
#         matrixFile="${fine_mtx_prefix}${cell}${CHR_INFIX}${chr}${mtx_suffix}"
#         barfile="${fine_mtx_prefix}${cell}${CHR_INFIX}${chr}${cell_suffix}"
#         peaksfile="${fine_mtx_prefix}${cell}${CHR_INFIX}${chr}${peak_suffix}"
#         metafile="${fine_metafile_prefix}${cell}${CHR_INFIX}${chr}${metafile_suffix}"
#         outputFilePrefix="${cicero_output_FINE_prefixPrefix}${cell}${CHR_INFIX}${chr}"
#         clusterColName="${clusterColName_FINE}"
#         logFile="${cicero_output_FINE_prefixPrefix}${cell}${CHR_INFIX}${chr}.log"
#         # matrixFile = args[1]
#         # metafile = args[2]
#         # outputFilePrefix = args[3]
#         #            6
#         python ${PY_SCRIPT} -i ${infile} -b ${barcodeFile} -o ${outfile}
#         Rscript ${RSCRIPT_NAME} ${matrixFile} ${metafile}  ${outputFilePrefix} 2>&1 | tee ${logFile}

#     done
    
#     ) &

# done




