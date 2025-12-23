#!/usr/bin/env bash

OUTPUT_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/union_peaks_from_emily_v2_2024_06/output_matrix/
PEAK_BED_INPUT_FILE=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/peak_calls/union_peaks_from_emily_v2_2024_06/output/Jackie_UnionPeaks.bed
MERGED_TAGALIGN=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/MERGED.filt.soft.TAGALIGN


LFT_2_MM_SCRIPT=/nfs/lab/jnewsome/scripts/peak_calls/newPipeline/lft_mtx_2_sparseMatrix.R


peak_bed_file_noHeader="${OUTPUT_DIR}union_peaks.noheader.bed"

# awk 'NR > 1' ${PEAK_BED_INPUT_FILE} > ${peak_bed_file_noHeader}

peak_bed_file_noHeader_sort="${OUTPUT_DIR}union_peaks.noheader.sort.bed"
# sort -k1,1 -k2,2n  ${peak_bed_file_noHeader} > ${peak_bed_file_noHeader_sort}


intersect_file="${OUTPUT_DIR}union_peaks.intersect.tagalign.bed"

# bedtools intersect -a ${peak_bed_file_noHeader_sort} -b ${MERGED_TAGALIGN} -wa -wb -sorted > ${intersect_file}


intermed_intersect_less_col_file="${OUTPUT_DIR}union_peaks.intersect.tagalign.lessCol.bed"


# chr1    9956    10256   alpha_peak_1    387.000000      chr1    9906    10106   Single1_CoCl2_MM779_MM765_AACCCGCAGGGACGCA-1    31      +
#  1       2         3      4               5              6       7        8          9                                          10      11
awk '{print $1 ":" $2 "-" $3 "\t" $9 }' "${intersect_file}" > "${intermed_intersect_less_col_file}"


lft_mtx_unsort_file="${OUTPUT_DIR}union_peaks.intersect.merged_tagalign.lftmtx.unsort.txt"

    awk '{
    combination = $1 "\t" $2
    count[combination]++
    }
    END {
        for (comb in count) {
            print comb, count[comb]
        }
    }' "${intermed_intersect_less_col_file}" > "${lft_mtx_unsort_file}"


lft_mtx_sort_file="${OUTPUT_DIR}union_peaks.intersect.merged_tagalign.lftmtx.sort.txt"

sort -k1,1 -k2,2n  "${lft_mtx_unsort_file}" > "${lft_mtx_sort_file}"


mm_file="${OUTPUT_DIR}union_peaks.intersect.merged_tagalign.mm.mtx"

Rscript ${LFT_2_MM_SCRIPT} ${lft_mtx_sort_file} ${mm_file} all



echo "Done!!!"

exit 0