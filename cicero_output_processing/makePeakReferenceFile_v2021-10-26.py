import argparse



def processFile(infilename, loopOutFileName, peakOutFileName):
    infile = open(infilename)
    loopOutFile = open(loopOutFileName, 'w')
    peakOutFile = open(peakOutFileName, 'w')

    prefixTag = 'CicPair'

    nLeadingZeroes = 9


    count = 1
    for line in infile:
        if not "Peak" in line and len(line.strip()) > 0:
            line = line.strip()
            s = line.split()

            peak1 = s[0].strip()
            peak2 = s[1].strip()
#             coaccess = s[2].strip()

            pairID = prefixTag + "_" + str(count).zfill(nLeadingZeroes)
            idA = pairID + "_a"
            idB = pairID + "_b"

            p1 = peak1.split("_")
            p2 = peak2.split("_")

            p1_chrom = p1[0].strip()
            p1_start = p1[1].strip()
            p1_end = p1[2].strip()

            p2_chrom = p2[0].strip()
            p2_start = p2[1].strip()
            p2_end = p2[2].strip()

            loopOutFile.write(peak1 + "\t" + peak2 + "\t" + pairID + "\n")

            peakOutFile.write(p1_chrom + "\t" + p1_start + "\t" + p1_end + "\t" + idA + "\n")
            peakOutFile.write(p2_chrom + "\t" + p2_start + "\t" + p2_end + "\t" + idB + "\n")
            count = count + 1

    infile.close()
    loopOutFile.close()
    peakOutFile.close()




if __name__ == "__main__":

    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-i', '--inputLoopFile', required=True, type=str, default='stdin', help="input file")
    parser.add_argument('-p', '--outputAllPeakFile', required=True, type=str, default='stdin', help="input file")
    parser.add_argument('-l', '--outputAllLoopFile', required=True, type=str, default='stdin', help="input file")
    args = parser.parse_args()

                    # infilename,    loopOutFileName, peakOutFileName
    processFile( args.inputLoopFile, args.outputAllLoopFile, args.outputAllPeakFile)
    print('\t\tdone making the peak label id files')
    
    