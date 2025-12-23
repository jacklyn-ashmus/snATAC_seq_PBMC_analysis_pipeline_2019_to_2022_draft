#!/usr/bin/env bash

fine_pops=(act_cd4_t cMono iMono mkc naive_cd8_t plasma adaptive_NK ncMono cyto_cd8_t mem_b naive_b tReg cDC cyto_nk  mem_cd8_t naive_cd4_t  pDC)
broad_pops=(b cd4_t cd8_t mkc mono nk pDC  plasma cd4_AND_cd8_t)
chroms=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)

SCRIPT_LESS_COL=/nfs/lab/jnewsome/scripts/general_bed_manipulation/reduceColAnd_3Col_Coord_to_1Col_intersectBed.py
SCRIPT_LONG_TO_SPARSE=/nfs/lab/jnewsome/scripts/general_bed_manipulation/longToSparse_script.py


DATA_SET_NAME=pbmc1-15
PBMC_DIR_NAME=/nfs/lab/jnewsome/pbmc/
LFT_MTX_SPLIT_DIR="${PBMC_DIR_NAME}split_lf_mtx/"
CHR_INFIX=.chr
BED_SUFFIX=.bed

peakBedPrefix="${LFT_MTX_SPLIT_DIR}pbmc.sorted.merged.bare.chr"


inFinePrefix="${LFT_MTX_SPLIT_DIR}fine/${DATA_SET_NAME}."
inFineSuffix=.sorted.fix.lf_mtx




FINE_DIR="${LFT_MTX_SPLIT_DIR}fine/"
BROAD_DIR="${LFT_MTX_SPLIT_DIR}broad/"
#######
FINE_BARCODES_DIR="${FINE_DIR}barcodes/"
BROAD_BARCODES_DIR="${BROAD_DIR}barcodes/"
######
FINE_INTERSECT_DIR="${FINE_DIR}intersect/"
BROAD_INTERSECT_DIR="${BROAD_DIR}intersect/"

SPLIT_PEAK_BED_PREFIX="${LFT_MTX_SPLIT_DIR}split_peak_bed/pbmc.sorted.merged.bare.chr"

######
FINE_INTERSECT_LESS_COL_DIR="${FINE_DIR}intersect_lessCol/"
BROAD_INTERSECT_LESS_COL_DIR="${BROAD_DIR}intersect_lessCol/"
######
FINE_LFT_FIX_DIR="${FINE_DIR}lft_fix/"
BROAD_LFT_FIX_DIR="${BROAD_DIR}lft_fix/"
######
FINE_MTX_DIR="${FINE_DIR}mtx/"
BROAD_MTX_DIR="${BROAD_DIR}mtx/"
######
FINE_BED_1COL_COORD_DIR="${FINE_DIR}orig_bed_1Col_Coord/"
BROAD_BED_1COL_COORD_DIR="${BROAD_DIR}orig_bed_1Col_Coord/"
#######
FINE_BED_3COL_COORD_DIR="${FINE_DIR}orig_bed_3Col_Coord/"
BROAD_BED_3COL_COORD_DIR="${BROAD_DIR}orig_bed_3Col_Coord/"
#######
FINE_SPARSE_DIR="${FINE_DIR}mtx/"
BROAD_SPARSE_DIR="${BROAD_DIR}mtx/"
#######



###### Orig 1 col bed file

fine_orig_bed_1Col_Prefix="${FINE_BED_1COL_COORD_DIR}${DATA_SET_NAME}."
broad_orig_bed_1Col_Prefix="${BROAD_BED_1COL_COORD_DIR}${DATA_SET_NAME}."
orig_bed_1Col_suffix=.sorted.lf_mtx

###### Orig 3 col bed file
fine_orig_bed_3Col_Prefix="${FINE_BED_3COL_COORD_DIR}${DATA_SET_NAME}."
broad_orig_bed_3Col_Prefix="${BROAD_BED_3COL_COORD_DIR}${DATA_SET_NAME}."
orig_bed_3Col_suffix=.sorted.fix.lf_mtx


###### Intersect (8 col) bed file 
fine_intersect_8col_Prefix="${FINE_INTERSECT_DIR}${DATA_SET_NAME}."
broad_intersect_8col_Prefix="${BROAD_INTERSECT_DIR}${DATA_SET_NAME}."
intersect_8col_Suffix=.Peak_intersect.bed

###### Intersect LESS COL (3 col) bed file 

intersectBed_LESS_COL_Suffix=.Peak_intersect.lessCol.bed
fine_intersect_LESS_COL_Prefix="${FINE_INTERSECT_LESS_COL_DIR}${DATA_SET_NAME}."
broad_intersect_LESS_COL_Prefix="${BROAD_INTERSECT_LESS_COL_DIR}${DATA_SET_NAME}."

###### MM MTX FILE
fine_mm_mtx_Prefix="${FINE_SPARSE_DIR}${DATA_SET_NAME}."
broad_mm_mtx_Prefix="${BROAD_SPARSE_DIR}${DATA_SET_NAME}."
marketMatrix_Suffix=.marketMatrix.mm






