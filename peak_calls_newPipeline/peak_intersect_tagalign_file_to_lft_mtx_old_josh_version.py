import pandas as pd
import os
import argparse
import subprocess
import gzip




def make_lft_mtx(input_filename, output_prefix):

    lfmatrix_file = '{}.lf_mtx.gz'.format(output_prefix)
    input_file = open(input_filename)
    with gzip.open(lfmatrix_file, 'wt') as lf:
            for line in input_file:
                    fields = line.rstrip().split('\t')
                    print('{}:{}-{}\t{}'.format(fields[0].replace('chr',''), fields[1], fields[2], fields[13]), file=lf)
    lfm = pd.read_table(lfmatrix_file, sep='\t', header=None, names=['peak','cell'])
    lfm = lfm.groupby(lfm.columns.tolist()).size().reset_index().rename(columns={0:'value'})
    lfm.to_csv(lfmatrix_file, sep='\t', index=False, compression='gzip')



def process_args():
        parser = argparse.ArgumentParser(description='make lft matrix file')
        parser.add_argument('-i', '--input_intersect_file', required=True, type=str, help='bedtools intersect result file from interesecting peak file and cluster tagalign file')
        parser.add_argument('-o', '--output_prefix', required=True, type=str, help='Output prefix to prepend')
        return parser.parse_args()

if __name__ == '__main__':
#         logging.basicConfig(format='[%(filename)s] %(asctime)s %(levelname)s: %(message)s', datefmt='%I:%M:%S', level=logging.DEBUG)
        args = process_args()
        print(args)
        print('\n\n')
        
        make_lft_mtx(args.input_intersect_file, args.output_prefix)
        
        
        print('done!')
        
        
        
        