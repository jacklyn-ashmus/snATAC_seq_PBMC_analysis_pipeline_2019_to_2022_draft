#!/usr/bin/env bash

cells=(Acinar Alpha Beta Delta  Ductal  Endothelial Gamma Immune ImmuneMast Polyhormonal Stellate )
DIR=/nfs/lab/jnewsome/CoCl2_Islet_Multiome/peak_calls/
narrowpeakSuffix=_peaks.narrowPeak
bdgFileSuffix=.scale_1e6.bdg
bdgSortedFileSuffix=.scale_1e6.sorted.bdg
bwFileSuffix=.scale_1e6.bw
fileSizeFileSuffix=.size.txt
tagalignfilesuffix=.tagalign
tagalignfilesortedsuffix=.sorted.tagalign
GSIZE_FILE=/nfs/lab/ref/hg38.chrom.sizes
merged_bed_file=/nfs/lab/jnewsome/CoCl2_Islet_Multiome/peak_calls/merged_peaks.anno.bed
dt=$(date '+%d/%m/%Y %H:%M:%S');


# 'bedtools', 'intersect', '-a', mergedPeakFileName, '-b', tagalignFileName, '-wa', '-wb', '-sorted'], stdout=subprocess.PIPE)



N=4

for cell in ${cells[@]}; do 
	((i=i%N)); ((i++==0)) && wait

	(
    echo "$cell"
    tagalignFile="${DIR}${cell}.tagalign"
    fileSizeFile="${DIR}${cell}${fileSizeFileSuffix}"
    sortedTagalignFile="${DIR}${cell}.sorted.tagalign"
    bdgFile="${DIR}${cell}${bdgFileSuffix}"
    bdgSortedFile="${DIR}${cell}${bdgSortedFileSuffix}"
    bwFile="${DIR}${cell}${bwFileSuffix}"
    outmatrixFile="${DIR}${cell}.merged_peaks.long_fmt.mtx.gz"

     
    awk 'BEGIN{FS=OFS="\t"} {gsub("chr","",$1); print "chr"$1,$2,$3,$1":"$2"-"$3}' ${merged_bed_file} \
	| bedtools intersect -a - -b ${sortedTagalignFile} -wa -wb -sorted \
	| cut -f 4,8 | sort -S 96G -T `pwd` \
	| uniq -c \
	| awk 'BEGIN{OFS="\t"; print "peak","barcode","value"} {print $2,$3,$1}' \
	| gzip -c \
	> ${outmatrixFile}


  
    
    ) &

done



