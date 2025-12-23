#!/usr/bin/env bash



fine_pops=(act_cd4_t cMono iMono mkc naive_cd8_t plasma adaptive_NK ncMono cyto_cd8_t mem_b naive_b tReg cDC cyto_nk  mem_cd8_t naive_cd4_t  pDC)


broad_pops=(b cd4_t cd8_t mkc mono nk pDC  plasma cd4_AND_cd8_t)
inDir_broad=/nfs/lab/jnewsome/pbmc/split_lf_mtx/broad/
inDir_fine=/nfs/lab/jnewsome/pbmc/split_lf_mtx/fine/


infile2Prefix=pbmc1-15.


outDir_fine=/nfs/lab/jnewsome/pbmc/split_lf_mtx/fine_intersect/
outDir_broad=/nfs/lab/jnewsome/pbmc/split_lf_mtx/fine_intersect/




outPrefix1=pbmc1-15.
outSuffix=.intersected.bed

pbmc.sorted.merged.bare.chr14.bed


peakprefix=/nfs/lab/jnewsome/pbmc/split_lf_mtx/pbmc.sorted.merged.bare.chr
peaksuffix=.bed




insuffix=.lf_mtx.gz
out1Suffix=.lf_mtx





dirPrefix=/nfs/lab/projects/pbmc_snATAC/pipeline/snATAC/cluster_analysis/broad_pops/label_barcodes/pbmc1-15.cluster_labels.BARCODES.broad.
dirSuffix=.2021-08-24.txt


chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)


for cell in ${fine_pops[@]}; do 
for chr in ${chroms[@]}; do 

peakFile="${peakprefix}${chr}${peaksuffix}"
infile="${inDir_fine}${infile2Prefix}${cell}.chr${chr}.sorted${out1Suffix}"
outfile="${outDir_fine}${infile2Prefix}${cell}.chr${chr}${outSuffix}"

bedtools intersect -wa -wb -a pbmc9_fragments.FIX.sort.filter.bed -b /home/ubuntu/references/gencode.v19.annotation.lessCol.2kPadUpstream.mergeGenes.sort.bed  > /home/ubuntu/pbmc9_fragments.FIX.sort.filter.intersect.gencode.v19.bed

done
done



for cell in ${broad_pops[@]}; do 
inFile="${inDir_broad}${infile2Prefix}${cell}${insuffix}"


for chr in ${chroms[@]}; do 
outfile="${outDir_broad}${infile2Prefix}${cell}.chr${chr}${out1Suffix}"
outfileSort="${outDir_broad}${infile2Prefix}${cell}.chr${chr}.sorted${out1Suffix}"
grepThing="${chr}:"

echo " $cell chr$chr"
zgrep ${grepThing} ${inFile} > ${outfile}

sort -k1,1 -k2,2n ${outfile} > ${outfileSort}

done
done
