#!/usr/bin/env bash



cells=(act_cd4_t adaptive_NK b cd4_AND_cd8_t cd4_t cd8_t cDC cMono cyto_cd8_t cyto_nk iMono mem_b mem_cd8_t mkc mono naive_b naive_cd4_t naive_cd8_t ncMono nk pDC plasma tReg )
indir=/nfs/lab/jnewsome/pbmc/split_cicero/fine/
outdir_conns=/nfs/lab/projects/pbmc_snATAC/pipeline/snATAC/cicero/pbmc1_15/conns/
outdir_log=/nfs/lab/projects/pbmc_snATAC/pipeline/snATAC/cicero/pbmc1_15/log/

for cell in ${cells[@]}; do 
        dt=$(date '+%d/%m/%Y %H:%M:%S');
        echo "      fix order $cell   $dt"
        
        #/nfs/lab/jnewsome/pbmc/split_cicero/fine/adaptive_NK
        indirCell="${indir}${cell}/"
        outdir_connsCell="${outdir_conns}${cell}/"
        outdir_logCell="${outdir_log}${cell}/"
        
        inconnsFile="${indir}${cell}/pbmc1-15.${cell}.cicero_conns.txt"
        cd ${indirCell}
        # cp conns
        cp -r cicero_conns_raw ${outdir_connsCell}
        
        # cp log 
        cp -r log ${outdir_logCell}
        
        cp ${inconnsFile} ${outdir_conns}
done
