#!/usr/bin/env bash

cells=(CoCl2__acinar CoCl2__activated_stellate CoCl2__alpha CoCl2__alpha_1 CoCl2__alpha_2 CoCl2__alpha_3 CoCl2__alpha_4 CoCl2__beta CoCl2__beta_1 CoCl2__beta_2 CoCl2__delta CoCl2__ductal CoCl2__endothelial CoCl2__gamma CoCl2__immune CoCl2__mast CoCl2__monocyte CoCl2__quiescent_stellate_1 CoCl2__schwann CoCl2__stellate CoCl2__unk_stellate_2 Unt__acinar Unt__activated_stellate Unt__alpha Unt__alpha_1 Unt__alpha_2 Unt__alpha_3 Unt__alpha_4 Unt__beta Unt__beta_1 Unt__beta_2 Unt__delta Unt__ductal Unt__endothelial Unt__gamma Unt__immune Unt__mast Unt__monocyte Unt__quiescent_stellate_1 Unt__schwann Unt__stellate Unt__unk_stellate_2  )


MTX_SCRIPT=/nfs/lab/jnewsome/scripts/multiome_CoCl2/peakCalls/lft_mtx_2_sparseMatrix.R


TAGALIGN_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/from_peaks_to_mm_mtx/tagalign_softlinks/

NARROWPEAK_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/from_peaks_to_mm_mtx/celltype_specific_peaks/narrowpeak_softlinks/

CELL_SPEC_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/from_peaks_to_mm_mtx/celltype_specific_peaks/
MERGED_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/from_peaks_to_mm_mtx/merged_peaks/


cellspec_intersect_dir=
merged_intersect_dir=

intersect_lesscol_dir=
merged_intersect_lesscol_dir=




# N=6

# for cell in ${cells[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait
#     (
#     tagalignFile="${tagalignFilePrefix}${cell}${tagalignFileSuffix}"
#     fileSizeFile="${fileSizeFilePrefix}${cell}${fileSizeFileSuffix}"
#     sortedTagalignFile="${tagalignFilePrefix}${cell}${tagalignSortedFileSuffix}"
#     bdgFile="${bdgFilePrefix}${cell}${bdgFileSuffix}"
#     bdgSortedFile="${bdgFilePrefix}${cell}${bdgSortedFileSuffix}"
#     bwFile="${bwFilePrefix}${cell}${bwFileSuffix}"
    
    
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "working on    ${cell}       $dt"

#     # 2 . count reads
#     dt=$(date '+%d/%m/%Y %H:%M:%S');
#     echo "${cell} wc -l       $dt"
#     sizeA=$(wc -l ${tagalignFile})
#     sizearray=($sizeA)
#     size=${sizearray[0]}
    

#     echo ${size} > ${fileSizeFile}
    
#     ) &

# done




# celltype specific 
#1. bedtools intersect
#2. less col
#3. lft mtx 
#4. sort lft mtx
#5. mm 

# celltype specific 
#1. bedtools intersect
#2. less col
#3. lft mtx 
#4. sort lft mtx
#5. mm 







awk '{print $1 ":" $2 "-" $3 "\t" $14 }' "$INFILE" > "$INFILE_INTERMED"



# 1         2       3          4                   5      6           7     8       9      10       11     12      13        14                                 
# chr1    9949    10487   CoCl2__acinar_peak_1    122     .       9.43606 15.4437 12.2724 165     chr1    9919    10119   Pool2_CoCl2_PM005_PM008_CCGCACACAAATACCT-1      30      +
    
    awk '{
        combination = $1 "\t" $2
        count[combination]++
    }
    END {
        for (comb in count) {
            print comb, count[comb]
        }
    }' "$INFILE_INTERMED" > "$INFILE_INTERMED2"
    
    
    
sort -k1,1 -k2,2n  "$INFILE_INTERMED2" > "$OUTFILE"










exit 0