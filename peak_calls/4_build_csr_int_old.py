#!/usr/bin/env python3

import os
import sys
import gzip
import subprocess
import pandas as pd
import scipy.sparse
import scipy.io

def intersect_helper(tagalign, regions):
	awk_cmd = ['awk', '''BEGIN{{FS=OFS="\\t"}} {{peakid=$1":"$2"-"$3; gsub("chr","",peakid); print $1, $2, $3, peakid}}''', regions]
	intersect_cmd = ['bedtools', 'intersect', '-a', tagalign, '-b', '-', '-wa', '-wb']
	awk = subprocess.Popen(awk_cmd, stdout=subprocess.PIPE)
	intersect = subprocess.Popen(intersect_cmd, stdin=awk.stdout, stdout=subprocess.PIPE)
	return intersect

def main():
	output_prefix = 'Islet_123.peaks'
	peaks_file = 'Islet_123.combined.merged.bed'
	tagalign_file = 'Islet_1234.fresh.tagAlign.gz'
	barcodes_file = 'Islet_123.MNN_corrected.cluster_labels.txt' 
	pass_barcodes = []
	with open(barcodes_file) as f:
		f.readline()
		for line in f:
			fields = line.rstrip('\n').split('\t')
			barcode = fields[0]
			pass_barcodes.append(barcode)

	barcodes_file = output_prefix + '.barcodes'
	regions_file = output_prefix + '.peaks'

	matrix = {}
	peak_intersect = intersect_helper(tagalign_file, peaks_file)
	for line in peak_intersect.stdout:
		line = line.decode().rstrip('\n')
		fields = line.split('\t')
		barcode = fields[3]
		peak = fields[9]
		if barcode not in pass_barcodes:
			continue
		if peak not in matrix:
			matrix[peak] = {}
		matrix[peak][barcode] = matrix[peak].get(barcode, 0) + 1	
	
	peaks = list(matrix)
	barcodes = pass_barcodes
	mtx = scipy.sparse.dok_matrix((len(barcodes), len(peaks)), dtype=int)

	for b in range(len(barcodes)):
		for p in range(len(peaks)):
			if barcodes[b] in matrix[peaks[p]]:
				mtx[b,p] = matrix[peaks[p]][barcodes[b]]
	mtx = mtx.tocsr()
	scipy.sparse.save_npz(output_prefix + '.csr.npz', mtx)
	scipy.io.mmwrite(output_prefix + '.mtx', mtx)

	with open(barcodes_file, 'w') as f:
		print('\n'.join(barcodes), file=f)
	with open(regions_file, 'w') as f:
		print('\n'.join(peaks), file=f)
	return

main()
