#!/usr/bin/env python3
import os
import gzip
import sys
import argparse
# 	cluster_tagalign = output_prefix + '.tagalign.gz'
# 	if not os.path.isfile(cluster_tagalign):
# 		with gzip.open(tagalign, 'rt') as f, gzip.open(cluster_tagalign, 'wt') as f_out:
# 			for line in f:
# 				fields = line.rstrip('\n').split('\t')
# 				barcode = fields[3]
# 				if barcode in bcs:
# 					print(line.rstrip('\n'), file=f_out)
                    
    
def fixDirName (outdir1, clustername1):
    if not outdir1.endswith('/'):
        outdir1 = outdir1 + '/'
    barcodedir1 = outdir1 + 'cluster_barcode_files/'
    barcodefilename1 = barcodedir1 + clustername1 + '.barcodes'
    return outdir1, barcodedir1, barcodefilename1



def getBarcodesList (barfilename1):
    bardict = dict()
    barfile = open(barfilename1)
    for line in barfile:
        line = line.strip()
        if len(line) > 0:
            bardict[line] = line
    barfile.close()
    return bardict


def make_tagaligndir (outdir):
    tagdir = outdir + 'cluster_split_tagalign_files/'
    if not os.path.isdir(tagdir):
        os.mkdir(tagdir)
    return (tagdir)


def getOutputName (tagdir, cluster):
    outputname = tagdir + cluster + '.tagalign.gz'
    return outputname
    
    
def split_tagalign_inner_gzipped (barcodesDict1, orig_tagalign_filename, cluster_tagalign_filename):
    split_cluster_tagalign_filename
    with gzip.open(orig_tagalign_filename, 'rt') as f, gzip.open(cluster_tagalign_filename, 'wt') as f_out:
        for line in f:
            fields = line.rstrip('\n').split('\t')
            barcode = fields[3]
            if barcode in barcodesDict1:
                print(line.rstrip('\n'), file=f_out)
                
def split_tagalign_inner_notzipped (barcodesDict1, orig_tagalign_filename, cluster_tagalign_filename):
    f = open(orig_tagalign_filename)
    with gzip.open(cluster_tagalign_filename, 'wt') as f_out:
        for line in f:
            fields = line.rstrip('\n').split('\t')
            barcode = fields[3]
            if barcode in barcodesDict1:
                print(line.rstrip('\n'), file=f_out)
    f.close()
    
    
def split_tagalign_outer (barcodesDictA, cluster_tagalign_filenameA, orig_tagalign_file_nameA):
    
    if orig_tagalign_file_nameA.endswith('.gz'):
        split_tagalign_inner_gzipped (barcodesDictA, orig_tagalign_file_nameA, cluster_tagalign_filenameA)
    else:
        split_tagalign_inner_notzipped (barcodesDictA, orig_tagalign_file_nameA, cluster_tagalign_filenameA)
    
if __name__ == "__main__":
    
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-c','--cluster_name', required=True, type=str, default='stdin', help="cluster column in barcode metadata file")
    parser.add_argument('-o', '--output_dir', required=True, type=str, default='stdin', help="output directory for peak calls")
    parser.add_argument('-t','--tagalign_file', required=True, type=str, default='stdin', help="cluster column in barcode metadata file")
    
    args=parser.parse_args()
    
    args.output_dir, args.barcodedir, args.barcodefilename = fixDirName (args.output_dir, args.cluster_name)
    args.tagalign_dir = make_tagaligndir (args.output_dir)
    args.split_cluster_tagalign_filename = getOutputName (args.tagalign_dir, args.cluster_name)
    barcodesDict = getBarcodesList (args.barcodefilename)
    
    split_tagalign_outer (barcodesDict, args.split_cluster_tagalign_filename, args.tagalign_file)
    
    
    
    
    