#!/usr/bin/env bash


cellTypes=(adaptive_NK  cDC cyto_cd8_t cyto_nk mem_b mem_cd8_t mkc naive_b naive_cd4_t naive_cd8_t ncMono pDC plasma tReg iMono cMono)
inDir=/nfs/lab/projects/pbmc_snATAC/pipeline/snATAC/combined_files/pbmc1to15/lf_mtx/fine_pop/
infilePrefix=/nfs/lab/projects/pbmc_snATAC/pipeline/snATAC/combined_files/pbmc1to15/lf_mtx/fine_pop/pbmc1-15.
infileSuffix=.lf_mtx.gz
outfileSuffix=.mm

script=/nfs/lab/jnewsome/longToSparse_script.py

N=2

for cell in ${cellTypes[@]}; do 
	((i=i%N)); ((i++==0)) && wait
	(
    echo "${cell}"
    infileName="${infilePrefix}${cell}${infileSuffix}"
    outfileName="${infilePrefix}${cell}${outfileSuffix}"
    
    python ${script} -i ${infileName} -o ${outfileName} -s ${cell}
    ) &

done

