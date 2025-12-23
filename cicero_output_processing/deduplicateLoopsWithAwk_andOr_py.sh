#!/usr/bin/env bash



pops=(act_cd4_t cd4_AND_cd8_t cDC cyto_nk mem_cd8_t naive_b ncMono plasma adaptive_NK cd4_t cMono iMono mkc naive_cd4_t nk tReg b cd8_t cyto_cd8_t mem_b mono naive_cd8_t pDC)
inDir=/nfs/lab/jnewsome/pbmc/cicero_v4/conns/
outDirAwk=/nfs/lab/jnewsome/pbmc/split_cicero_2/old_cicero_chrom_chromMerged_conns_awkDedupe/
outDirPy=/nfs/lab/jnewsome/pbmc/cicero_v4/conns_pydedupe/

samplePrefix=pbmc1-15.
# N=8
# for cell in ${pops[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "   awk dedupe    $cell    $dt"
    
    
#     infile="${inDir}pbmc1-15.${cell}.cicero_conns.sort.txt"
#     outfile="${outDirAwk}pbmc1-15.${cell}.cicero_conns.sort.awkDedupe.txt"
#     awk '!seen[$0]++' ${infile} > ${outfile}
#     ) &
# done



pops=( b )


pyscript=/nfs/lab/jnewsome/scripts/cicero_output_processing/dedupeCiceroLoopFile_withPython.py

N=1
for cell in ${pops[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "   py dedupe    $cell    $dt"
    
    
    infile="${inDir}${samplePrefix}${cell}.cicero_conns.sort.txt"
    outfile="${outDirPy}${samplePrefix}${cell}.cicero_conns.sort.pyDedupe.txt"
    python ${pyscript} -i ${infile} -o ${outfile}
    ) &
done

echo "done!"
exit 0


