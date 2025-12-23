import argparse


def processFile(infilename, outfileName):
    infile = open(infilename)
    outfile = open(outfileName, 'w')
        
    countStartEndSwitch = 0
    countPeakSwitch = 0
    #     Peak1 Peak2 coaccess
    # chr1_10684_9912	chr1_994351_995437	0
    outfile.write('Peak1\tPeak2\tcoaccess\n')
    for line in infile:
        if not "Peak" in line and len(line.strip()) > 0:
            line = line.strip()
            s = line.split()

            peak1 = s[0].strip()
            peak2 = s[1].strip()
            coaccess = s[2].strip()
            
            p1 = peak1.split("_")
            p2 = peak2.split("_")

            p1_chrom = p1[0].strip()
            p1_start = p1[1].strip()
            p1_end = p1[2].strip()

            p2_chrom = p2[0].strip()
            p2_start = p2[1].strip()
            p2_end = p2[2].strip()
            
            
            p1_start_int = int(p1_start)
            p1_end_int = int(p1_end)
            
            p2_start_int = int(p2_start)
            p2_end_int = int(p2_end)
            
            if p1_end_int < p1_start_int:
                countStartEndSwitch = countStartEndSwitch + 1
                b4P1 = peak1
                
                
                p1_end_int, p1_start_int = p1_start_int, p1_end_int
                p1_end, p1_start = p1_start, p1_end
                afterP1 = p1_chrom + '_' + p1_start + '_' + p1_end
                
#                 if countPeakSwitch % 100 == 0:
#                     print('\t\tstart / end switch = ', b4P1, '--->',  afterP1)
                

            if p2_end_int < p2_start_int:
                countStartEndSwitch = countStartEndSwitch + 1
                b4P2 = peak2

                p2_end_int, p2_start_int = p2_start_int, p2_end_int
                p2_end, p2_start = p2_start, p2_end
                afterP2 = p2_chrom + '_' + p2_start + '_' + p2_end
                
#                 if countPeakSwitch % 100 == 0:
#                     print('\t\tstart / end switch = ', b4P2, '--->',  afterP2)
                

            peak1 = p1_chrom + '_' + p1_start + '_' + p1_end
            peak2 = p2_chrom + '_' + p2_start + '_' + p2_end
            
            if p2_start_int <  p1_start_int:
                countPeakSwitch = countPeakSwitch + 1
                
#                 if countPeakSwitch % 300 == 0:
#                     print('\t\tpeak switch = ', peak1, peak2, '    ---->',  peak2, peak1)
                
                
                peak2, peak1 = peak1, peak2
                

            outfile.write(peak1 + "\t" + peak2 + "\t" + coaccess + "\n")
    
    print('\t\tcountStartEndSwitch = ', countStartEndSwitch)   
    print('\t\tcountPeakSwitch = ', countPeakSwitch)   
    infile.close()
    outfile.close()
   


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-i', '--inputfile', required=True, type=str, default='stdin', help="input file")
    parser.add_argument('-o', '--outputfile', required=True, type=str, default='stdin', help="output file")
    args = parser.parse_args()
    processFile( args.inputfile, args.outputfile)
    
    