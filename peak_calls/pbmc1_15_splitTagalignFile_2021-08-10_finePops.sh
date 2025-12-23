
tagalignInFile=/nfs/lab/jnewsome/pbmc/mergeTagalign/pbmc1_15.MERGED.filt.rmdup.tagAlign


barcodeFilePrefix=/nfs/lab/jnewsome/pbmc/clusterLabelFiles/pbmc1-15.clustering.ClusterLabels.18th_doubletFiltrationIteration.
barcodeFileSuffix=.2021-08-06.txt


tagalignOutFilePrefix=/nfs/lab/jnewsome/pbmc/splitTagalign2021_2/pbmc1-15.
tagalignOutFileSuffix=.filt.rmdup.2021-08-08.tagAlign


cells=(act_cd4_t   adaptive_NK   cDC   _cluster2   _cluster3   _cluster9   _clusters2,3   _clusters2,3,9   cyto_cd8_t   cyto_nk   mem_b   mem_cd8_t   mkc   naive_b   naive_cd4_t   naive_cd8_t   ncMono   pDC   plasma   tReg  )

N=10


for cell in ${cells[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    echo "working on ${cell}"
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    echo "$dt"

    barcodeFile="${barcodeFilePrefix}${cell}${barcodeFileSuffix}"
    outfile="${tagalignOutFilePrefix}${cell}${tagalignOutFileSuffix}"

    echo "grep -F -f ${barcodeFile} ${tagalignInFile} > ${outfile}"

    grep -F -f ${barcodeFile} ${tagalignInFile} > ${outfile}
    echo "done working on ${cell}"
    dt=$(date '+%d/%m/%Y %H:%M:%S');
    ) &

done

echo "Done!!! (all)"


dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "$dt"
exit 0