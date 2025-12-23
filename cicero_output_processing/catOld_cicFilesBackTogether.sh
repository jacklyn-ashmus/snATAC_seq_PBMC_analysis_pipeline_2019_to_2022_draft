#!/usr/bin/env bash

oldCellTypes=(Bcell CD8_T-cell Monocyte pDC CD4_T-cell Megakaryocyte NK_cell)

inDir=/nfs/lab/projects/pbmc_snATAC/pipeline/snATAC/cicero/pbmc1_12/macro/coaPairSorted/
samplePrefix=pbmc1to12.cicero.

outDir=/nfs/lab/jnewsome/pbmc/split_cicero_2/oldCicero_pbmc1_12_OldData/



N=8
# for cell in ${oldCellTypes[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "   OLD   cat    $cell   $dt"

#     cc_neg="${inDir}${samplePrefix}CC_${cell}_Neg.txt" # pbmc1to12.cicero.CC_Bcell_Neg.txt
#     cc_pos="${inDir}${samplePrefix}CC_${cell}_Pos.txt" # pbmc1to12.cicero.CC_Bcell_Neg.txt
#     cc_zero="${inDir}${samplePrefix}CC_${cell}_Zero.txt" # pbmc1to12.cicero.CC_Bcell_Neg.txt
#     cp_neg="${inDir}${samplePrefix}CP_${cell}_Neg.txt" # pbmc1to12.cicero.CC_Bcell_Neg.txt
#     cp_pos="${inDir}${samplePrefix}CP_${cell}_Pos.txt" # pbmc1to12.cicero.CC_Bcell_Neg.txt
#     cp_zero="${inDir}${samplePrefix}CP_${cell}_Zero.txt" # pbmc1to12.cicero.CC_Bcell_Neg.txt
#     pp_neg="${inDir}${samplePrefix}PP_${cell}_Neg.txt" # pbmc1to12.cicero.CC_Bcell_Neg.txt
#     pp_pos="${inDir}${samplePrefix}PP_${cell}_Pos.txt" # pbmc1to12.cicero.CC_Bcell_Neg.txt
#     pp_zero="${inDir}${samplePrefix}PP_${cell}_Zero.txt" # pbmc1to12.cicero.CC_Bcell_Neg.txt

#     outnameSort="${outDir}${samplePrefix}${cell}.conns.maybe_dedupe.sort.txt"
#     outnameSortTemp="${outDir}${samplePrefix}${cell}.conns.maybe_dedupe.tempnoHeaderSort.txt"
#     outnameSortTempHeader="${outDir}${samplePrefix}${cell}.conns.maybe_dedupe.tempHeader.txt"
#     outnameTempCAT="${outDir}${samplePrefix}${cell}.conns.maybe_dedupe.tempCat.txt"
#     outnameTempGREP="${outDir}${samplePrefix}${cell}.conns.maybe_dedupe.tempGrep.txt"
    
#     echo "        cat all"
#     cat ${cc_neg} ${cc_pos} ${cc_zero} ${cp_neg} ${cp_pos} ${cp_zero} ${pp_neg} ${pp_pos} ${pp_zero} > ${outnameTempCAT}
#     echo "        grep"
#     grep -v "Peak1" ${outnameTempCAT} > ${outnameTempGREP}
#     echo "        sort"
#     sort -k1,1V -k2,2V ${outnameTempGREP} > ${outnameSortTemp}
#     echo "        header"
#     echo "Peak1 Peak2 Peak1_Promoter Peak2_Promoter\n" > ${outnameSortTempHeader}
#     echo "        cat with header"
#     cat ${outnameSortTempHeader} ${outnameSortTemp} > ${outnameSort}
    
#     echo "        rm other files"
#     rm ${outnameSortTemp}
#     rm ${outnameSortTempHeader}
#     rm ${outnameTempCAT}
#     rm ${outnameTempGREP}
#      ) &
# done


pops=(act_cd4_t cd4_AND_cd8_t cDC cyto_nk mem_cd8_t naive_b ncMono plasma adaptive_NK cd4_t cMono iMono mkc naive_cd4_t nk tReg b cd8_t cyto_cd8_t mem_b mono naive_cd8_t pDC)


inDir=/nfs/lab/jnewsome/pbmc/split_cicero_2/old_cicero_chrom/
outDir1=/nfs/lab/jnewsome/pbmc/split_cicero_2/old_cicero_chrom_chromMerged_conns/
outDir2=/nfs/lab/jnewsome/pbmc/split_cicero_2/old_cicero_chrom_chromMerged_connsDedupe/



# samplePrefix=pbmc1-15.
# set="conns"
# for cell in ${pops[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "   oldPipeline   cat    $cell    $set   $dt"
    
    
#     inFileMatch="${inDir}pbmc1-15.${cell}.chr*.cicero_conns.txt"
    
#     outDir="${outDir1}"
    
