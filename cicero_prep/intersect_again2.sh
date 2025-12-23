#!/usr/bin/env bash




LESSCOLSCRIPT=/nfs/lab/jnewsome/scripts/cicero_prep/intersectTo_Lft_MtxFile.py

mergedBedDir=/nfs/lab/jnewsome/pbmc/cicero_v3/split_merged_bed/
tagalignDir=/nfs/lab/jnewsome/pbmc/cicero_v3/split_tag/
intersectDir=/nfs/lab/jnewsome/pbmc/cicero_v3/intersect_tag_mergedBareBed2/
intersect_lessCol_Dir=/nfs/lab/jnewsome/pbmc/cicero_v3/intersect_tag_mergedBareBed_lessCol2/
intersect_less_Col_sort=/nfs/lab/jnewsome/pbmc/cicero_v3/intersect_tag_mergedBareBed_lessCol_sort2/



otherPops_notB=(cd4_t cd8_t mkc mono nk pDC plasma act_cd4_t cyto_cd8_t mem_b naive_b ncMono tReg adaptive_NK cyto_nk mem_cd8_t naive_cd4_t cDC cMono iMono naive_cd8_t )

chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)

# chroms=( 1 )

samplePrefix=pbmc1-15.

mkdir $intersect_lessCol_Dir
mkdir $intersect_less_Col_sort

mergedBedSuffix=.coordsFromTagalign.sort.bed
intersectSuffix=.mergedBedIntersect.bed
intersectLessColSuffix=.mergedBedIntersect.LessCol.lft.mtx
intersectLessColSortSuffix=.mergedBedIntersect.LessCol.sort.lft.mtx

cell=b
N=22
for chrom in ${chroms[@]}; do 
	((i=i%N)); ((i++==0)) && wait
	(
#     for cell in ${otherPops_notB[@]}; do 
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "intersect file $cell $chrom"
    mergedBed="${mergedBedDir}${samplePrefix}chr${chrom}${mergedBedSuffix}" 
    # /nfs/lab/jnewsome/pbmc/cicero_v3/split_merged_bed/pbmc1-15.chr1.coordsFromTagalign.sort.bed
    tagalign="${tagalignDir}${samplePrefix}${cell}.chr${chrom}.tagAlign" 
    # /nfs/lab/jnewsome/pbmc/cicero_v3/pbmc1-15.b.chr1.tagAlign
    
    
    
    
    intersectFile="${intersectDir}${samplePrefix}${cell}.chr${chrom}${intersectSuffix}"
    intersectLessColFile="${intersect_lessCol_Dir}${samplePrefix}${cell}.chr${chrom}${intersectLessColSuffix}"
    intesectLessColSortFile="${intersect_less_Col_sort}${samplePrefix}${cell}.chr${chrom}${intersectLessColSortSuffix}"
    
#     echo "      intersect $cell $chrom"
#     bedtools intersect -a ${mergedBed} -b ${tagalign} -wa -wb > ${intersectFile}
    echo "      lesscol $cell $chrom"
    python ${LESSCOLSCRIPT} -i ${intersectFile} -o ${intersectLessColFile}
    echo "      sort $cell $chrom"
    sort -k1,1 -k2,2n ${intersectLessColFile} > ${intesectLessColSortFile} 
    
#     done
    ) &

done


# N=4
# for chrom in ${chroms[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
    
#     for cell in ${otherPops_notB[@]}; do 
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "intersect file $cell $chrom"

#     mergedBed="${mergedBedDir}${samplePrefix}chr${chrom}${mergedBedSuffix}" # /nfs/lab/jnewsome/pbmc/cicero_v3/split_merged_bed/pbmc1-15.chr1.coordsFromTagalign.sort.bed
#     tagalign="${tagalignDir}${samplePrefix}${cell}.chr${chrom}.tagAlign"
    # /nfs/lab/jnewsome/pbmc/cicero_v3/pbmc1-15.b.chr1.tagAlign
#     intersectFile="${intersectDir}${samplePrefix}${cell}.chr${chrom}${intersectSuffix}"
#     intersectLessColFile="${intersect_lessCol_Dir}${samplePrefix}${cell}.chr${chrom}${intersectLessColSuffix}"
#     intesectLessColSortFile="${intersect_less_Col_sort}${samplePrefix}${cell}.chr${chrom}${intersectLessColSortSuffix}"
    

#     bedtools intersect -a ${mergedBed} -b ${tagalign} -wa -wb > ${intersectFile}
#     python ${intersectFileFixScript} -i ${intersectFile} -o ${intersectLessColFile}
#     sort -k1,1 -k2,2n ${intersectLessColFile} > ${intesectLessColSortFile} 
    
#     done
#     ) &

# done

