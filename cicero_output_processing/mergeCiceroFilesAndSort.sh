#!/usr/bin/env bash
pops=(act_cd4_t  adaptive_NK  b  cd4_AND_cd8_t  cd4_t  cd8_t  cDC  cMono  cyto_cd8_t  cyto_nk  iMono  mem_b  mem_cd8_t  mkc  mono  naive_b  naive_cd4_t  naive_cd8_t  ncMono  nk  pDC  plasma  tReg)
DIR=/nfs/lab/jnewsome/pbmc/split_cicero/fine/




# for cell in ${pops[@]}; do 
# echo "${cell}"
# chrom=1
# chrom1Infile="/nfs/lab/jnewsome/pbmc/split_cicero/fine/${cell}/cicero_conns_raw/pbmc1-15.${cell}.chr1.cicero_conns.txt"
# chrom1Outfile="/nfs/lab/jnewsome/pbmc/split_cicero/fine/${cell}/cicero_conns_raw/pbmc1-15.${cell}.chr1.cicero_conns.fix.txt"
# chrom11File="/nfs/lab/jnewsome/pbmc/split_cicero/fine/${cell}/cicero_conns_raw/pbmc1-15.${cell}.chr11.cicero_conns.txt"
# grep -v chr11_ $chrom1Infile > $chrom1Outfile
# wc -l $chrom1Infile 
# wc -l $chrom1Outfile
# echo "  # of chr11 = "
# grep chr11_ $chrom1Infile | wc -l
# echo "  # of ACTUAL chr11 = "
#  wc -l $chrom11File
# echo ""
# echo ""
# done




# for cell in ${pops[@]}; do 
# echo "${cell}"
# chrom=1
# chrom1Infile="/nfs/lab/jnewsome/pbmc/split_cicero/fine/${cell}/cicero_conns_raw/pbmc1-15.${cell}.chr1.cicero_conns.txt"
# chrom1Outfile="/nfs/lab/jnewsome/pbmc/split_cicero/fine/${cell}/cicero_conns_raw/pbmc1-15.${cell}.chr1.cicero_conns.fix.txt"
# mvChrom1Infile="/nfs/lab/jnewsome/pbmc/split_cicero/fine/${cell}/cicero_conns_raw/pbmc1-15.${cell}.chr1.cicero_conns.oopsHasChrom11.txt"

# mv $chrom1Infile $mvChrom1Infile
# mv $chrom1Outfile $chrom1Infile

# done



for cell in ${pops[@]}; do 
cellDir="${DIR}${cell}/"
outfile="${DIR}${cell}/pbmc1-15.${cell}.cicero_conns_dedup.txt"
outfileSort="${DIR}${cell}/pbmc1-15.${cell}.cicero_conns_dedup.sort.txt"
topFile="${DIR}${cell}/pbmc1-15.${cell}.cicero_conns_dedup.header.txt"
bottomFile="${DIR}${cell}/pbmc1-15.${cell}.cicero_conns_dedup.body.txt"
bottomSortFile="${DIR}${cell}/pbmc1-15.${cell}.cicero_conns_dedup.body.sort.txt"
echo " $cell "
cd ${cellDir}
head -n 1 ${outfile} > ${topFile}
wc -l ${topFile}
tail -n+2 ${outfile} >  ${bottomFile}
wc -l ${bottomFile}
sort -k1,1V -k2,2V ${bottomFile} > ${bottomSortFile}
wc -l ${bottomSortFile}
cat ${topFile} ${bottomSortFile} > ${outfileSort}
wc -l ${outfileSort}
cp ${outfileSort} ..
done



# for cell in ${pops[@]}; do 
# cellDir="${DIR}${cell}/cicero_conns_dedup/"
# outfile="${DIR}${cell}/pbmc1-15.${cell}.cicero_conns_dedup.txt"
# outfileSort="${DIR}${cell}/pbmc1-15.${cell}.cicero_conns_dedup.sort.txt"

# echo " $cell "
# cd ${cellDir}
# # ls * > filelist.txt
# rm filelist.txt
# for i in $(ls | grep ".txt");do cat $i >> ${outfile};done
# # cat filelist.txt | xargs  cat > ${outfile}
# sort -k1,1 -k2,2n ${outfile} > ${outfileSort}

# done

# for cell in ${pops[@]}; do 
# cellDir="${DIR}${cell}/cicero_conns_raw/"
# outfile="${DIR}${cell}/pbmc1-15.${cell}.cicero_conns.txt"
# outfileSort="${DIR}${cell}/pbmc1-15.${cell}.cicero_conns.sort.txt"

# echo " $cell raw"
# cd ${cellDir}
# # ls * > filelist.txt
# rm filelist.txt
# for i in $(ls | grep ".txt");do cat $i >> ${outfile};done
# # cat filelist.txt | xargs  cat > ${outfile}
# sort -k1,1 -k2,2n ${outfile} > ${outfileSort}
# done

exit 0