#!/usr/bin/env bash

Rbin=/usr/lib64/R/bin/Rscript
SCRIPT=/nfs/lab/jnewsome/scripts/peak_calls/compare_cicero_connections.r



oldCellTypesForCicFiles=(b        cd8_t    mono    pDC   cd4_t    mkc      nk)
outDir=/nfs/lab/jnewsome/pbmc/split_cicero_2/compare_oldpipe_pbmc1_15_pbmc1_12/


indir1=/nfs/lab/jnewsome/pbmc/split_cicero/fine/ # pbmc1-15.cd8_t.cicero_conns_dedup.sort.txt

indir2=/nfs/lab/jnewsome/pbmc/split_cicero_2/oldCicero_pbmc1_12_OldData_withCoAScore/
# pbmc1to12.mkc.cicero_conns.loopDedupe.sort.txt
outdir=/nfs/lab/jnewsome/pbmc/split_cicero_2/compare_oldPipe_newPipe_comm/

#/nfs/lab/jnewsome/pbmc/split_cicero_2/compare_oldpipe_pbmc1_15_pbmc1_12/comparePBMC1_15_new._v_.PBMC1_15_old.txt

pops=(act_cd4_t cd4_AND_cd8_t cDC cyto_nk mem_cd8_t naive_b ncMono plasma adaptive_NK cd4_t cMono iMono mkc naive_cd4_t nk tReg b cd8_t cyto_cd8_t mem_b mono naive_cd8_t pDC)
pops=(b        cd8_t    mono    pDC   cd4_t    mkc      nk)

set=pbmc1_12
N=1

outfile="${outDir}comparePBMC1_15_new._v_.PBMC1_15_old.txt"
echo "" > $outfile

for cell1 in ${pops[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    for cell2 in ${pops[@]}; do
    
    
    # sizeA=$(wc -l ${tagalignFile})
    
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "   compare    $cell1 $cell2      $dt"
    infile_pbmc1_15_new="/nfs/lab/jnewsome/pbmc/split_cicero_2/old_cicero_chrom_chromMerged_conns_pythonDedupe/justLoops/pbmc1-15.${cell1}.cicero_conns.sort.pyDedupe.txt"
    
    sortFile_1="/nfs/lab/jnewsome/pbmc/split_cicero_2/old_cicero_chrom_chromMerged_conns_pythonDedupe/justLoops/pbmc1-15.${cell1}.cicero_conns.sort.pyDedupe.plainsort.txt"
    
    sortFile_2="/nfs/lab/jnewsome/pbmc/split_cicero/fine/justLoops/pbmc1-15.${cell2}.cicero_conns_dedup.sort.loopsOnly.plainsort.txt"
    
    
        
    dedupFile_1="/nfs/lab/jnewsome/pbmc/split_cicero_2/old_cicero_chrom_chromMerged_conns_pythonDedupe/justLoops/pbmc1-15.${cell1}.cicero_conns.sort.pyDedupe.dedupe.txt"
    
    dedupFile_2="/nfs/lab/jnewsome/pbmc/split_cicero/fine/justLoops/pbmc1-15.${cell2}.cicero_conns_dedup.sort.loopsOnly.dedupe.txt"
    
    
    
    
    infile_pbmc1_15_old="/nfs/lab/jnewsome/pbmc/split_cicero/fine/justLoops/pbmc1-15.${cell2}.cicero_conns_dedup.sort.loopsOnly.txt"
#     outfile="${outDir}comparePBMC1_15_new.${cell1}._v_.PBMC1_15_old.${cell2}.txt"

    echo "                    dedupe $cell1 $cell2   $cell1"
    awk '!seen[$0]++' ${infile_pbmc1_15_new} > ${dedupFile_1}
    echo "                    sort $cell1 $cell2   $cell1"
    
    sort -k1,1 -k2,2 ${dedupFile_1} > ${sortFile_1}
    
    
    echo "                    dedupe $cell1 $cell2   $cell2"
    awk '!seen[$0]++' ${infile_pbmc1_15_old} > ${dedupFile_2}
    echo "                    sort $cell1 $cell2   $cell2"
    
    sort -k1,1 -k2,2 ${infile_pbmc1_15_old} > ${sortFile_2}
     echo "                    comm $cell1 $cell2   "
    intersect=$(comm -1 -2 ${sortFile_1} ${sortFile_2} | wc -l)
    echo "${cell1}_new ${cell2}_old ${intersect}"
    echo "${cell1}_new ${cell2}_old ${intersect}" >> ${outfile}
    
    
    
    done
    ) &
done



N=4


# for cell1 in ${pops[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#     # sizeA=$(wc -l ${tagalignFile})
    
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "   loop    $cell    $set   $dt"
    
#     infile="/nfs/lab/jnewsome/pbmc/split_cicero/fine/pbmc1-15.${cell1}.cicero_conns_dedup.sort.txt"
#     outfile="/nfs/lab/jnewsome/pbmc/split_cicero/fine/justLoops/pbmc1-15.${cell1}.cicero_conns_dedup.sort.loopsOnly.txt"
    
#     awk '{print $1,$2}' ${infile} > ${outfile}
#     ) &
# done


# indir=
# outdir=/nfs/lab/jnewsome/pbmc/split_cicero_2/old_cicero_chrom_chromMerged_conns_pythonDedupe/justLoops/

# N=4


# for cell1 in ${pops[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#     # sizeA=$(wc -l ${tagalignFile})
    
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "   loop    $cell    $set   $dt"
    
#     infile="/nfs/lab/jnewsome/pbmc/split_cicero_2/old_cicero_chrom_chromMerged_conns_pythonDedupe/pbmc1-15.${cell1}.cicero_conns.sort.pyDedupe.txt"
#     outfile="/nfs/lab/jnewsome/pbmc/split_cicero_2/old_cicero_chrom_chromMerged_conns_pythonDedupe/justLoops/pbmc1-15.${cell1}.cicero_conns.sort.pyDedupe.txt"
    
#     awk '{print $1,$2}' ${infile} > ${outfile}
#     ) &
# done



echo "done!"
exit 0
