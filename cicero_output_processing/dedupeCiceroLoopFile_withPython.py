import argparse

def readFile (infilename):
    inDict = {}
    
    infile = open(infilename)
    
    for line in infile:
        line = line.strip()
        if len(line) > 0:
            if not line.startswith('Peak'):
                s = line.split()

                peak1 = s[0]
                peak2 = s[1]
                coa = s[2]

                key = peak1 + '__' + peak2
                keyBackward = peak2 + '__' + peak1
                if not key in inDict and not keyBackward in inDict:
                    inDict[key] = {}
                    list1 = list()
                    coaList1 = list()
                    list1.append(line)
                    inDict[key]['list'] = list1
                    inDict[key]['line'] = line
                    coaList1.append(coa)
                    inDict[key]['coaList'] = coaList1
                elif keyBackward in inDict:
                    list1 = inDict[keyBackward]['list']
                    coaList1 = inDict[keyBackward]['coaList']
                    list1.append(line)
                    coaList1.append(coa)
                    inDict[keyBackward]['list'] = list1
                    inDict[keyBackward]['coaList'] = coaList1
                elif key in inDict:
                    list1 = inDict[key]['list']
                    coaList1 = inDict[key]['coaList']
                    list1.append(line)
                    coaList1.append(coa)
                    inDict[key]['list'] = list1
                    inDict[key]['coaList'] = coaList1
                
    infile.close()
    return inDict


def debugFile (inDict):
    count = 0
    for key in inDict.keys():
        
#         if len(inDict[key]['list']) > 1:
#             mismatch = False
#             for coa1 in inDict[key]['coaList']:
#                 for coa2 in inDict[key]['coaList']:
#                     if not coa1 == coa2:
#                         mismatch = True
#             if mismatch:
#                 print(key)
#                 print('\t', len(inDict[key]['list']))
#                 print('\tcoa list =     ', inDict[key]['coaList'])
#                 print('\tline list =     ', inDict[key]['list'])
        if len(inDict[key]['list']) > 2:
            count = count + 1
    return count

def writeOutput (inDict, outputfilename):
    
    outfile = open(outputfilename, 'w')
    outfile.write('Peak1\tPeak2\tcoaccess\n')
    for key in inDict.keys():
        outfile.write(inDict[key]['line'] + '\n')
    outfile.close()

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-i', '--inputFile', required=True, type=str, default='stdin', help="input file")
    parser.add_argument('-o', '--outputfile', required=True, type=str, default='stdin', help="output file")
    args = parser.parse_args()
    
    inDict = readFile (args.inputFile)
    
    count = debugFile (inDict)
    writeOutput (inDict, args.outputfile)

    
    print('done!    dupe count = ', count, '     total count = ', len(inDict.keys()))
    
    
    