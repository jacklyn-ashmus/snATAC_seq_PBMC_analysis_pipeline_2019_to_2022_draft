import argparse



class CiceroLoop (object):
    def __init__ (self, peak1, peak2, prom1, prom2):
        self.peak1 = peak1
        self.peak2 = peak2
        self.prom1 = prom1
        self.prom2 = prom2
        #self.id = id



def readPeakRefFile (filename):
    file = open(filename)

    peakDict = dict()


    for line in file:
        line = line.strip()
        if len(line) > 0 and not line.startswith("Peak"):
            s = line.split("\t")
            s1 = line.split(" ") # just in case the columns are split by spaces and not tabs

            if len(s1) > len(s):
                s = s1
            
#             if len(s) < 4:
#                 print(s)
            
            
            
            chrom = s[0]
            start = s[1]
            end = s[2]
            id = s[3]
            if len(s) > 4:
                prom = s[4]
            else:
                prom = "."
            if id not in peakDict:
                list1 = list()
                if prom != '.':
                    list1.append(prom)
                peakDict[id] = list1
            else:
                list1 = peakDict.get(id)

                if not prom in list1 and prom != '.':
                    list1.append(prom)
                peakDict[id] = list1
    return peakDict


def readLoopRefFile (infilename, peakDict, outfilename):

    loopFile = open(infilename)
    outfile = open(outfilename, 'w')

    outfile.write("Peak1\tPeak2\tcoaccess\tPeak1_Promoter\tPeak2_Promoter\n")
    for line in loopFile:
        line = line.strip()

        if len(line) > 0:
            s = line.split("\t")
            peak1 = s[0]
            peak2 = s[1]
            id = s[2]
            
#             if len(s) < 4:
#                 print(s)
            
            
            
            

            idA = id + "_a"
            idB = id + "_b"

            if idA in peakDict:
                listA = peakDict[idA]
            else:
                listA = list()
            if idB in peakDict:
                listB = peakDict[idB]
            else:
                listB = list()

            if len(listA) > 0:
                listA.sort()

                if len(listA) > 1:
                    promA = (',').join(listA)
                else:
                    promA = listA[0]

            else:
                promA = '.'


            if len(listB) > 0:
                listB.sort()

                if len(listB) > 1:
                    promB = (',').join(listB)
                else:
                    promB = listB[0]

            else:
                promB = '.'



            outfile.write(peak1 + "\t" + peak2 + "\t" + "\t" + promA + "\t" + promB + "\n")

    loopFile.close()
    outfile.close()



if __name__ == "__main__":


    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-p', '--refPeakFile', required=True, type=str, default='stdin', help="refPeakFile, already intersected with references and processed")
    parser.add_argument('-l', '--refLoopFile', required=True, type=str, help="refLoopFile")
    parser.add_argument('-o', '--outputfile', required=True, type=str, help="peak ref output file name")
    args = parser.parse_args()

    peakDict = readPeakRefFile(args.refPeakFile)
    readLoopRefFile(args.refLoopFile, peakDict, args.outputfile)
