#!/usr/bin/env bash


broadPrefix=/nfs/lab/projects/pbmc_snATAC/pipeline/snATAC/combined_files/pbmc1to15/tagalign/broad_pop/pbmc1-15.
broadSuffix=.filt.rmdup.2021-08-08.broad.sort.tagAlign
broadPops=(b mono cd4_t_AND_cd8_t nk cd4_t pDC cd8_t plasma  mkc)
promFile=/nfs/lab/jnewsome/pbmc/peaks_intersect_promoters.HIGHSPECFILTER.lesscol.bed

finePops=(act_cd4_t mem_b  adaptive_NK  mem_cd8_t cDC  mkc  naive_b naive_cd4_t cyto_cd8_t naive_cd8_t ncMono   cMono   cyto_nk pDC  plasma  iMono  tReg)
finePrefix=/nfs/lab/projects/pbmc_snATAC/pipeline/snATAC/combined_files/pbmc1to15/tagalign/fine_pop/pbmc1-15.
fineSuffix=.filt.rmdup.2021-08-08.sort.tagAlign

outPrefix=/nfs/lab/jnewsome/pbmc/highSpecIntersect/pbmc1-15.
outSuffix=.highSpecGeneIntersect.1promPeakIntersect.tagAlign

echo "####### broad pops #####" 


for pop in ${broadPops[@]}; do 
echo "intersect $pop "
broadFile="${broadPrefix}${pop}${broadSuffix}"
outFile="${outPrefix}${pop}${outSuffix}"

bedtools intersect -wa -wb  -a ${broadFile} -b ${promFile}> ${outFile}    

echo "bedtools intersect ${broadFile} ${promFile} > ${outFile}    "

done



echo " ####### fine Pops #####" 
for pop in ${finePops[@]}; do 

echo " intersect $pop "
fineFile="${finePrefix}${pop}${fineSuffix}"
outFile="${outPrefix}${pop}${outSuffix}"

bedtools intersect -wa -wb  -a ${fineFile} -b ${promFile} > ${outFile}
    
done






exit 0