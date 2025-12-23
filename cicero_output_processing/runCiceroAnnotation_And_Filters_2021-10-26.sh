#!/usr/bin/env bash

INPUT_CICERO_DEDUPE_FILE=$1
OUT_DIR=$2
SAMPLE_NAME=$3
CELLTYPE_NAME=$4


# /nfs/lab/projects/pbmc_snATAC/analysis_v2/peaks/pbmc.sorted.merged.bare.bed
# /nfs/lab/jnewsome/pbmc/cicero_anno_2021

# readarray -t a < /path/to/filename
# IFS=$'\n' read -d '' -r -a lines < /etc/passwd

PROM_REFERENCE_FILE=/nfs/lab/jnewsome/references/gencode.v19.1kb_all_possible_transcripts.bed





refPyScript=/nfs/lab/jnewsome/scripts/cicero_output_processing/old_scripts/annotate_WithPromoters/makePeakReferenceFile_v2020-03-25.py
refloopLabelScript=/home/jnewsome/labelLoopRefFileWithPromoters_2020-03-26.py
ciceroLoopLabelScript=/nfs/lab/jnewsome/scripts/cicero_output_processing/old_scripts/annotate_WithPromoters/labelCiceroFileWithPromoters_2020-03-26.py
mergeScript=/home/jnewsome/mergeAllCellFilesToTable_pbmcMacro.py


/nfs/lab/jnewsome/scripts/cicero_output_processing/makePeakReferenceFile_v2021-10-26.py




PROM_REF_FILE=/nfs/lab/jnewsome/references/gencode.v19.1kb_all_possible_transcripts.bed




# Remember:
#    - replace all things in brackets ([]) with your inputs, removing the brackets themselves.
#    - bash scripting doesn't allow for spaces before or after '=' in variable assignment, so everything has to be like 'inputDirectory=/nfs/lab/projects/pbmc_snATAC/pipeline/snATAC/cicero/macro/'
#    - you can use the same directory for most things, if you want. Just make sure that you have a separate directory for anything that you're going to use 'ls > file list' on, since these files will get concatenated together
#            ie. the original input files, and the promoter labelled cicero files


# Steps:
#   1. Make a single file with all of the pairs/loops/wtvr in every cell type
#   2. remove the coaccess score column. we don't need them for this reference file we're making
#   3. deduplicate this new file
#   4. make a reference file with every unique loop in the dataset, along with a reference file with single peaks that are labelled with an associated id
#   5. intersect single peak reference file with promoter reference file
#   6. remove unneccessary columns
#   7. match this file back to the reference loop file, using the id
#   8. match loop promoter labelled back to original cell type specific loops to label those
#   9. merge everything to a single table



samplePrefix=[YOUR SAMPLE PREFIX] # ex: islet_cytokineHigh_ or whatever

pyBin=/home/data/anaconda3/bin/python
refPyScript=/home/jnewsome/makePeakReferenceFile_v2020-03-25.py
promReferenceFile=/home/joshchiou/references/gencode.v19.1kb_all_possible_transcripts.bed
refloopLabelScript=/home/jnewsome/labelLoopRefFileWithPromoters_2020-03-26.py
ciceroLoopLabelScript=/home/jnewsome/labelCiceroFileWithPromoters_2020-03-26.py
mergeScript=/home/jnewsome/mergeAllCellFilesToTable_pbmcMacro.py

####### Input directory with re-ordered cicero output files, eg , 'cicero_conns_dedup.orderFix.txt' or whatever #######
inputDirectory=[DIRECTORY WITH INPUT FILES] # /folder/folder/folder/    # MAKE SURE THAT ONLY YOUR INPUT FILES ARE IN THIS DIRECTORY !!
inputFilePrefix="${inputDirectory}[YOUR FILE PREFIX]" # ex: pbmc.Macro.cicerosdfsdfdfsdfsdfsdfsdf.
inputFileSuffix=[YOUR FILE SUFFIX] # ex: .cicero_conns_dedup.orderFix.txt
inputFileListFile="${inputDirectory}fileList.txt" # ex: pbmc.Macro.cicerosdfsdfdfsdfsdfsdfsdf.

####### Directory for 1st step, cellTypeMerge #######
mergedDir=[DIRECTORY FOR MERGED FILE OUTPUT] # /folder/folder/folder/
mergedFileName="${mergedDir}[NAME OF OUTPUT MERGED FILE]"  # ex: mergedIsletCiceroOutput.cicero_conns_dedup.orderFix.txt
loopOnlyMergedFileName="${mergedDir}[NAME OF OUTPUT MERGED LOOP ONLY FILE]" # ex: mergedIsletCiceroOutput.cicero_conns_dedup.orderFix.loopOnly.txt
dedupLoopOnlyMergedFileName="${mergedDir}[NAME OF OUTPUT MERGED LOOP ONLY DEDUPLICATED FILE]" # ex: mergedIsletCiceroOutput.cicero_conns_dedup.orderFix.loopOnly.dedup.txt


####### Directory for 2nd step, reference files creation #############
refFileDirectory=[DIRECTORY FOR MERGED FILE OUTPUT] # /folder/folder/folder/
refPeakFile="${refFileDirectory}[YOUR REFERENCE PEAK FILE NAME]" # ex: islet_refFile_IsletMerged_allIndividualPeaksReferenceFile_withID.bed
refLoopFile="${refFileDirectory}[YOUR REFERENCE LOOP FILE NAME]" # ex: islet_refFile_IsletMerged_loopReferenceFile_withID.bed
sortedRefPeakFile="${refFileDirectory}[YOUR REFERENCE LOOP FILE NAME]" # ex: islet_refFile_IsletMerged_allIndividualPeaksReferenceFile_withID.sorted.bed


