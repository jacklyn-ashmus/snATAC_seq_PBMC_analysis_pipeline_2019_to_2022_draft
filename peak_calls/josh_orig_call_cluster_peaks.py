#!/usr/bin/env python3

import os
import sys
import gzip
import subprocess
import numpy as np
import pandas as pd
from multiprocessing import Pool

pre = 'nPOD' 
barcode_cluster = sys.argv[1]
tagalign = sys.argv[2]

clusters = {}
with open(barcode_cluster) as f:
	f.readline()
	for line in f:
		fields = line.rstrip('\n').split('\t')
		barcode, clust = fields[0], fields[4]
		clusters[clust] = clusters.get(clust, []) + [barcode]

def run(c):	
	output_prefix = pre + '.{}'.format(c)
	bcs = clusters[c]
	cluster_tagalign = output_prefix + '.tagalign.gz'
	if not os.path.isfile(cluster_tagalign):
		with gzip.open(tagalign, 'rt') as f, gzip.open(cluster_tagalign, 'wt') as f_out:
			for line in f:
				fields = line.rstrip('\n').split('\t')
				barcode = fields[3]
				if barcode in bcs:
					print(line.rstrip('\n'), file=f_out)
		macs2_cmd = ['macs2', 'callpeak', '-t', cluster_tagalign, '--outdir', os.getcwd(), 
				'-n', output_prefix, '-q', '0.05', '--nomodel', 
				'--keep-dup', 'all', '-g', 'hs', '-B']
		
		subprocess.call(macs2_cmd)
		treat_bdg = output_prefix + '_treat_pileup.bdg'
		subprocess.call(['sort', '-k1,1', '-k2,2n', '-S' ,'8G', treat_bdg, '-o', treat_bdg])
		
		bdg = pd.read_table(treat_bdg, sep='\t', header=None, names=['chr','start','end','value'])
		bdg['norm'] =bdg['value']/(bdg['value'].sum()/1e7)
		bdg['norm'] = np.round(bdg['norm'], 4)
		bdg = bdg.drop('value', axis=1)
		bdg.to_csv(treat_bdg.split('.bdg')[0] + '.norm.bdg', sep='\t', header=False, index=False, float_format='%.4f')

		subprocess.call(['bedGraphToBigWig', treat_bdg.split('.bdg')[0] + '.norm.bdg', '/home/joshchiou/references/hg19.chrom.sizes', output_prefix + '.norm.ATAC.bw'])
		os.remove(output_prefix + '_summits.bed')
		os.remove(output_prefix + '_peaks.xls')
	return

with Pool(processes=len(sorted(set(clusters)))) as pool:
	pool.map(run, sorted(set(clusters)))

#anno_bed = pre + '.clusters.anno.bed'
#merged_bed = pre + '.clusters.merged.bed'
#with open(anno_bed, 'w') as f:
#	for c in sorted(set(clusters)):
#		subprocess.call(['awk', '-v', 'name={}'.format(c), 'BEGIN{{FS=OFS=\"\\t\"}} {{print $1,$2,$3,name}}'], stdout=f)
