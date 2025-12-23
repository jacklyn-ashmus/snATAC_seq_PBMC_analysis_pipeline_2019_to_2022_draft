#!/usr/bin/env bash


pops=(act_cd4_t cd4_AND_cd8_t cDC cyto_nk mem_cd8_t naive_b ncMono plasma adaptive_NK cd4_t cMono iMono mkc naive_cd4_t nk tReg b cd8_t cyto_cd8_t mem_b mono naive_cd8_t pDC)
chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
samples=(pbmc1 pbmc2 pbmc3 pbmc4 pbmc5 pbmc6 pbmc8 pbmc9 pbmc10 pbmc12 pbmc13 pbmc14 pbmc15)


inDir=/nfs/lab/jnewsome/pbmc/split_cicero_2/lf_mtx/

outDir_chrom=/nfs/lab/jnewsome/pbmc/split_cicero_2/split_lf_mtx/chrom/
outDir_chromsort=/nfs/lab/jnewsome/pbmc/split_cicero_2/split_lf_mtx/chromSort/
outDir_chrom_sample=/nfs/lab/jnewsome/pbmc/split_cicero_2/split_lf_mtx/chrom_sample/
outDir_chrom_samplesort=/nfs/lab/jnewsome/pbmc/split_cicero_2/split_lf_mtx/chrom_sampleSort/


inLftMtx_Prefix="${inDir}pbmc1-15."
outChromLftMtx_Prefix="${outDir_chrom}pbmc1-15."
outChromSampleLftMtx_Prefix="${outDir_chrom}pbmc1-15."
outChromSortLftMtx_Prefix="${outDir_chromsort}pbmc1-15."
outChromSampleSortLftMtx_Prefix="${outDir_chrom_samplesort}pbmc1-15."


lftmtxSuffix=.lf_mtx
lftmtxSortSuffix=.sort.lf_mtx


N=8
for cell in ${pops[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    for chr in ${chroms[@]}; do 
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "$cell $chr        $dt"
        
        inFile="${inLftMtx_Prefix}${cell}${lftmtxSuffix}" #pbmc1-15.cMono.lf_mtx
        outFile="${outChromLftMtx_Prefix}${cell}.chr${chr}${lftmtxSuffix}" #pbmc1-15.cMono.chr1.lf_mtx
        outFileSort="${outChromSortLftMtx_Prefix}${cell}.chr${chr}${lftmtxSortSuffix}"
        grepThing="^${chr}:"
#         echo "grep ${grepThing} ${inFile} > ${outFile}"
#         grep ${grepThing} ${inFile} > ${outFile}
        sort -k1,1V -k2,2V  ${outFile} > ${outFileSort}

    done
    
    ) &

done






N=8
for cell in ${pops[@]}; do 
    ((i=i%N)); ((i++==0)) && wait
    (
    for chr in ${chroms[@]}; do 
        for sample in  ${samples[@]}; do 
            dt=$(date '+%d/%m/%Y %H:%M:%S');
            echo "$cell $chr  $sample      $dt"

            inFile="${inLftMtx_Prefix}${cell}${lftmtxSuffix}" #pbmc1-15.cMono.lf_mtx
            outFile="${outChromSampleLftMtx_Prefix}${cell}.${sample}.chr${chr}${lftmtxSuffix}"#pbmc1-15.cMono.pbmc1.chr1.lf_mtx
            outFileSort="${outChromSampleSortLftMtx_Prefix}${cell}.${sample}.chr${chr}${lftmtxSortSuffix}"
            grepThing="^${chr}:"
            grepThing2="${sample}_"
#             grep ${grepThing} ${inFile} | grep ${grepThing2} > ${outFile}
            sort -k1,1V -k2,2V  ${outFile} > ${outFileSort}
        done
    done
    
    ) &

done






