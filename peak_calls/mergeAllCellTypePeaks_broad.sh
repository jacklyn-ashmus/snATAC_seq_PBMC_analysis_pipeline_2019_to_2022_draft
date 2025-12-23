#!/usr/bin/env bash


cellList=(b cd4_t cd8_t mkc mono nk pDC plasma  )
cellList2=(cd8_t mkc mono nk pDC plasma  )
# annotatedBedFilePrefix=/nfs/lab/jnewsome/pbmc/mergedPeaks_Part2_broad/
# annotatedBedFileSuffix=.merged_peaks.anno.bed
# annotFiltBedFilePrefix=/nfs/lab/jnewsome/pbmc/mergedPeaks_filt/
# annotFiltBedFileSuffix=.merged_peaks.anno.filt.bed

# BLACKLIST_FILES=/nfs/lab/jnewsome/references/hg19-blacklist.v2.bed


# catFile=/nfs/lab/jnewsome/pbmc/mergedPeaks_Part2_broad/pbmc1-15.broad.MERGED.merged_peaks.anno.bed
# catFilterFile=/nfs/lab/jnewsome/pbmc/mergedPeaks_Part2_broad/pbmc1-15.broad.MERGED.merged_peaks.anno.sort.filt.bed

# catFile2=/nfs/lab/jnewsome/pbmc/mergedPeaks_Part2_broad/pbmc1-15.broad.MERGED.merged_peaks.anno.bed2
# catFileSort=/nfs/lab/jnewsome/pbmc/mergedPeaks_Part2_broad/pbmc1-15.broad.MERGED.merged_peaks.anno.sort.bed
# catFileMerge=/nfs/lab/jnewsome/pbmc/mergedPeaks_Part2_broad/pbmc1-15.broad.MERGED.merged_peaks.anno.sort.filt.merge.bed

# infile1="${annotatedBedFilePrefix}b${annotatedBedFileSuffix}"
# infile2="${annotatedBedFilePrefix}cd4_t${annotatedBedFileSuffix}"

# echo "cat ${infile1} ${infile2} > ${catFile}"
# cat ${infile1} ${infile2} > ${catFile}

# for cell in ${cellList2[@]}; do
# echo "${cell}"
# infile="${annotatedBedFilePrefix}${cell}${annotatedBedFileSuffix}"
# echo "cat ${catFile} ${infile2} > ${catFile2}"
# cat ${catFile} ${infile} > ${catFile2}
# echo "cp ${catFile2} ${catFile}"
# cp ${catFile2} ${catFile}
# done



# sort -k1,1 -k2,2n ${catFile} > ${catFileSort}
# echo "sort -k1,1 -k2,2n ${catFile} > ${catFileSort}"
# sort -k1,1 -k2,2n ${catFile} > ${catFileSort}

# echo "bedtools intersect -a ${catFileSort} -b ${BLACKLIST_FILES} -v > ${catFilterFile}"
# bedtools intersect -a ${catFileSort} -b ${BLACKLIST_FILES} -v > ${catFilterFile}
# echo "bedtools merge -i ${catFileSort} -c 4 -o collapse > ${catFilterFile}"
# bedtools merge -i ${catFileMerge} -c 4 -o collapse > ${catFileMerge}
# echo " done merging broad pops"

cd /nfs/lab/jnewsome/pbmc/mergedPeaks_Part2/

cat b.merged_peaks.anno.bed cd4_t.merged_peaks.anno.bed cd8_t.merged_peaks.anno.bed mkc.merged_peaks.anno.bed mono.merged_peaks.anno.bed nk.merged_peaks.anno.bed pDC.merged_peaks.anno.bed plasma.merged_peaks.anno.bed > pbmc1-15.broad.MERGED.merged_peaks.anno.v2.bed


sort -k1,1 -k2,2n pbmc1-15.broad.MERGED.merged_peaks.anno.v2.bed > pbmc1-15.broad.MERGED.merged_peaks.anno.sort.v2.bed

bedtools intersect -a pbmc1-15.broad.MERGED.merged_peaks.anno.sort.v2.bed -b /nfs/lab/jnewsome/references/hg19-blacklist.v2.bed -v > pbmc1-15.broad.MERGED.merged_peaks.anno.sort.filt.v2.bed

bedtools merge -i pbmc1-15.broad.MERGED.merged_peaks.anno.sort.filt.v2.bed -c 4 -o collapse > pbmc1-15.broad.MERGED.merged_peaks.anno.sort.filt.merge.v2.bed