



chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
otherPops=
infilePrefix=/nfs/lab/jnewsome/pbmc/cicero_v3/tagalign/
infileSuffix=.tagAlign



MERGEDBAREBED=/nfs/lab/projects/pbmc_snATAC/analysis_v2/peaks/pbmc.sorted.merged.bare.bed

splitMergedBedPrefix=/nfs/lab/jnewsome/pbmc/cicero_v3/split_merged_bed/pbmc.sorted.merged.bare.
splitMergedBedSuffix=.bed

bedFromTagPrefix=/nfs/lab/jnewsome/pbmc/cicero_v3/bed_fromTagalign/pbmc1-15.
bedFromTagSuffix=.coordsFromTagalign.bed
sortedBedFromTagSuffix=.coordsFromTagalign.sort.bed

splitBedFromTagPrefix=s/nfs/lab/jnewsome/pbmc/cicero_v3/bed_fromTagalign/pbmc1-15.plit_bed_from_tag/
splitBedFromTagSuffix=.coordsFromTagalign.sort.bed


for cell in ${cells[@]}; do 


    

done










for cell in ${cells[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "working on ${cell}       $dt"

    narrowPeakFile="${narrowPeakFilePrefix}${cell}${narrowPeakFileSuffix}"
    allPeaksAnnoBed="${allPeaksAnnoBedPrefix}${cell}${allPeaksAnnoBedSuffix}"
    allPeaksAnnoSortBed="${allPeaksAnnoBedPrefix}${cell}${allPeaksAnnoBedSortSuffix}"
    mergedPeakFile="${mergedPeaksFilePrefix}${cell}${mergedPeaksFileSuffix}"
    
    intersect1File="${intersect1FilePrefix}${cell}${intersect1FileSuffix}"
    merged2PeakFile="${merge2PeaksFilePrefix}${cell}${mergedPeaksFileSuffix}"
    
    
    echo "${cell}   ${narrowPeakFile}   to  ${allPeaksAnnoBed} "
    #1. make annotated bed file
    awk -v  cellType="${cell}" -v OFS='\t' ' { print $1, $2, $3, cellType } ' ${narrowPeakFile} > ${allPeaksAnnoBed}


    #2. sort annotated bed file
	sort -k1,1 -k2,2n ${allPeaksAnnoBed} > ${allPeaksAnnoSortBed} 
    
    
    #4. bedtools intersect
    bedtools intersect -a ${mergedPeakFile} -b ${allPeaksAnnoSortBed} -wa -wb > ${intersect1File}
    
    # bedtools merge again
    bedtools  merge -i ${intersect1File} -c 7 -o distinct >  ${merged2PeakFile}
    
    
    


     
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    
    echo "done merging peaks for ${cell}      $dt"
    

    
    ) &

done

