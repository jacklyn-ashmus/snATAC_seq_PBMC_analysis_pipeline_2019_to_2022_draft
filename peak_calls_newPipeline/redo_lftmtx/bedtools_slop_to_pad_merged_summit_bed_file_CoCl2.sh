#!/usr/bin/env bash

SUMMITFILE=$1
FIXED_PEAK_FILE=$2
PAD_SIZE=$3
# PAD_SIZE=100
PAD_SIZE_2=$(( 2*PAD_SIZE ))
PAD_SIZE_R=$(( PAD_SIZE-1 ))
GENOME_SIZE=/nfs/lab/ref/hg38.chrom.sizes


echo "SUMMITFILE = ${SUMMITFILE}"
echo "FIXED_PEAK_FILE = ${FIXED_PEAK_FILE}"
echo "PAD_SIZE = ${PAD_SIZE}"

# bedtools slop -i ${infile} -g ${GENOME_SIZE} -b ${PAD_SIZE} > ${outfile}   # <- gives 201bp peaks
bedtools slop -i ${SUMMITFILE} -g ${GENOME_SIZE} -l ${PAD_SIZE} -r ${PAD_SIZE_R} > ${FIXED_PEAK_FILE} 

    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "done with   merged summit -> fixed peaks    $dt"
exit 0