
tagalignInFile=/nfs/lab/jnewsome/pbmc/mergeTagalign/pbmc1_15.MERGED.filt.rmdup.tagAlign


barcodeFilePrefix=/nfs/lab/jnewsome/pbmc/clusterLabelFiles_broad/pbmc1-15.clustering.ClusterLabels.18th_doubletFiltrationIteration.broad.
barcodeFileSuffix=.2021-08-06.txt


tagalignOutFilePrefix=/nfs/lab/jnewsome/pbmc/splitTagalign_broad/pbmc1-15.
tagalignOutFileSuffix=.filt.rmdup.2021-08-08.broad.tagAlign


cells=(b cd4_t cd8_t mkc mono nk pDC plasma  )

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
echo "$dt"(base)