#!/usr/bin/env bash

IN_DIR=$1  # MAKE SURE THAT ONLY (AND ALL ) OF YOUR INPUT FILES ARE IN THIS DIRECTORY !!
OUT_DIR=$2
CELL_TYPE_LIST_FILE=$3 # Text file with list of cell types
INFILE_PREFIX=$4
INFILE_SUFFIX=$5
SAMPLE_NAME=$6
COA_CUTOFF=$7
MIN_PEAK_DIST=$8
MAX_PEAK_LENGTH=$9

PROM_REF_FILE=/nfs/lab/jnewsome/references/gencode.v19.1kb_all_possible_transcripts.bed

orderFixPyScript=/nfs/lab/jnewsome/scripts/cicero_output_processing/cicero_output_fix_record_order.py
refPyScript=/nfs/lab/jnewsome/scripts/cicero_output_processing/makePeakReferenceFile_v2021-10-26.py
refloopLabelScript=/nfs/lab/jnewsome/scripts/cicero_output_processing/labelLoopRefFileWithPromoters_2020-03-26.py
ciceroLoopAnnotationScript=/nfs/lab/jnewsome/scripts/cicero_output_processing/cicero_output_process_runPerCellType_filtersAndAnno.py



fixOrderDir="${OUT_DIR}fixRecordOrder/"
refDir="${OUT_DIR}refs/"
annoDir="${OUT_DIR}cicero_annotated/"




fixRecordOrderSuffix=.cicero_conns_dedup.recordFix.txt
fixRecordOrderSortSuffix=.cicero_conns_dedup.recordFix.sort.txt

inputFileListFile="${refDir}inputFileList.txt"
mergedLoopFileName="${refDir}merged_loop_file.txt"
loopOnlyMergedFileName="${refDir}merged_loop_file.onlyLoops.txt"
dedupLoopOnlyMergedFileName="${refDir}merged_loop_file.onlyLoops.dedupe.txt"
peakIdRefFile="${refDir}peakIDRefFile.bed"
loopIdRefFile="${refDir}loopIDRefFile.bed"
peakIdRefFileSort="${refDir}peakIDRefFile.sort.bed"
intersectedRefPeakFile="${refDir}peakIDRefFile.INTERSECTED_w_gencode1kb.bed"
intersectedRefPeakLessColumnsFiles="${refDir}peakIDRefFile.INTERSECTED_w_gencode1kb.lessCol.bed"
intersectedRefPeakLessColumnsDedupFile="${refDir}peakIDRefFile.PROMOTER_LABELLED.bed"
loopID_ref_promLabelled_File="${refDir}loopIDRefFile.PROMOTER_LABELLED.bed"
loopID_ref_promLabelled_File_dedup="${refDir}loopIDRefFile.PROMOTER_LABELLED.dedupe.bed"


outLoopFileNamePrefix="${annoDir}${SAMPLE_NAME}."
outLoopFileNameSuffix=.cicero_conns_dedup.Annotated.txt




mkdir ${fixOrderDir}
mkdir ${annoDir}

mkdir ${refDir}


# 0. read cell types from file
N=1
echo "read cell types from file" 

IFS=$'\n' read -d '' -r -a cells < ${CELL_TYPE_LIST_FILE}

# 0. fix record order
echo "fix record order" 
for cell in ${cells[@]}; do 
	((i=i%N)); ((i++==0)) && wait
	(   
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "      fix order $cell   $dt"
        
        infilename="${IN_DIR}${INFILE_PREFIX}${cell}${INFILE_SUFFIX}"
        outfilename="${fixOrderDir}${SAMPLE_NAME}.${cell}${fixRecordOrderSuffix}"
        outfilesortname="${fixOrderDir}${SAMPLE_NAME}.${cell}${fixRecordOrderSortSuffix}"
        
        python ${orderFixPyScript} -i ${infilename} -o ${outfilename}
        echo "      sort $cell   $dt"
        sort -k1,1 -k2,2n ${outfilename} > ${outfilesortname}

        echo ""
        echo ""
    ) &

done




#1. get file list of order fixed input cicero files
echo "1. making file list of input cicero files "
ls -d ${fixOrderDir}/* > ${inputFileListFile} 
# 2. merge cicero files, remove coaccess column, dedup
echo "2. making merging cicero files for reference making "
xargs < ${inputFileListFile} cat > ${mergedLoopFileName}

echo "    .... removing coaccess column "
awk '{print $1,$2}' ${mergedLoopFileName} > ${loopOnlyMergedFileName}
echo "    .... de-duplicating "
awk '!seen[$0]++' ${loopOnlyMergedFileName} > ${dedupLoopOnlyMergedFileName}

# 3. make ref file
echo "3. making reference files for ref peak and ref loop with ids "
python ${refPyScript} -i ${dedupLoopOnlyMergedFileName}  -p ${peakIdRefFile} -l ${loopIdRefFile}

# 4. sort ref file
echo "4. sorting ref peak file "
bedtools sort -i ${peakIdRefFile} > ${peakIdRefFileSort}

# 5. intersect with promoter reference
echo "5. intersecting ref peak file with promoter reference"
bedtools intersect -a ${peakIdRefFileSort} -b ${PROM_REF_FILE} -wa -wb > ${intersectedRefPeakFile}


# 6. remove  prom ref file loci columns from file", dedup
echo "6. removing extra columns that we don't need"
# chr1	9912	756012	CicPair_005270293_a	chr1	68591	69591	OR4F5
#  1     2       3          4                5      6         7       8
awk '{print $1,$2, $3, $4, $8}' ${intersectedRefPeakFile} > ${intersectedRefPeakLessColumnsFiles}
echo "    .... de-duplicating "
# chr1 9912 756012 CicPair_005270293_a OR4F5
#  1     2   3       4                   5
awk '!seen[$0]++' ${intersectedRefPeakLessColumnsFiles} > ${intersectedRefPeakLessColumnsDedupFile}

# 7. label loop reference file
echo "7. labelling loop reference file with promoter"
python $refloopLabelScript -p $intersectedRefPeakLessColumnsDedupFile -l ${loopIdRefFile} -o ${loopID_ref_promLabelled_File}

echo "7.5. deduplicating loop reference file"
awk '!seen[$0]++' ${loopID_ref_promLabelled_File} > ${loopID_ref_promLabelled_File_dedup}


echo "__ Done with whole dataset level processes"


#8 read celltypes from list file

for cell in ${cells[@]}; do 
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "      fix order $cell   $dt"
        
        infilename="${fixOrderDir}${SAMPLE_NAME}.${cell}${fixRecordOrderSortSuffix}"
        outfilename="${outLoopFileNamePrefix}${cell}${outLoopFileNameSuffix}"
        
        python ${ciceroLoopAnnotationScript} -l ${loopID_ref_promLabelled_File_dedup} -c ${infilename} -o ${outfilename} -s ${COA_CUTOFF} -d ${MIN_PEAK_DIST} -p ${MAX_PEAK_LENGTH} -e ${cell}


done

echo "__ Done with annotating all cell type files!!"

exit 0