#     outnameSort="${outDir}${samplePrefix}${cell}.cicero_conns.sort.txt"
#     outnameSortTemp="${outDir}${samplePrefix}${cell}.cicero_conns.tempnoHeaderSort.txt"
#     outnameSortTempHeader="${outDir}${samplePrefix}${cell}.cicero_conns.maybe_dedupe.tempHeader.txt"
#     outnameTempCAT="${outDir}${samplePrefix}${cell}.cicero_conns.tempCat.txt"
#     outnameTempGREP="${outDir}${samplePrefix}${cell}.cicero_conns.tempGrep.txt"
    
#     echo "        cat all $cell $set"
#     cat ${inFileMatch} > ${outnameTempCAT}
#     echo "        grep $cell $set"
#     grep -v "Peak1" ${outnameTempCAT} > ${outnameTempGREP}
#     echo "        sort $cell $set"
#     sort -k1,1V -k2,2V ${outnameTempGREP} > ${outnameSortTemp}
#     echo "        header $cell $set"
#     echo "Peak1   Peak2   coaccess" > ${outnameSortTempHeader}
#     echo "        cat with header $cell $set"
#     cat ${outnameSortTempHeader} ${outnameSortTemp} > ${outnameSort}
    
#     echo "        rm other files $cell $set"
#     rm ${outnameSortTemp}
#     rm ${outnameSortTempHeader}
#     rm ${outnameTempCAT}
#     rm ${outnameTempGREP}
#     ) &
# done



# set="conns dedupe"
# for cell in ${pops[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "   oldPipeline   cat    $cell    $set   $dt"
    
    
#     inFileMatch="${inDir}pbmc1-15.${cell}.chr*.cicero_conns_dedup.txt"
    
#     outDir="${outDir2}"
    
#     outnameSort="${outDir}${samplePrefix}${cell}.cicero_conns_dedup.sort.txt"
#     outnameSortTemp="${outDir}${samplePrefix}${cell}.cicero_conns_dedup.tempnoHeaderSort.txt"
#     outnameSortTempHeader="${outDir}${samplePrefix}${cell}.cicero_conns_dedup.maybe_dedupe.tempHeader.txt"
#     outnameTempCAT="${outDir}${samplePrefix}${cell}.cicero_conns_dedup.tempCat.txt"
#     outnameTempGREP="${outDir}${samplePrefix}${cell}.cicero_conns_dedup.tempGrep.txt"
    
#     echo "        cat all $cell $set"
#     cat ${inFileMatch} > ${outnameTempCAT}
#     echo "        grep $cell $set"
#     grep -v "Peak1" ${outnameTempCAT} > ${outnameTempGREP}
#     echo "        sort $cell $set"
#     sort -k1,1V -k2,2V ${outnameTempGREP} > ${outnameSortTemp}
#     echo "        header $cell $set"
#     echo "Peak1   Peak2   coaccess" > ${outnameSortTempHeader}
#     echo "        cat with header $cell $set"
#     cat ${outnameSortTempHeader} ${outnameSortTemp} > ${outnameSort}
    
#     echo "        rm other files $cell $set"
#     rm ${outnameSortTemp}
#     rm ${outnameSortTempHeader}
#     rm ${outnameTempCAT}
#     rm ${outnameTempGREP}
#     ) &
# done




# inDir=/nfs/lab/projects/pbmc_snATAC/pipeline/snATAC/cicero/pbmc1_12/macro/promLabelled_Sorted_perCellType_v2/
# outDir=/nfs/lab/jnewsome/pbmc/split_cicero_2/oldCicero_pbmc1_12_OldData_withCoAScore/


# N=8
# for cell in ${oldCellTypes[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "   OLD w coa   cat    $cell   $dt"

#     cc_neg="${inDir}pbmc1to12.Macro.${cell}.CC.Neg.cicero_conns.loopDedupe.txt" # pbmc1to12.Macro.B-cell.CC.Neg.cicero_conns.loopDedupe.txt
#     cc_pos="${inDir}pbmc1to12.Macro.${cell}.CC.Pos.cicero_conns.loopDedupe.txt" 
#     cc_zero="${inDir}pbmc1to12.Macro.${cell}.CC.Zero.cicero_conns.loopDedupe.txt"
#     cp_neg="${inDir}pbmc1to12.Macro.${cell}.CP.Neg.cicero_conns.loopDedupe.txt"
#     cp_pos="${inDir}pbmc1to12.Macro.${cell}.CP.Pos.cicero_conns.loopDedupe.txt"
#     cp_zero="${inDir}pbmc1to12.Macro.${cell}.CP.Zero.cicero_conns.loopDedupe.txt" 
#     pp_neg="${inDir}pbmc1to12.Macro.${cell}.PP.Neg.cicero_conns.loopDedupe.txt"
#     pp_pos="${inDir}pbmc1to12.Macro.${cell}.PP.Pos.cicero_conns.loopDedupe.txt"
#     pp_zero="${inDir}pbmc1to12.Macro.${cell}.PP.Zero.cicero_conns.loopDedupe.txt" 

