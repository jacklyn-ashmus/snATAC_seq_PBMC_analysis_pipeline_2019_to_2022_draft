#!/usr/bin/env python3

import os
import gzip
import argparse
import subprocess
import logging
import numpy as np
import pandas as pd


def readNamesFromFile (filename):
    infile1 = open(filename)
    dict1 = {}
    list1 = list()
    for line in infile1:
        line = line.strip()
        if len(line) > 0 and not line.startswith('#'):
            list1.append(line)
            dict1[line] = line
    infile1.close()

    return dict1, list1


def create_peak_matrix(outputPrefix, barcodesList, mergedPeakFileName, tagalignFileName):
	lfmatrix_file = '{}.lf_mtx.gz'.format(outputPrefix)
	print('create_peak_matrix:  intersecting merged peak and tagalign for: ', outputPrefix)
	intersect = subprocess.Popen(['bedtools', 'intersect', '-a', mergedPeakFileName, '-b', tagalignFileName, '-wa', '-wb', '-sorted'], stdout=subprocess.PIPE)
	print('create_peak_matrix:  writing long format matrix for : ', outputPrefix)
	with gzip.open(lfmatrix_file, 'wt') as lf:
		for line in intersect.stdout:
			fields = line.decode().rstrip().split('\t')
			print('{}:{}-{}\t{}'.format(fields[0].replace('chr',''), fields[1], fields[2], fields[7]), file=lf)
	print('create_peak_matrix:  processing long format matrix file for : ', outputPrefix)
	lfm = pd.read_table(lfmatrix_file, sep='\t', header=None, names=['peak','cell'])
	lfm = lfm.loc[lfm['cell'].isin(barcodesList)]
	lfm = lfm.groupby(lfm.columns.tolist()).size().reset_index().rename(columns={0:'value'})
	lfm.to_csv(lfmatrix_file, sep='\t', index=False, compression='gzip')
	
	mtx_file = '{}.mtx'.format(outputPrefix)
	barcodes_file = '{}.barcodes'.format(outputPrefix)
	peaks_file = '{}.peaks'.format(outputPrefix)
	print('create_peak_matrix:  writing tmp R script file for : ', outputPrefix)
	tmp_R = '{}.tmp.R'.format(outputPrefix)
	with open(tmp_R, 'w') as tR:
		print('''library(Matrix)''', file=tR)
		print('''library(methods)''', file=tR)
		print('''data <- read.table('{}', sep='\\t', header=TRUE)'''.format(lfmatrix_file), file=tR)
		print('''sparse.data <- with(data, sparseMatrix(i=as.numeric(peak), j=as.numeric(cell), x=value, dimnames=list(levels(peak), levels(cell))))''', file=tR)
		print('''t <- writeMM(sparse.data, '{}')'''.format(mtx_file), file=tR)
		print('''write.table(data.frame(colnames(sparse.data)), file='{}', col.names=FALSE, row.names=FALSE, quote=FALSE)'''.format(barcodes_file), file=tR)
		print('''write.table(data.frame(rownames(sparse.data)), file='{}', col.names=FALSE, row.names=FALSE, quote=FALSE)'''.format(peaks_file), file=tR)
	print('create_peak_matrix:  writing mm file for : ', outputPrefix)
	subprocess.call(['Rscript', tmp_R])
	print('create_peak_matrix:  gzipping : ', outputPrefix)
	subprocess.call(['gzip', mtx_file])
	os.remove(tmp_R)
	print('create_peak_matrix: done! for: ', outputPrefix)
	return


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-o', '--outputPrefix', required=True, type=str, default='stdin', help="prefix to output files with")
    parser.add_argument('-m', '--mergedPeakFile', required=True, type=str, default='stdin', help="SORTED merged peak file")
    parser.add_argument('-t', '--tagalignFile', required=True, type=str, default='stdin', help="SORTED and split tagalign file")
    parser.add_argument('-b', '--barcodeFile', required=True, type=str, default='stdin', help="file with list of barcodes in cluster")
    args = parser.parse_args()

    barcodeListDict, barcodeList = readNamesFromFile (args.barcodeFile)
    
    create_peak_matrix(args.outputPrefix, barcodeList, args.mergedPeakFile, args.tagalignFile)
    
    
    
    
    