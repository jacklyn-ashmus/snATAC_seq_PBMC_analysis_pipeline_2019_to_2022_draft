#!/usr/bin/env bash



pops=(act_cd4_t cd4_AND_cd8_t cDC cyto_nk mem_cd8_t naive_b ncMono plasma adaptive_NK cd4_t cMono iMono mkc naive_cd4_t nk tReg b cd8_t cyto_cd8_t mem_b mono naive_cd8_t pDC)
inDir=/nfs/lab/jnewsome/pbmc/cicero_v3/ciceroOut_b/


outDirPy=/nfs/lab/jnewsome/pbmc/cicero_v3/ciceroOut_mergeCounts_dedupe/
catDir=/nfs/lab/jnewsome/pbmc/cicero_v3/ciceroOut_mergeCounts_cat/



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


inPrefix="${inDir}pbmc1-15."
inSuffix=.cicero_conns.txt


catPrefix="${inDir}pbmc1-15."
catSuffix=.cicero_conns.txt

outPrefix="${outDirPy}pbmc1-15."
outSuffix=.cicero_conns.sort.dedupePy.txt

outSortSuffix=.cicero_conns.sort.txt


mkdir ${outDirPy}
mkdir ${catDir}

catFilesDir=/nfs/lab/jnewsome/pbmc/cicero_v3/ciceroOut_catFiles/

pops=(b)

pyscript=/nfs/lab/jnewsome/scripts/cicero_output_processing/dedupeCiceroLoopFile_withPython.py

N=1
for cell in ${pops[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "   py dedupe    $cell    $dt"
    catQuery="${inPrefix}${cell}.*.cicero_conns.txt"
    catFile="${catPrefix}${cell}.cicero_conns.txt"
    
    sortfile="${outPrefix}${cell}${outSortSuffix}"
    outfile="${outPrefix}${cell}${outSuffix}"
    
    echo "cat $cell"
    cat ${catQuery} > ${catFile}
    echo "'sort'' cat' $cell"
    sort -k1,1V -k2,2V ${catFile} > ${sortfile}
    echo "dedupe sort cat $cell"
    python ${pyscript} -i ${sortfile} -o ${outfile}
    ) &
done

echo "done!"
exit 0