#     outnameSort="${outDir}pbmc1to12.Macro.${cell}.cicero_conns.loopDedupe.sort.txt"
#     outnameSortTemp="${outDir}pbmc1to12.Macro.${cell}.cicero_conns.loopDedupe.tempnoHeaderSort.txt"
#     outnameSortTempHeader="${outDir}pbmc1to12.Macro.${cell}.cicero_conns.loopDedupe.tempHeader.txt"
#     outnameTempCAT="${outDir}pbmc1to12.Macro.}${cell}.cicero_conns.loopDedupe.tempCat.txt"
#     outnameTempGREP="${outDir}pbmc1to12.Macro.${cell}.cicero_conns.loopDedupe.tempGrep.txt"
    
#     echo "        cat all"
#     cat ${cc_neg} ${cc_pos} ${cc_zero} ${cp_neg} ${cp_pos} ${cp_zero} ${pp_neg} ${pp_pos} ${pp_zero} > ${outnameTempCAT}
#     echo "        grep"
#     grep -v "Peak1" ${outnameTempCAT} > ${outnameTempGREP}
#     echo "        sort"
#     sort -k1,1V -k2,2V ${outnameTempGREP} > ${outnameSortTemp}
#     echo "        header"
#     echo "Peak1 Peak2 coaccess Peak1_Promoter Peak2_Promoter" > ${outnameSortTempHeader}
#     echo "        cat with header"
#     cat ${outnameSortTempHeader} ${outnameSortTemp} > ${outnameSort}
    
#     echo "        rm other files"
#     rm ${outnameSortTemp}
#     rm ${outnameSortTempHeader}
#     rm ${outnameTempCAT}
#     rm ${outnameTempGREP}
#      ) &
# done


samplePrefix=pbmc1-15.

# set="conns"
# for cell in ${pops[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "   oldPipeline   cat    $cell    $set   $dt"
    
    
#     inFileMatch="${inDir}pbmc1-15.${cell}.chr*.cicero_conns.txt"
    
#     outDir="${outDir1}"
    
#     outnameSort="${outDir}${samplePrefix}${cell}.cicero_conns.sort.txt"
#     outnameSortTemp="${outDir}${samplePrefix}${cell}.cicero_conns.tempnoHeaderSort.txt"
#     outnameSortTempHeader="${outDir}${samplePrefix}${cell}.cicero_conns.maybe_dedupe.tempHeader.txt"
#     outnameTempCAT="${outDir}${samplePrefix}${cell}.cicero_conns.tempCat.txt"
#     outnameTempGREP="${outDir}${samplePrefix}${cell}.cicero_conns.tempGrep.txt"
    
#     echo "        cat all $cell $set"
#     cat ${inFileMatch} > ${outnameTempCAT}
#     echo "        grep $cell $set"
#     grep -v "Peak1" ${outnameTempCAT} > ${outnameTempGREP}
#     echo "        sort $cell $set"
#     sort -k1,1V -k2,2V ${outnameTempGREP} > ${outnameSortTemp}
#     echo "        header $cell $set"
#     echo "Peak1   Peak2   coaccess" > ${outnameSortTempHeader}
#     echo "        cat with header $cell $set"
#     cat ${outnameSortTempHeader} ${outnameSortTemp} > ${outnameSort}
    
#     echo "        rm other files $cell $set"
#     rm ${outnameSortTemp}
#     rm ${outnameSortTempHeader}
#     rm ${outnameTempCAT}
#     rm ${outnameTempGREP}
#     ) &
# done


# samplePrefix=pbmc1-15.
# set="conns dedupe"
# for cell in ${pops[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "   oldPipeline   fix header    $cell    $set   $dt"
#     var="Peak1   Peak2   coaccess"
#     outDir="${outDir2}"
    
#     outnameSort="${outDir}${samplePrefix}${cell}.cicero_conns_dedup.sort.txt"
#     sed -i "1s/.*/$var/" ${outnameSort}
#     ) &
# done


# set="conns"
# for cell in ${pops[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait

# 	(
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "   oldPipeline   fix header    $cell    $set   $dt"
#     var="Peak1   Peak2   coaccess"
#     outDir="${outDir1}"
    
#     outnameSort="${outDir}${samplePrefix}${cell}.cicero_conns.sort.txt"
#     sed -i "1s/.*/$var/" ${outnameSort}
#     ) &
# done



oldCellTypesForCicFiles=(b        cd8_t    mono    pDC   cd4_t    mkc      nk)
outDir=/nfs/lab/jnewsome/pbmc/split_cicero_2/oldCicero_pbmc1_12_OldData_withCoAScore/

set=pbmc1_12

for cell in ${oldCellTypesForCicFiles[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "   oldPipeline   fix header    $cell    $set   $dt"
    var="Peak1 Peak2 coaccess Peak1_Promoter Peak2_Promoter"
    outnameSort="${outDir}pbmc1to12.${cell}.cicero_conns.loopDedupe.sort.txt"
    sed -i "1s/.*/$var/" ${outnameSort}
    ) &
done



echo "done!"
exit 0
