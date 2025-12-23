#!/usr/bin/env bash




CELL_TYPE_LIST_FILE=/nfs/lab/jnewsome/pbmc/cicero_processed_pbmc1_15/pbmc_cellTypeList.txt
IFS=$'\n' read -d '' -r -a cells < ${CELL_TYPE_LIST_FILE}


echo "fix record order" 
for cell in ${cells[@]}; do 
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "      fix order $cell   $dt"
        
        listName="/nfs/lab/jnewsome/pbmc/split_cicero/fine/${cell}/rawlist.txt"
        infilename="/nfs/lab/jnewsome/pbmc/split_cicero/fine/${cell}/cicero_conns_raw/*"
        outfilename1="/nfs/lab/jnewsome/pbmc/split_cicero/fine/MERGE_RAW/pbmc1-15.${cell}.concat.cicero_conns.txt"
        outfilename2="/nfs/lab/jnewsome/pbmc/split_cicero/fine/DEDUPE_RAW/pbmc1-15.${cell}.concat.dedupe.cicero_conns.txt"
        outfilename3="/nfs/lab/jnewsome/pbmc/split_cicero/fine/DEDUPE_RAW_SORT/pbmc1-15.${cell}.concat.dedupe.sort.cicero_conns.txt"
        ls -d -I   ${infilename} > ${listName}
        echo "      cat"
        xargs < ${listName} cat > ${outfilename1}
        echo "      dedupe"
        awk '!seen[$0]++' ${outfilename1} > ${outfilename2}
        echo "      sort"
        sort -k1,1 -k2,2n ${outfilename2} > ${outfilename3}
done

echo "done!"








exit 0