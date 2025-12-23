#!/usr/bin/env bash



script=/nfs/lab/projects/pbmc_snATAC/scripts/snATAC_pipeline_10X.py
outputFolder=/nfs/lab/jnewsome/comparePeaks/tagalign/
pyBin=/home/jnewsome/anaconda3/envs/py37_2/bin/python
blackListFile=/nfs/lab/jnewsome/references/ENCODE.hg19.blacklist.bed
promoterFile=/nfs/lab/jnewsome/references/gencode.v19.2kb_autosomal_prom_uniq.bed

for filename in /home/jnewsome/compare_to_sorted_softlinks/bams/*; do
base=`basename ${filename} .bam`
echo ""
echo ""
echo " ${filename}     ${base}"

$pyBin $script -b $filename -o $outputFolder -n $base -t 24 -m 2 --blacklist-file $blackListFile --promoter-file $promoterFile

done

echo " DONE!!"
