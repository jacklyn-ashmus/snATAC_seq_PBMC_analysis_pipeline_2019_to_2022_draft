#!/usr/bin/env bash

cells=(Acinar Alpha Beta Delta  Ductal  Endothelial Gamma Immune ImmuneMast Polyhormonal Stellate )
DIR=/nfs/lab/jnewsome/CoCl2_Islet_Multiome/peak_calls/
narrowpeakSuffix=_peaks.narrowPeak
bdgFileSuffix=.scale_1e6.bdg
bdgSortedFileSuffix=.scale_1e6.sorted.bdg
bwFileSuffix=.scale_1e6.bw
fileSizeFileSuffix=.size.txt
tagalignfilesuffix=.tagalign
tagalignfilesortedsuffix=.sorted.tagalign
GSIZE_FILE=/nfs/lab/ref/hg38.chrom.sizes

dt=$(date '+%d/%m/%Y %H:%M:%S');

# dt=$(date '+%d/%m/%Y %H:%M:%S');
# echo ""
# echo ""
# echo ""
# echo ""
# echo "=========="
# echo "COUNT READS"
# echo "=========="
# echo "                $dt"
# echo ""
# echo ""
# echo ""
# echo ""





# N=1

# for cell in ${cells[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait
#     (
#     fileSizeFile="${DIR}${cell}${fileSizeFileSuffix}"
#     bdgFile="${DIR}${cell}${bdgFileSuffix}"
#     bdgSortedFile="${DIR}${cell}${bdgSortedFileSuffix}"
#     bwFile="${DIR}${cell}${bwFileSuffix}"
#     tagalignFile="${DIR}${cell}${tagalignfilesuffix}"
    
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "working on    ${cell}       $dt"

#     # 2 . count reads
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "${cell} wc -l       $dt"
#     sizeA=$(wc -l ${tagalignFile})
#     sizearray=($sizeA)
#     size=${sizearray[0]}
   
#     echo ${size} > ${fileSizeFile}
    
#     ) &

# done


dt=$(date '+%d/%m/%Y %H:%M:%S');
echo ""
echo ""
echo ""
echo ""
echo "=========="
echo "sort tagalign"
echo "=========="
echo "                $dt"
echo ""
echo ""
echo ""
echo ""



N=4

