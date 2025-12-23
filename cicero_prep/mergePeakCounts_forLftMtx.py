from natsort import humansorted
from natsort import natsorted
import argparse




def readMergedPeakIntersectLessColFileToDict (infilename):
    dict1 = {}
    intersectDict = dict()
    infile = open(infilename)
    count = 1
    for line in infile:
        line = line.strip()
        if len(line) > 0 and not line.startswith('Peak'):
            
            
                # 1:9912-10684	pbmc13_GCTCGAGCAGGTTATC	30
            
                s = line.split()
                
                peak = s[0]
                bar = s[1]
                count = int(s[2])
                
                key1 = peak + '__' + bar
                
                if not key1 in dict1:
                    dict1[key1] = {}
                    dict1[key1]['peak'] = peak
                    dict1[key1]['bar'] = bar
                    dict1[key1]['countList'] = list()
                    dict1[key1]['countList'].append(count)
                    dict1[key1]['intersectCount'] = 1
                else:
                    dict1[key1]['countList'].append(count)
                    dict1[key1]['intersectCount'] = dict1[key1]['intersectCount'] + 1
    infile.close()
    return dict1


def getFinalCounts (peakDict):
    for key1 in peakDict:
        peakDict[key1]['finalCount'] = sum(peakDict[key1]['countList'])
        peakDict[key1]['finalCountStr'] = str(peakDict[key1]['finalCount'])
    return peakDict


def sortKeys (peakDict):
    keylist = list(peakDict.keys())
    natlist = natsorted(keylist)
    return natlist

def outputToFile (peakDict, natlist, outfilename):
    
    
    outfile = open(outfilename, 'w')

    for key1 in natlist:

        outline = peakDict[key1]['peak'] + '\t' + peakDict[key1]['bar'] + '\t' + peakDict[key1]['finalCountStr'] + '\n'
        outfile.write(outline)
    outfile.close()


if __name__ == "__main__":


    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-i', '--inputFile', required=True, type=str, default='stdin', help="input peak / barcode / count file")
    parser.add_argument('-o', '--outputfile', required=True, type=str, help="output file")
    args = parser.parse_args()
    
    print('         reading input file')
    peakDict1 = readMergedPeakIntersectLessColFileToDict (args.inputFile)
    print('         getting final counts')
    peakDict1 = getFinalCounts (peakDict1)
    
    print('         sorting peaks and barcodes')
    sortKeys1 = sortKeys (peakDict1)
    print('         writing peaks x barcodes to file')
    outputToFile (peakDict1, sortKeys1, args.outputfile)
    print('         Done!')
    
