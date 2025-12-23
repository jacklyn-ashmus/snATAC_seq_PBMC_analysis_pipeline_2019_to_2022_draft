import argparse



class CiceroLoop (object):
    def __init__ (self, peak1, peak2, prom1, prom2):
        self.peak1 = peak1
        self.peak2 = peak2
        self.prom1 = prom1
        self.prom2 = prom2
        #self.id = id




def readLoopRefFile(filename):
    file = open(filename)
    loopDict = dict()
    for line in file:
        line = line.strip()
        if len(line) > 0 and not line.startswith("Peak"):
            s = line.split()
            peak1 = s[0]
            peak2 = s[1]
            coaccess = s[2]
            promA = s[3]
            promB = s[4]
            key1 = peak1 + "_" + peak2
            cic = CiceroLoop(peak1, peak2, promA, promB)
            loopDict[key1] = cic
    file.close()
    return loopDict


def readCiceroFile (filename, outputfilename, loopDict):
    file = open(filename)
    outputFile = open(outputfilename, 'w')

    outputFile.write("Peak1\tPeak2\tcoaccess\tPeak1Promoter\tPeak2Promoter\n")
    for line in file:
        line = line.strip()
        if len(line) > 0 and not line.startswith("Peak"):
            s = line.split()

            peak1 = s[0]
            peak2 = s[1]
            coaccess = s[2]
            key1 = peak1 + "_" + peak2

            if key1 in loopDict:
                cic = loopDict[key1]
            else:
                cic = CiceroLoop(peak1, peak2, ".", ".")

            outputFile.write(peak1 + "\t" + peak2 + "\t" + coaccess + "\t" + cic.prom1  + "\t" + cic.prom2  + "\n")
    file.close()
    outputFile.close()

    print("done writing :    ", outputfilename)








if __name__ == "__main__":


    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-l', '--refLoopFile', required=True, type=str, help="refLoopFile")
    parser.add_argument('-c', '--originalCiceroFile', required=True, type=str, help="originalCiceroFile")
    parser.add_argument('-o', '--outputfile', required=True, type=str, help="cicero output file name")
    args = parser.parse_args()

    print(" ref loop file = ", args.refLoopFile)
    print(" cicero file = ", args.originalCiceroFile)
    print(" outputfile = ", args.outputfile)
    print("reading ref loop file")
    loopDict = readLoopRefFile(args.refLoopFile)
    print("reading cicero file")
    readCiceroFile(args.originalCiceroFile, args.outputfile, loopDict)