for cell in ${cells[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    tagalignFile="${DIR}${cell}.tagalign"
    fileSizeFile="${DIR}${cell}${fileSizeFileSuffix}"
    sortedTagalignFile="${DIR}${cell}.sorted.tagalign"
    bdgFile="${DIR}${cell}${bdgFileSuffix}"
    bdgSortedFile="${DIR}${cell}${bdgSortedFileSuffix}"
    bwFile="${DIR}${cell}${bwFileSuffix}"
    
    # 4. sort tagalign file
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "$cell sorting tagalignFile   $tagalignFile  $dt"
     sort -k1,1 -k2,2n ${tagalignFile} > ${sortedTagalignFile}
     
    
  
    
    ) &

done





dt=$(date '+%d/%m/%Y %H:%M:%S');
echo ""
echo ""
echo ""
echo ""
echo "=========="
echo "MAKE BDG BW"
echo "=========="
echo "                $dt"
echo ""
echo ""
echo ""
echo ""



N=4

for cell in ${cells[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    tagalignFile="${DIR}${cell}${tagalignFileSuffix}"
    fileSizeFile="${DIR}${cell}${fileSizeFileSuffix}"
    sortedTagalignFile="${DIR}${cell}.sorted.tagalign"
    bdgFile="${DIR}${cell}${bdgFileSuffix}"
    bdgSortedFile="${DIR}${cell}${bdgSortedFileSuffix}"
    bwFile="${DIR}${cell}${bwFileSuffix}"
    
    # 4. sort tagalign file
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "$cell sorting tagalignFile   $tagalignFile  $dt"
#      sort -k1,1 -k2,2n ${tagalignFile} > ${sortedTagalignFile}
     
    
  
   READS=$(cat "$fileSizeFile")  
   #scaleNumerator=1000000
   SCALE_FACTOR=`awk -v nreads=${READS} 'BEGIN {printf("%.20f", 1e6/nreads)}'`
    
   dt=$(date '+%d/%m/%Y %H:%M:%S');
   echo "${cell} total reads = ${READS}     scale factor = ${SCALE_FACTOR}       $dt"
    # 3. make bdg file
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "${cell} calling bedtools genomecov     $dt"
    #echo "bedtools genomecov -i ${sortedTagalignFile} -bg -scale ${SCALE_FACTOR} -g ${GSIZE_FILE} > ${bdgFile} "
    bedtools genomecov -i ${sortedTagalignFile} -bg -scale ${SCALE_FACTOR} -g ${GSIZE_FILE} > ${bdgFile}
    
    
    # 4. sort bdg file
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "$cell sorting bdg file    $dt"
    sort -k1,1 -k2,2n ${bdgFile} > ${bdgSortedFile}
    
    # 5. make bigwig
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "${cell} making bigwig   $dt"
    bedGraphToBigWig ${bdgSortedFile} ${GSIZE_FILE} ${bwFile}
    
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    
    echo "done making bw for ${cell}      $dt"
    
    


    
    ) &

done



# N=4

# for cell in ${cells[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#     tagalignFile="${tagalignFilePrefix}${cell}${tagalignFileSuffix}"
#     fileSizeFile="${fileSizeFilePrefix}${cell}${fileSizeFileSuffix}"
#     sortedTagalignFile="${tagalignFilePrefix}${cell}${tagalignSortedFileSuffix}"
#     bdgFile="${bdgFilePrefix}${cell}${bdgFileSuffix}"
#     bdgSortedFile="${bdgFilePrefix}${cell}${bdgSortedFileSuffix}"
#     bwFile="${bwFilePrefix}${cell}${bwFileSuffix}"
    
#    READS=$(cat "$fileSizeFile")  
#    #scaleNumerator=1000000
#    SCALE_FACTOR=`awk -v nreads=${READS} 'BEGIN {printf("%.20f", 1e6/nreads)}'`
    
#    dt=$(date '+%d/%m/%Y %H:%M:%S');
#    echo "${cell} total reads = ${READS}     scale factor = ${SCALE_FACTOR}       $dt"
    
#     # 2.5 sort tagalign file
# #     echo "${cell} sorting tagalign"
# #     sort -k1,1 -k2,2n ${tagalignFile} > ${sortedTagalignFile}
    
    
#     # 3. make bdg file
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "${cell} calling bedtools genomecov     $dt"
#     #echo "bedtools genomecov -i ${sortedTagalignFile} -bg -scale ${SCALE_FACTOR} -g ${GSIZE_FILE} > ${bdgFile} "
#     bedtools genomecov -i ${sortedTagalignFile} -bg -scale ${SCALE_FACTOR} -g ${GSIZE_FILE} > ${bdgFile}
    
#     # 4. sort bdg file
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "$cell sorting bdg file    $dt"
#     sort -k1,1 -k2,2n ${bdgFile} > ${bdgSortedFile}
    
#     # 5. make bigwig
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "${cell} making bigwig   $dt"
#     bedGraphToBigWig ${bdgSortedFile} ${GSIZE_FILE} ${bwFile}
    
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
    
#     echo "done making bw for ${cell}      $dt"
    
    


    
#     ) &

# done













# cells=(b cd4_t cd8_t mkc mono nk pDC plasma  )



# dt=$(date '+%d/%m/%Y %H:%M:%S');
# echo ""
# echo ""
# echo ""
# echo ""
# echo "=========="
# echo "MERGING PEAKS"
# echo "=========="
# echo "                $dt"
# echo ""
# echo ""
# echo ""
# echo ""


# N=4

# for cell in ${cells[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "working on ${cell}       $dt"

#     narrowPeakFile="${narrowPeakFilePrefix}${cell}${narrowPeakFileSuffix}"
#     allPeaksAnnoBed="${allPeaksAnnoBedPrefix}${cell}${allPeaksAnnoBedSuffix}"
#     allPeaksAnnoSortBed="${allPeaksAnnoBedPrefix}${cell}${allPeaksAnnoBedSortSuffix}"
#     mergedPeakFile="${mergedPeaksFilePrefix}${cell}${mergedPeaksFileSuffix}"
    
#     intersect1File="${intersect1FilePrefix}${cell}${intersect1FileSuffix}"
#     merged2PeakFile="${merge2PeaksFilePrefix}${cell}${mergedPeaksFileSuffix}"
    
    
 
# #     echo "${cell}   ${narrowPeakFile}   to  ${allPeaksAnnoBed} "
# #     #1. make annotated bed file
# #     awk -v  cellType="${cell}" -v OFS='\t' ' { print $1, $2, $3, cellType } ' ${narrowPeakFile} > ${allPeaksAnnoBed}


# #     #2. sort annotated bed file
# # 	sort -k1,1 -k2,2n ${allPeaksAnnoBed} > ${allPeaksAnnoSortBed} 
    
    
# #     #3. bedtools merge 
# #     bedtools merge -i  ${allPeaksAnnoSortBed} > ${mergedPeakFile}
    
    
    
# #     #4. bedtools intersect
# #     bedtools intersect -a ${mergedPeakFile} -b ${allPeaksAnnoSortBed} -wa -wb > ${intersect1File}
    
#     # bedtools merge again
#     bedtools  merge -i ${intersect1File} -c 7 -o distinct >  ${merged2PeakFile}
    
    
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
    
#     echo "done merging peaks for ${cell}      $dt"
    

    
#     ) &

# done


# tagalignFilePrefix=/nfs/lab/projects/pbmc_snATAC/pipeline/snATAC/combined_files/pbmc1to15/tagalign/broad_pop/pbmc1-15.
# tagalignSortedFileSuffix=.filt.rmdup.2021-08-08.broad.sort.tagAlign
# barcodeFilePrefix=/nfs/lab/jnewsome/pbmc/clusterLabelFiles_broad/pbmc1-15.clustering.ClusterLabels.18th_doubletFiltrationIteration.broad.
# barcodeFileSuffix=.2021-08-06.txt
# matrixFileOutputPrefix=/nfs/lab/jnewsome/pbmc/mtx_broadPops/pbmc1-15.



# # dt=$(date '+%d/%m/%Y %H:%M:%S');
# # echo ""
# # echo ""
# # echo ""
# # echo ""
# # echo "=========="
# # echo "MAKING MATRICES"
# # echo "=========="
# # echo "                $dt"
# # echo ""
# # echo ""
# # echo ""
# # echo ""

# # N=4

# # for cell in ${cells[@]}; do 
# # 	((i=i%N)); ((i++==0)) && wait
# # 	(
# #     dt=$(date '+%d/%m/%Y %H:%M:%S');
# #     echo "working on ${cell}       $dt"
    
# #     merged2PeakFile="${merge2PeaksFilePrefix}${cell}${mergedPeaksFileSuffix}"
# #     sortedTagalignFile="${tagalignFilePrefix}${cell}${tagalignSortedFileSuffix}"
# #     barcodeListFile="${barcodeFilePrefix}${cell}${barcodeFileSuffix}"
# #     outputPrefix="${matrixFileOutputPrefix}${cell}"
    
    
# #     python /nfs/lab/jnewsome/scripts/createMatrixAfterPeakCall_fromJoshScript.py -o ${outputPrefix} -m ${merged2PeakFile} -t ${sortedTagalignFile} -b ${barcodeListFile}

# #     dt=$(date '+%d/%m/%Y %H:%M:%S');
    
# #     echo "done making matrices for ${cell}      $dt"
    

    
# #     ) &

# # done














# # echo "Done!!! (all)"


# # dt=$(date '+%d/%m/%Y %H:%M:%S');
# # echo "$dt"(base)


# # # 
exit 0