# for cell in ${fine_pops[@]}; do 
# for chr in ${chroms[@]}; do 
# echo "fine  $cell $chr"
# peakFile="${peakBedPrefix}${chr}${peakBedSuffix}"
# inFile="${inFinePrefix}${cell}${inFineInfix}${chr}${inFineSuffix}"
# outFile="${outFinePrefix}${cell}${outFineInfix}${chr}${outFineSuffix}"
# bedtools intersect -wa -wb -a ${peakFile} -b ${inFile} > ${outFile}



# done
# done



# for cell in ${broad_pops[@]}; do 
# for chr in ${chroms[@]}; do 
# echo "INTERSECT broad  $cell $chr"
# peakFile="${peakBedPrefix}${chr}${peakBedSuffix}"
# inFile="${inBroadPrefix}${cell}${inBroadInfix}${chr}${inBroadSuffix}"
# outFile="${outBroadPrefix}${cell}${outBroadInfix}${chr}${outBroadSuffix}"

# bedtools intersect -wa -wb -a ${peakFile} -b ${inFile} > ${outFile}


# done
# done




# cd4FilePrefix=/nfs/lab/jnewsome/pbmc/split_lf_mtx/broad_intersect/pbmc1-15.cd4_t.chr
# cd8FilePrefix=/nfs/lab/jnewsome/pbmc/split_lf_mtx/broad_intersect/pbmc1-15.cd8_t.chr
# cd4cd8FilePrefix=/nfs/lab/jnewsome/pbmc/split_lf_mtx/broad_intersect/pbmc1-15.cd4_AND_cd8_t.chr
# cd4InFileSuffix=.Peak_intersect.bed
# cd4cd8OutFileSuffix1=.Peak_intersect.UNSORT.bed

# # for chr in ${chroms[@]}; do 
# # echo "cat cd4 cd8 $chr"
# # cd4FileIn="${cd4FilePrefix}${chr}${cd4InFileSuffix}"
# # cd8FileIn="${cd8FilePrefix}${chr}${cd4InFileSuffix}"
# # cd4cd8FileOut_unsort="${cd4cd8FilePrefix}${chr}${cd4cd8OutFileSuffix1}"
# # cd4cd8FileOut="${cd4cd8FilePrefix}${chr}${cd4InFileSuffix}"
# # echo "       cat"
# # cat ${cd4FileIn} ${cd8FileIn} > ${cd4cd8FileOut_unsort}
# # echo "       sort"
# # sort -k1,1 -k2,2n ${cd4cd8FileOut_unsort} > ${cd4cd8FileOut}
# # echo "       rm"
# # rm ${cd4cd8FileOut_unsort}
# # done




######################################### INTERSECT LESS COL (3 col file) ######################################

# for cell in ${fine_pops[@]}; do 
# for chr in ${chroms[@]}; do 
# echo "LESS COL fine  $cell $chr"
# intersectBed_infile="${fine_intersect_8col_Prefix}${cell}${CHR_INFIX}${chr}${intersect_8col_Suffix}"
# intersectBed_outfile="${fine_intersect_LESS_COL_Prefix}${cell}${CHR_INFIX}${chr}${intersectBed_LESS_COL_Suffix}"
# python ${SCRIPT_LESS_COL} -i ${intersectBed_infile} -o ${intersectBed_outfile} 
# done
# done


# for cell in ${broad_pops[@]}; do 
# for chr in ${chroms[@]}; do 
# echo "LESS COL broad  $cell $chr"
# intersectBed_infile="${broad_intersect_8col_Prefix}${cell}${CHR_INFIX}${chr}${intersect_8col_Suffix}"
# intersectBed_outfile="${broad_intersect_LESS_COL_Prefix}${cell}${CHR_INFIX}${chr}${intersectBed_LESS_COL_Suffix}"
# python ${SCRIPT_LESS_COL} -i ${intersectBed_infile} -o ${intersectBed_outfile} 
# done
# done



######################################### LONG FMT TO SPARSE MATRIIX ######################################

# for cell in ${fine_pops[@]}; do 
# for chr in ${chroms[@]}; do 
# echo "long to SPARSE MTX fine  $cell $chr"
# lessCol_intersectBedFile="${fine_intersect_LESS_COL_Prefix}${cell}${CHR_INFIX}${chr}${intersectBed_LESS_COL_Suffix}"
# mm_File="${fine_mm_mtx_Prefix}${cell}${CHR_INFIX}${chr}${marketMatrix_Suffix}"
# sampleName="${cell}.${chr}"
# python ${SCRIPT_LONG_TO_SPARSE} -i ${lessCol_intersectBedFile} -o ${mm_File}  -s ${sampleName}
# done
# done

for cell in ${broad_pops[@]}; do 
for chr in ${chroms[@]}; do 
echo "long to SPARSE MTX broad  $cell $chr"
lessCol_intersectBedFile="${broad_intersect_LESS_COL_Prefix}${cell}${CHR_INFIX}${chr}${intersectBed_LESS_COL_Suffix}"
mm_File="${broad_mm_mtx_Prefix}${cell}${CHR_INFIX}${chr}${marketMatrix_Suffix}"
sampleName="${cell}.${chr}"
python ${SCRIPT_LONG_TO_SPARSE} -i ${lessCol_intersectBedFile} -o ${mm_File}  -s ${sampleName}
done
done





echo "ALL DONE !!!!"

exit 0
