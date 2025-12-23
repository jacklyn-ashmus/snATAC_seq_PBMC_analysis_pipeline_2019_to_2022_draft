#!/usr/bin/env bash



cells=(act_cd4_t   adaptive_NK   cDC   _cluster2   _cluster3   _cluster9   _clusters2,3   _clusters2,3,9   cyto_cd8_t   cyto_nk   mem_b   mem_cd8_t   mkc   naive_b   naive_cd4_t   naive_cd8_t   ncMono   pDC   plasma   tReg  )

tagalignFilePrefix=/nfs/lab/jnewsome/pbmc/splitTagalign2021/pbmc1-15.
tagalignFileSuffix=.filt.rmdup.2021-08-08.tagAlign

peakCallDir=/nfs/lab/jnewsome/pbmc/peakCalls/

fileSizeFilePrefix=/nfs/lab/jnewsome/pbmc/peakCalls/
fileSizeFileSuffix=.totalReadCount.txt

bdgFilePrefix=/nfs/lab/jnewsome/pbmc/bdg_rpkm/pbmc1_15.
bdgFileSuffix=.scale_1e9.bdg
bdgSortedFileSuffix=.scale_1e9.sorted.bdg

bwFilePrefix=/nfs/lab/jnewsome/pbmc/bw_rpkm/pbmc1_15.
bwFileSuffix=.scale_1e9.bw

GSIZE_FILE=/nfs/lab/jnewsome/references/hg19.chrom.sizes




dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "\n\n\n\n==========\nCALLING PEAKS\n==========\n      $dt\n\n\n\n"




# N=6

# for cell in ${cells[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "working on    ${cell}       $dt"



#     tagalignFile="${tagalignFilePrefix}${cell}${tagalignFileSuffix}"
#     fileSizeFile="${fileSizeFilePrefix}${cell}${fileSizeFileSuffix}"
#     sortedTagalignFile="${tagalignFilePrefix}${cell}${tagalignSortedFileSuffix}"
#     bdgFile="${bdgFilePrefix}${cell}${bdgFileSuffix}"
#     bdgSortedFile="${bdgFilePrefix}${cell}${bdgSortedFileSuffix}"
#     bwFile="${bwFilePrefix}${cell}${bwFileSuffix}"
    
    
    
#     # 1. Call Peaks
#     echo "${cell} macs2 call"
#     macs2 callpeak -t ${tagalignFile} --outdir ${peakCallDir} -n ${cell} -q 0.05 --nomodel --keep-dup all -g hs
    
    
    
#     ) &

# done




# cells=(act_cd4_t   adaptive_NK   cDC   _cluster2   _cluster3   _cluster9   _clusters2,3   _clusters2,3,9   cyto_cd8_t   cyto_nk   mem_b   mem_cd8_t   mkc   naive_b   naive_cd4_t   naive_cd8_t   ncMono   pDC   plasma   tReg  )


# dt=$(date '+%d/%m/%Y %H:%M:%S');
# echo "\n\n\n\n==========\nCOUNT READS\n==========\n      $dt\n\n\n\n"






# N=6

# for cell in ${cells[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait
#     (
#     tagalignFile="${tagalignFilePrefix}${cell}${tagalignFileSuffix}"
#     fileSizeFile="${fileSizeFilePrefix}${cell}${fileSizeFileSuffix}"
#     sortedTagalignFile="${tagalignFilePrefix}${cell}${tagalignSortedFileSuffix}"
#     bdgFile="${bdgFilePrefix}${cell}${bdgFileSuffix}"
#     bdgSortedFile="${bdgFilePrefix}${cell}${bdgSortedFileSuffix}"
#     bwFile="${bwFilePrefix}${cell}${bwFileSuffix}"
    
    
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
echo "\n\n\n\n==========\nDO STUFF\n==========\n      $dt\n\n\n\n"




N=6

for cell in ${cells[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    tagalignFile="${tagalignFilePrefix}${cell}${tagalignFileSuffix}"
    fileSizeFile="${fileSizeFilePrefix}${cell}${fileSizeFileSuffix}"
    sortedTagalignFile="${tagalignFilePrefix}${cell}${tagalignSortedFileSuffix}"
    bdgFile="${bdgFilePrefix}${cell}${bdgFileSuffix}"
    bdgSortedFile="${bdgFilePrefix}${cell}${bdgSortedFileSuffix}"
    bwFile="${bwFilePrefix}${cell}${bwFileSuffix}"
    
    READS=$(cat "$fileSizeFile")  
    SCALE_FACTOR=`awk -v nreads=${READS} 'BEGIN {printf("%.20f", 1e9/nreads)}'`
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "${cell} total reads = ${READS}     scale factor = ${SCALE_FACTOR}       $dt"
    
    
     # 3. make bdg file
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "${cell} calling bedtools genomecov     $dt"
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



















# dt=$(date '+%d/%m/%Y %H:%M:%S');
# echo "\n\n\n\n==========\nMERGING PEAKS\n==========\n      $dt\n\n\n\n"








# narrowPeakFilePrefix=/nfs/lab/jnewsome/pbmc/peakCalls/
# narrowPeakFileSuffix=_peaks.narrowPeak


# allPeaksAnnoBedPrefix=/nfs/lab/jnewsome/pbmc/allPeaks/
# allPeaksAnnoBedSuffix=.all_peaks.anno.bed
# allPeaksAnnoBedSortSuffix=.all_peaks.anno.sort.bed



# mergedPeaksFilePrefix=/nfs/lab/jnewsome/pbmc/mergedPeaks/
# mergedPeaksFileSuffix=.merged_peaks.anno.bed

# intersect1FilePrefix=/nfs/lab/jnewsome/pbmc/peakIntersect1/
# intersect1FileSuffix=.all_peaks.anno.INTERSECT1.bed

# merge2PeaksFilePrefix=/nfs/lab/jnewsome/pbmc/mergedPeaks_Part2/
# mergedPeaksFileSuffix=.merged_peaks.anno.bed



# N=6

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
    
    
#     echo "${cell}   ${narrowPeakFile}"
#     #1. make annotated bed file
#     awk cellType="${cell}" OFS='\t' '{print $1, $2, $3, cellType}' ${narrowPeakFile} > ${allPeaksAnnoBed}


#     #2. sort annotated bed file
# 	sort -k1,1 -k2,2n ${allPeaksAnnoBed} > ${allPeaksAnnoSortBed} 
    
    
#     #3. bedtools merge 
#     bedtools merge -i  ${allPeaksAnnoSortBed} > ${mergedPeakFile}
    
    
    
#     #4. bedtools intersect
#     bedtools intersect -a ${mergedPeakFile} -b ${allPeaksAnnoSortBed} -wa -wb > ${intersect1File}
    
#     # bedtools merge again
#     bedtools  merge -i ${intersect1File} -c 7 -o distinct >  ${merged2PeakFile}
    
    
    


     
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
    
#     echo "done making bw for ${cell}      $dt"
    

    
#     ) &

# done










echo "Done!!! (all)"


dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "$dt"(base)


# 