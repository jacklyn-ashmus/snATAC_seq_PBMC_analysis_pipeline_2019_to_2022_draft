#!/bin/bash

ALL_CELLTYPES=(acinar activated_stellate alpha alpha_1 alpha_2 alpha_3 alpha_4 beta beta_1 beta_2 delta ductal endothelial gamma immune mast monocyte quiescent_stellate unk_stellate schwann stellate )

CELL_SUBTYPES=(acinar activated_stellate alpha_1 alpha_2 alpha_3 alpha_4 beta_1 beta_2 delta ductal endothelial gamma mast monocyte quiescent_stellate schwann unk_stellate)

CELLTYPES=(acinar alpha beta delta ductal endothelial gamma immune schwann stellate)


IN_CELLTYPE_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/Treatment__celltype/
IN_CELL_SUBTYPE_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/Treatment__cell_subtype/

OUT_CELLTYPE_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/cell_subtype/
OUT_CELL_SUBTYPE_DIR=/nfs/lab/projects/islet_multiomics_stress_CoCl2/pipeline/split_tagalign_finalCelltypes/celltype/

N=6

for cell in ${CELLTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
       
       unt_file="${IN_CELLTYPE_DIR}Unt__${cell}.tagalign"
       cocl2_file="${IN_CELLTYPE_DIR}CoCl2__${cell}.tagalign"
       cat_file="${OUT_CELLTYPE_DIR}${cell}.cat.tagalign"
       sort_file="${OUT_CELLTYPE_DIR}${cell}.tagalign"

        echo "merge celltype ${cell}"
       cat ${cocl2_file} ${unt_file} > ${cat_file}
       echo "sort celltype ${cell}"
       sort -k1,1 -k2,2n  "${cat_file}" > "${sort_file}"
    ) &

done

for cell in ${CELL_SUBTYPES[@]}; do 
	((i=i%N)); ((i++==0)) && wait
    (
       unt_file="${IN_CELL_SUBTYPE_DIR}Unt__${cell}.tagalign"
       cocl2_file="${IN_CELL_SUBTYPE_DIR}CoCl2__${cell}.tagalign"
       cat_file="${OUT_CELL_SUBTYPE_DIR}${cell}.cat.tagalign"
       sort_file="${OUT_CELL_SUBTYPE_DIR}${cell}.tagalign"

        echo "merge subtype ${cell}"
       cat ${cocl2_file} ${unt_file} > ${cat_file}
       echo "sort subtype ${cell}"
       sort -k1,1 -k2,2n  "${cat_file}" > "${sort_file}"
    ) &

done

echo "DONE!!!!"
exit 0