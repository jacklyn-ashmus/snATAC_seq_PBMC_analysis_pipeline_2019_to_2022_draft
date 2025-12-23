#!/usr/bin/env bash

mergedBedDir=/nfs/lab/jnewsome/pbmc/cicero_v3/split_merged_bed/
intersectDir=/nfs/lab/jnewsome/pbmc/cicero_v3/intersect_tag_mergedBareBed2/
intersect_lessCol_Dir=/nfs/lab/jnewsome/pbmc/cicero_v3/intersect_tag_mergedBareBed_lessCol2/
intersect_less_Col_sort=/nfs/lab/jnewsome/pbmc/cicero_v3/intersect_tag_mergedBareBed_lessCol_mergePeaks/



pops=(b cd4_t cd8_t mkc mono nk pDC plasma act_cd4_t cyto_cd8_t mem_b naive_b ncMono tReg adaptive_NK cyto_nk mem_cd8_t naive_cd4_t cDC cMono iMono naive_cd8_t )

chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)


samplePrefix=pbmc1-15.


tagalignDir=/nfs/lab/jnewsome/pbmc/cicero_v3/split_tag/

mergedBedSuffix=.coordsFromTagalign.sort.bed
intersectSuffix=.mergedBedIntersect.bed


lft_mtxDir=/nfs/lab/jnewsome/pbmc/cicero_v3/lft_mtx_origCode/



lft_mtxPrefix="${lft_mtxDir}${samplePrefix}"
lft_mtxSuffix=".lft_mtx.mtx"


echo ""
cell=b
N=22



# for pop in ${pops[@]}; do 
    for chrom in ${chroms[@]}; do 
        ((i=i%N)); ((i++==0)) && wait
        (
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "intersect file $cell $chrom"
        mergedBed="${mergedBedDir}${samplePrefix}chr${chrom}${mergedBedSuffix}" 
        tagalign="${tagalignDir}${samplePrefix}${cell}.chr${chrom}.tagAlign"
        lft_mtx="${lft_mtxPrefix}${cell}.chr${chrom}${lft_mtxSuffix}.gz"
        awk 'BEGIN{FS=OFS="\t"} {gsub("chr","",$1); print "chr"$1,$2,$3,$1":"$2"-"$3}' $mergedBed \
            | bedtools intersect -a - -b $tagalign -wa -wb \
            | cut -f 4,8 | sort -S 96G -T `pwd` \
            | uniq -c \
            | awk 'BEGIN{OFS="\t"; print "peak","barcode","value"} {print $2,$3,$1}' \
            | gzip -c \
            > $lft_mtx
        ) &
    done
# done


# N=4
# for chrom in ${chroms[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
    
#     for cell in ${otherPops_notB[@]}; do 
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "intersect file $cell $chrom"

#     mergedBed="${mergedBedDir}${samplePrefix}chr${chrom}${mergedBedSuffix}" # /nfs/lab/jnewsome/pbmc/cicero_v3/split_merged_bed/pbmc1-15.chr1.coordsFromTagalign.sort.bed
#     tagalign="${tagalignDir}${samplePrefix}${cell}.chr${chrom}.tagAlign"# /nfs/lab/jnewsome/pbmc/cicero_v3/pbmc1-15.b.chr1.tagAlign
#     intersectFile="${intersectDir}${samplePrefix}${cell}.chr${chrom}${intersectSuffix}"
#     intersectLessColFile="${intersect_lessCol_Dir}${samplePrefix}${cell}.chr${chrom}${intersectLessColSuffix}"
#     intesectLessColSortFile="${intersect_less_Col_sort}${samplePrefix}${cell}.chr${chrom}${intersectLessColSortSuffix}"
    

#     bedtools intersect -a ${mergedBed} -b ${tagalign} -wa -wb > ${intersectFile}
#     python ${intersectFileFixScript} -i ${intersectFile} -o ${intersectLessColFile}
#     sort -k1,1 -k2,2n ${intersectLessColFile} > ${intesectLessColSortFile} 
    
#     done
#     ) &

# done









