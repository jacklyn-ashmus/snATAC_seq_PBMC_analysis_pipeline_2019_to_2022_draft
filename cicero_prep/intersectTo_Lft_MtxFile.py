import os
import sys
import gzip
import argparse
import subprocess
from multiprocessing import Pool








def fixFile (infileName, outfileName):
    
    infile = open(infileName)
    outfile = open(outfileName, 'w')
    
    for line in infile:
        line = line.strip()
        if len(line) > 0:
            s = line.split()
            # chr1    9903    10103    chr1    9903    10103    pbmc14_GCGCCAAAGTCGATAA    40    +
            #   0     1        2       3         4        5               6                7     8
            chrom =s[0].replace('chr', '')
            start = s[1]
            end = s[2]
            bar = s[6]
            val = s[7]
            
            outline = chrom + ':' + start + '-' + end + '\t' + bar +  '\t' + val + '\n'
            outfile.write(outline)
    infile.close()
    outfile.close()
    print('Done')
    
            
            



if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-i', '--inputFile', required=True, type=str, default='stdin', help="input intersected tagaligm file")
    parser.add_argument('-o', '--outputFile', required=True, type=str, help="output bed name")
    args = parser.parse_args()
    print('       fixing file columns')
    
#     print('\t\t\t\tinfile = ', args.inputFile)
#     print('\t\t\t\toutfile = ', args.outputFile)
    
    
    fixFile (args.inputFile, args.outputFile)
    print("         Done!!")
    