###### Directory for 3rd step, intersecting with promoter reference file ##################
intersectedRefPeakFileDirectory=[DIRECTORY FOR INTERSECTED FILES] # /folder/folder/folder/
intersectedRefPeakFile="${intersectedRefPeakFileDirectory}[YOUR REFERENCE PEAK FILE NAME]"  # ex: islet_refFile_IsletMerged_promoterIntersectedRefPeak_withID.withExtraCols.bed
intersectedRefPeakLessColumnsFiles="${intersectedRefPeakFileDirectory}[YOUR REFERENCE PEAK FILE, LESS COLUMN NAME]"  # ex: islet_refFile_IsletMerged_promoterIntersectedRefPeak_withID.bed
intersectedRefPeakLessColumnsDedupFile="${intersectedRefPeakFileDirectory}[YOUR REFERENCE PEAK FILE, LESS COLUMN, DEDUPLICATED NAME]"  # ex: islet_refFile_IsletMerged_promoterIntersectedRefPeak_withID.deduped.bed

##### Directory for 3.5rd step, label ref loop file with promoters ###########
refLoopLabelledFileDirectory=[DIRECTORY FOR LABELLED REF LOOP FILE] # /folder/folder/folder/
refLoopLabelledFile="${refLoopLabelledFileDirectory}[YOUR LABELLED REFERENCE LOOP FILE NAME]"   # ex: islet_refFile_IsletMerged_loopReferenceFile_withID.promLabelled.bed

##### Directory for 4th step, matching the ids back to the loop files ##############
cell_PromLabelledCiceroFileDirectory=[DIRECTORY FOR LABELLED CICERO FILES] # /folder/folder/folder/
cell_PromLabelledCiceroFilePrefix="${cell_PromLabelledCiceroFileDirectory}[YOUR FILE NAME PREFIX]"  # ex: islet.
cell_PromLabelledCiceroFileSuffix=.cicero_conns_dedup.promLabelled.txt



#### Directory for 5th step, merging labelled cicero files to a single table #########
mergeLabelledFileDirectory=[DIRECTORY FOR MERGED LABELLED CICERO TABLE FILE] # /folder/folder/folder/
mergedLabelledFile="${mergeLabelledFileDirectory}[YOUR FILE NAME]"  # ex: islet.LabelledMergedTable.txt
labelledFileListFile="${cell_PromLabelledCiceroFileDirectory}labelledFileListFile.txt"

chromList=(chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY)

chromList_withoutY=(chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX)


cellTypes=(cellType1 cellType2 cellType3 cellType4 cellType5)  # ex: (pDC B-cell CD4_T-cell CD8_T-cell Megakaryocyte Monocyte NK_cell) THIS HAS TO MATCH THE WAY YOUR INPUT FILES ARE NAMED




# 1. get file list of order fixed input cicero files
echo "1. making file list of input cicero files "
ls ${inputDirectory} > ${inputFileListFile}   # MAKE SURE THAT ONLY YOUR INPUT FILES ARE IN THIS DIRECTORY !!

# 2. merge cicero files, remove coaccess column, dedup
echo "2. making merging cicero files for reference making "
xargs < ${inputFileListFile} cat > ${mergedFileName}
echo "    .... removing coaccess column "
awk '{print $1,$2}' ${mergedFileName} > ${loopOnlyMergedFileName}
echo "    .... de-duplicating "
awk '!seen[$0]++' ${loopOnlyMergedFileName} > ${dedupLoopOnlyMergedFileName}

# 3. make ref file
echo "3. making reference files for ref peak and ref loop with ids "
${pyBin} ${refPyScript} -i ${dedupLoopOnlyMergedFileName}  -p ${samplePrefix} -a ${refLoopFile} -b ${refPeakFile}

# 4. sort ref file
echo "4. sorting ref peak file "
bedtools sort -i ${refPeakFile} > ${sortedRefPeakFile}

# 5. intersect with promoter reference
echo "5. intersecting ref peak file with promoter reference"
bedtools intersect -a ${sortedRefPeakFile} -b ${promReferenceFile} -wa -wb > ${intersectedRefPeakFile}


# 6. remove  prom ref file loci columns from file", dedup
echo "6. removing extra columns that we don't need"
awk '{print $1,$2, $3, $4, $8}' ${intersectedRefPeakFile} > ${intersectedRefPeakLessColumnsFiles}
echo "    .... de-duplicating "
awk '!seen[$0]++' ${intersectedRefPeakLessColumnsFiles} > ${intersectedRefPeakLessColumnsDedupFile}

# 7. label loop reference file
echo "7. labelling loop reference file with promoter"
$pyBin $refloopLabelScript -p $intersectedRefPeakLessColumnsDedupFile -l refLoopFile -o refLoopLabelledFile

# 9. label cicero loop files
echo "7. labelling original cicero loop files"
for cell in  ${cellTypes[@]}; do
echo "    ... for ${cell}"
ciceroFileIn="${inputFilePrefix}${cell}${inputFileSuffix}" # you might have to change this so it loops over input files correctly
ciceroFileOut="${cell_PromLabelledCiceroFilePrefix}${cell}${cell_PromLabelledCiceroFileSuffix}"
$pyBin $ciceroLoopLabelScript -l refLoopLabelledFile -c $ciceroFileIn -o ciceroFileOut
done


# 10. merge everything to a table
echo "10. merging everything to a single table file"
echo "   ... making file list file"
ls ${cell_PromLabelledCiceroFileDirectory} > ${labelledFileListFile}
echo "   .. running merge script"
$pyBin $mergeScript -i $labelledFileListFile -o $mergedLabelledFile -d $cell_PromLabelledCiceroFileDirectory



# 11. split table by cicero pair type

# 12. split those tables by coaccessibility group


echo " Done!!"
exit 0