#!/usr/bin/env bash

Rbin=/usr/lib64/R/bin/Rscript
SCRIPT=/nfs/lab/jnewsome/scripts/peak_calls/compare_cicero_connections.r



oldCellTypesForCicFiles=(b        cd8_t    mono    pDC   cd4_t    mkc      nk)
outDir=/nfs/lab/jnewsome/pbmc/split_cicero_2/compare_oldpipe_pbmc1_15_pbmc1_12/


indir1=/nfs/lab/jnewsome/pbmc/split_cicero_2/old_cicero_chrom_chromMerged_conns_pythonDedupe/
# pbmc1-15.cMono.cicero_conns.sort.pyDedupe.txt
indir2=/nfs/lab/jnewsome/pbmc/split_cicero_2/oldCicero_pbmc1_12_OldData_withCoAScore/
# pbmc1to12.mkc.cicero_conns.loopDedupe.sort.txt


set=pbmc1_12
N=1
for cell1 in ${oldCellTypesForCicFiles[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    for cell2 in ${oldCellTypesForCicFiles[@]}; do
    
    
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "   compare    $cell    $set   $dt"
    infile_pbmc1_15="${indir1}pbmc1-15.${cell1}.cicero_conns.sort.pyDedupe.txt"
    infile_pbmc1_12="${indir2}pbmc1to12.${cell2}.cicero_conns.loopDedupe.sort.txt"
    outfile="${outDir}comparePBMC1_15.${cell1}._v_.PBMC1_12.${cell2}.txt"
    ${Rbin} ${SCRIPT} ${infile_pbmc1_15} ${infile_pbmc1_12} ${outfile}


    done
    ) &
done









echo "done!"
exit 0
