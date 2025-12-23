#!/usr/bin/env bash

# cellTypes=( acinar activatedStellate alpha_2 beta_2 beta_4 beta_6 ductal    endothelial macrophage quiescientStellate
# acinarREGPOS alpha_1   beta_1  beta_3 beta_5 delta  ductalMUC5B gamma mast tCell )
cellTypes=( beta alpha acinar delta ductal gamma endothelial immune stellate )

RSCRIPT_NAME=/nfs/lab/jnewsome/scripts/cicero/islet_multiome_CiceroScript_2022-04-21.R
UMAPFILE=/nfs/lab/projects/multiomic_islet/finalClusteringBarcodeAnnotation_UMAPTable.txt
DATASETPREFIX=islet_mult
matPrefix=/nfs/lab/projects/multiomic_islet/outputs/multiome/call_peaks/31mergedPeaks_final_majorCTs/
matrSuffix=.lf_mtx.gz
WD=/nfs/lab/jnewsome/multiome/cicero/output_big/
################# b 

# N=4

for cell in ${cellTypes[@]}; do 
# 	((i=i%N)); ((i++==0)) && wait
	(
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "run cicero  $cell  $dt"
        
        
        matrixFile="${matPrefix}${cell}${matrSuffix}"
        # cell <- args[1]
        # prefix1 <- args[2]
        # wd <- args[3]
        # umapFile <- args[4]
        # input_mat <- args[5]


        #                          1         2              3      4             5      
        Rscript ${RSCRIPT_NAME} ${cell} ${DATASETPREFIX} ${WD} ${UMAPFILE} ${matrixFile} 
#     ) &
)
done




echo "ALL DONE !!!!"

exit 0
