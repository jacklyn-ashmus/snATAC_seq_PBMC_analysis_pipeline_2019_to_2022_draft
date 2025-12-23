#!/usr/bin/env bash


cellList=(act_cd4_t   adaptive_NK   cDC   iMono   cMono  cyto_cd8_t   cyto_nk   mem_b   mem_cd8_t   mkc   naive_b   naive_cd4_t   naive_cd8_t   ncMono   pDC   plasma   tReg  )
cellList2=(  cDC   iMono   cMono  cyto_cd8_t   cyto_nk   mem_b   mem_cd8_t   mkc   naive_b   naive_cd4_t   naive_cd8_t   ncMono   pDC   plasma   tReg  )

annotatedBedFilePrefix=/nfs/lab/jnewsome/pbmc/mergedPeaks_Part2/
annotatedBedFileSuffix=.merged_peaks.anno.bed
annotFiltBedFilePrefix=/nfs/lab/jnewsome/pbmc/mergedPeaks_filt/
annotFiltBedFileSuffix=.merged_peaks.anno.filt.bed

BLACKLIST_FILES=/nfs/lab/jnewsome/references/hg19-blacklist.v2.bed


catFile=/nfs/lab/jnewsome/pbmc/mergedPeaks_Part2/pbmc1-15.fine.MERGED.merged_peaks.anno.bed
catFilterFile=/nfs/lab/jnewsome/pbmc/mergedPeaks_Part2/pbmc1-15.fine.MERGED.merged_peaks.anno.sort.filt.bed

catFile2=/nfs/lab/jnewsome/pbmc/mergedPeaks_Part2/pbmc1-15.fine.MERGED.merged_peaks.anno.bed2
catFileSort=/nfs/lab/jnewsome/pbmc/mergedPeaks_Part2/pbmc1-15.fine.MERGED.merged_peaks.anno.sort.bed
catFileMerge=/nfs/lab/jnewsome/pbmc/mergedPeaks_Part2/pbmc1-15.fine.MERGED.merged_peaks.anno.sort.filt.merge.bed

infile1="${annotatedBedFilePrefix}act_cd4_t${annotatedBedFileSuffix}"
infile2="${annotatedBedFilePrefix}adaptive_NK${annotatedBedFileSuffix}"

echo "cat ${infile1} ${infile2} > ${catFile}"
cat ${infile1} ${infile2} > ${catFile}

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
# echo "bedtools merge -i ${catFileSort} -c 4 -o collapse > ${catFileMerge}"
# bedtools merge -i ${catFileSort} -c 4 -o collapse > ${catFileMerge}
# echo " done merging fine pops"

cd /nfs/lab/jnewsome/pbmc/mergedPeaks_Part2/

cat act_cd4_t.merged_peaks.anno.bed adaptive_NK.merged_peaks.anno.bed cDC.merged_peaks.anno.bed cMono.merged_peaks.anno.bed cyto_cd8_t.merged_peaks.anno.bed cyto_nk.merged_peaks.anno.bed iMono.merged_peaks.anno.bed mem_b.merged_peaks.anno.bed mem_cd8_t.merged_peaks.anno.bed mkc.merged_peaks.anno.bed  naive_b.merged_peaks.anno.bed  naive_cd4_t.merged_peaks.anno.bed naive_cd8_t.merged_peaks.anno.bed ncMono.merged_peaks.anno.bed pDC.merged_peaks.anno.bed plasma.merged_peaks.anno.bed tReg.merged_peaks.anno.bed > pbmc1-15.fine.MERGED.merged_peaks.anno.v2.bed


sort -k1,1 -k2,2n pbmc1-15.fine.MERGED.merged_peaks.anno.v2.bed > pbmc1-15.fine.MERGED.merged_peaks.anno.sort.v2.bed

bedtools intersect -a pbmc1-15.fine.MERGED.merged_peaks.anno.sort.v2.bed -b /nfs/lab/jnewsome/references/hg19-blacklist.v2.bed -v > pbmc1-15.fine.MERGED.merged_peaks.anno.sort.filt.v2.bed

bedtools merge -i pbmc1-15.fine.MERGED.merged_peaks.anno.sort.filt.v2.bed -c 4 -o collapse > pbmc1-15.fine.MERGED.merged_peaks.anno.sort.filt.merge.v2.bed





