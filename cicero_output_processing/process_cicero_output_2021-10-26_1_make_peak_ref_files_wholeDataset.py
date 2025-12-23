import argparse




# 





# 1. make comprehensivePeakFile
def read_original_peak_merged_bare_bed_file (peakbedfilename):
    infile = open(peakbedfilename)
    
    peakDict = {}
    
    
    peakList = list()
    

    nLeadingZeroes = 9


    
    
    
    
    count = 1
    for line in infile:
        if not "Peak" in line and len(line.strip()) > 0:
            line = line.strip()
            s = line.split()
            
            # chr1	9912	10684
            chrom = s[0]
            start = s[1]
            end = s[2]
            
            
            
            
       

            peak1 = s[0].strip()
            peak2 = s[1].strip()
            coaccess = s[2].strip()

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

            loopOutFile.write(peak1 + "\t" + peak2 + "\t" + coaccess + "\t" + pairID + "\n")

            peakOutFile.write(p1_chrom + "\t" + p1_start + "\t" + p1_end + "\t" + idA + "\n")
            peakOutFile.write(p2_chrom + "\t" + p2_start + "\t" + p2_end + "\t" + idB + "\n")
            count = count + 1

    infile.close()
    loopOutFile.close()
    peakOutFile.close()

    







def processFile(infilename, loopOutFileName, peakOutFileName,  prefixTag):
    infile = open(infilename)
    loopOutFile = open(loopOutFileName, 'w')
    peakOutFile = open(peakOutFileName, 'w')



    nLeadingZeroes = 9


    count = 1
    for line in infile:
        if not "Peak" in line and len(line.strip()) > 0:
            line = line.strip()
            s = line.split()

            peak1 = s[0].strip()
            peak2 = s[1].strip()
            coaccess = s[2].strip()

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

            loopOutFile.write(peak1 + "\t" + peak2 + "\t" + coaccess + "\t" + pairID + "\n")

            peakOutFile.write(p1_chrom + "\t" + p1_start + "\t" + p1_end + "\t" + idA + "\n")
            peakOutFile.write(p2_chrom + "\t" + p2_start + "\t" + p2_end + "\t" + idB + "\n")
            count = count + 1

    infile.close()
    loopOutFile.close()
    peakOutFile.close()




if __name__ == "__main__":

    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-i', '--inputFile', required=True, type=str, default='stdin', help="input file")
    parser.add_argument('-p', '--prefixTag', required=True, type=str, help="output file name")
    parser.add_argument('-a', '--loopFile', required=True, type=str, help="loop ref output file name")
    parser.add_argument('-b', '--peakFile', required=True, type=str, help="peak ref output file name")
    args = parser.parse_args()


    processFile( args.inputFile, args.loopFile, args.peakFile, args.prefixTag)
