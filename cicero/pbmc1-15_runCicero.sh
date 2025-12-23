#!/usr/bin/env bash

fine_pops=(act_cd4_t cMono iMono mkc naive_cd8_t plasma adaptive_NK ncMono cyto_cd8_t mem_b naive_b tReg cDC cyto_nk  mem_cd8_t naive_cd4_t  pDC)
broad_pops=(b cd4_t cd8_t mkc mono nk pDC  plasma cd4_AND_cd8_t)
chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)


RSCRIPT_NAME=/nfs/lab/jnewsome/scripts/pbmc_cicero/run_Cicero_general.r

CHR_INFIX=.chr

fine_mtx_prefix=/nfs/lab/jnewsome/pbmc/split_lf_mtx/fine/mtx/pbmc1-15.
broad_mtx_prefix=/nfs/lab/jnewsome/pbmc/split_lf_mtx/broad/mtx/pbmc1-15.
mtx_suffix=.marketMatrix.mm.mtx
cell_suffix=.marketMatrix.mm.cells
peak_suffix=.marketMatrix.mm.peaks

fine_metafile_prefix=/nfs/lab/jnewsome/pbmc/split_lf_mtx/split_metadata/fine/pbmc1-15.cluster.metadata.
broad_metafile_prefix=/nfs/lab/jnewsome/pbmc/split_lf_mtx/split_metadata/broad/pbmc1-15.cluster.metadata.
metafile_suffix=.2021-10-15.txt

cicero_output_FINE_prefixPrefix=/nfs/lab/jnewsome/pbmc/split_cicero/fine/pbmc1-15.
cicero_output_BROAD_prefixPrefix=/nfs/lab/jnewsome/pbmc/split_cicero/fine/pbmc1-15.

clusterColName_FINE=fine_populations
clusterColName_BROAD=broad_populations








N=4

for cell in ${fine_pops[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    for chr in ${chroms[@]}; do 
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "run cicero fine  $cell $chr        $dt"

        matrixFile="${fine_mtx_prefix}${cell}${CHR_INFIX}${chr}${mtx_suffix}"
        barfile="${fine_mtx_prefix}${cell}${CHR_INFIX}${chr}${cell_suffix}"
        peaksfile="${fine_mtx_prefix}${cell}${CHR_INFIX}${chr}${peak_suffix}"
        metafile="${fine_metafile_prefix}${cell}${CHR_INFIX}${chr}${metafile_suffix}"
        outputFilePrefix="${cicero_output_FINE_prefixPrefix}${cell}${CHR_INFIX}${chr}"
        clusterColName="${clusterColName_FINE}"

        # matrixFile = args[1]
        # barfile = args[2]
        # peaksfile = args[3]
        # metafile = args[4]
        # clusterColName = args[5]
        # outputFilePrefix = args[6]
        #                        1             2               3          4             5                  6
        Rscript ${RSCRIPT_NAME} ${matrixFile} ${barfile} ${peaksfile} ${metafile} ${clusterColName} ${outputFilePrefix}

    done
    
    ) &

done



N=4

for cell in ${broad_pops[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    for chr in ${chroms[@]}; do 
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "run cicero broad  $cell $chr        $dt"

        matrixFile="${broad_mtx_prefix}${cell}${CHR_INFIX}${chr}${mtx_suffix}"
        barfile="${broad_mtx_prefix}${cell}${CHR_INFIX}${chr}${cell_suffix}"
        peaksfile="${broad_mtx_prefix}${cell}${CHR_INFIX}${chr}${peak_suffix}"
        metafile="${broad_metafile_prefix}${cell}${CHR_INFIX}${chr}${metafile_suffix}"
        outputFilePrefix="${cicero_output_BROAD_prefixPrefix}${cell}${CHR_INFIX}${chr}"
        clusterColName="${clusterColName_BROAD}"


        Rscript ${RSCRIPT_NAME} ${matrixFile} ${barfile} ${peaksfile} ${metafile} ${clusterColName} ${outputFilePrefix}



    done
    
    ) &

done



echo "ALL DONE !!!!"

exit 0
