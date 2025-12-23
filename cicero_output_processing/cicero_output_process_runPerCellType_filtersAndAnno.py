import argparse

# class CiceroLoop (object):
#     def __init__ (self, peak1, peak2, prom1, prom2):
#         self.peak1 = peak1
#         self.peak2 = peak2
#         self.prom1 = prom1
#         self.prom2 = prom2
#         #self.id = id


def readLoopRefFile(filename, minDist, maxPeakSize):
    file = open(filename)
    loopDict = dict()
    for line in file:
        line = line.strip()
        if len(line) > 0 and not line.startswith("Peak"):
            s = line.split()
            peak1 = s[0]
            peak2 = s[1]
#             coaccess = s[2]
            promA = s[2]
            promB = s[3]
#             Peak1	Peak2	coaccess	Peak1_Promoter	Peak2_Promoter
#                 chr10_100027740_100028800	chr10_100069172_100069763		LOXL4	.
            key1 = peak1 + "_" + peak2
            if not key1 in loopDict:
                loopDict[key1] = {}
            loopDict[key1]['peak1'] = peak1
            loopDict[key1]['peak2'] = peak2
            loopDict[key1]['promA'] = promA
            loopDict[key1]['promB'] = promB
            loopDict[key1]['pairType'] = ''
            
            
            if promA == '.' and promB == '.':
                loopDict[key1]['pairType'] = 'CC'
            if promA == '.' and promB != '.':
                loopDict[key1]['pairType'] = 'CP'
            if promA != '.' and promB == '.':
                loopDict[key1]['pairType'] = 'CP'
            if promA != '.' and promB != '.':
                loopDict[key1]['pairType'] = 'PP'
            
            p1 = peak1.split('_')
            p2 = peak2.split('_')
            
            chr1 = p1[0]
            chr2 = p2[0]
            start1 = p1[1]
            start2 = p2[1]
            end1 = p1[2]
            end2 = p2[2]
            
            dist = int(start2) - int(end1)
            
            
#             if dist == 0:
#                 print('dist = ', dist, 'start2 = ', start2, 'end1 = ', end1)
            
            loopDict[key1]['dist'] = dist
            
            
            if dist < minDist:
                loopDict[key1]['distCheck'] = 'Fail'
            else:
                loopDict[key1]['distCheck'] = 'Pass'
            
            
            peak1Size = int(end1) - int(start1)
            peak2Size = int(end2) - int(start2)
            
            
#             if peak1Size == 0 or peak2Size == 0:
#                 print('peak1Size = ', peak1Size, 'start1 = ', start1, 'end1 = ', end1)
#                 print('\t', line)
# #                 print('peak2Size = ', peak2Size, 'start2 = ', start2, 'end2 = ', end2)
                
            
            
            loopDict[key1]['peak1Size'] = peak1Size
            loopDict[key1]['peak2Size'] = peak2Size
            
            if peak1Size > maxPeakSize or peak2Size > maxPeakSize:
                loopDict[key1]['peakSizeCheck'] = 'Fail'
            else:
                loopDict[key1]['peakSizeCheck'] = 'Pass'
            
    file.close()
    return loopDict



def readCiceroFile (filename, loopDict, coaccessThreshold, minDist, maxPeakSize):
    file = open(filename)
    cicDict = {}
    negThreshold = -1*coaccessThreshold
    for line in file:
        line = line.strip()
        if len(line) > 0 and not line.startswith("Peak"):
            s = line.split()
            #Peak1	Peak2	coaccess
            #chr1_10684_9912	chr1_994351_995437	-0.00013886533974112
            peak1 = s[0]
            peak2 = s[1]
            coaccess = s[2]
            key1 = peak1 + "_" + peak2
            
            if not key1 in cicDict:
                cicDict[key1] = {}
            
            cicDict[key1]['peak1'] = peak1
            cicDict[key1]['peak2'] = peak2
            cicDict[key1]['coaccess'] = coaccess
            cicDict[key1]['CoA_Category'] = ''
            
            
            if not coaccess == 'NA':
                
            
                if float(coaccess) < coaccessThreshold and float(coaccess) > negThreshold:
                    cicDict[key1]['CoA_Category'] = 'Zero'
                if float(coaccess) >= coaccessThreshold:
                    cicDict[key1]['CoA_Category'] = 'Positive'
                if float(coaccess) <= negThreshold:
                    cicDict[key1]['CoA_Category'] = 'Negative'
            else:
                cicDict[key1]['CoA_Category'] = 'NA'
            
            if key1 in loopDict:
                cicDict[key1]['promA'] = loopDict[key1]['promA']
                cicDict[key1]['promB'] = loopDict[key1]['promB']
                cicDict[key1]['pairType'] = loopDict[key1]['pairType']
                cicDict[key1]['distCheck'] = loopDict[key1]['distCheck']
                cicDict[key1]['peakSizeCheck'] = loopDict[key1]['peakSizeCheck']
                cicDict[key1]['dist'] = loopDict[key1]['dist']
                cicDict[key1]['peak1Size'] = loopDict[key1]['peak1Size']
                cicDict[key1]['peak2Size'] = loopDict[key1]['peak2Size'] 
            else:
                cicDict[key1]['promA'] = '?'
                cicDict[key1]['promB'] = '?'
                cicDict[key1]['pairType'] = '?'
                p1 = peak1.split('_')
                p2 = peak2.split('_')

                chr1 = p1[0]
                chr2 = p2[0]
                start1 = p1[1]
                start2 = p2[1]
                end1 = p1[2]
                end2 = p2[2]
                dist = int(start2) - int(end1)
                cicDict[key1]['dist'] = dist


                if dist < minDist:
                    cicDict[key1]['distCheck'] = 'Fail'
                else:
                    cicDict[key1]['distCheck'] = 'Pass'


                peak1Size = int(end1) - int(start1)
                peak2Size = int(end2) - int(start2)

                cicDict[key1]['peak1Size'] = peak1Size
                cicDict[key1]['peak2Size'] = peak2Size

                if peak1Size > maxPeakSize or peak2Size > maxPeakSize:
                    cicDict[key1]['peakSizeCheck'] = 'Fail'
                else:
                    cicDict[key1]['peakSizeCheck'] = 'Pass'
    file.close()
    return cicDict



def writeOutputFile (outfilename, cicDict, cellType):
    outfile = open(outfilename, 'w')
    
    headerList = ['Peak1', 'Peak2', 'coaccess', 'Peak1_Promoter', 'Peak2_Promoter', 
                   'Coaccess_Category', 'Loop_Pair_Type', 'Cell_Type', 
                   'CoACategory_Loop_Pair_Type', 
                   'Dist_bt_Peaks', 'Peak1_Size', 'Peak2_Size', 
                   'MinDistance_bt_Peaks_Check', 'MaxPeakSize_Check' ]
    header = '\t'.join(headerList) + '\n'
    outfile.write(header)
    
    
    
    for key1 in cicDict.keys():
        peak1 = cicDict[key1]['peak1'] 
        peak2 = cicDict[key1]['peak2'] 
        coa = str(cicDict[key1]['coaccess']) 
        coaCat = cicDict[key1]['CoA_Category']
        promA = cicDict[key1]['promA']
        promB = cicDict[key1]['promB']
        pairType = cicDict[key1]['pairType']
        distCheck = cicDict[key1]['distCheck']
        dist = str(cicDict[key1]['dist'])
        peak1Size = str(cicDict[key1]['peak1Size'])
        peak2Size = str(cicDict[key1]['peak2Size'])
        peakSizeCheck = cicDict[key1]['peakSizeCheck']
        
        
        pairTypeString = 'pairType=' + pairType
        allCategoryString = coaCat + '_' + pairType
        distCheckString = 'minimumDistanceBetweenPeaksCheck=' + distCheck
        distanceString = 'distanceBetweenPeaks=' + dist
        peak1SizeString = 'peak1Length=' + peak1Size
        peak2SizeString = 'peak2Length=' + peak2Size
        peakSizeCheckString = 'peakLengthCheck=' + peakSizeCheck
        
        
        outlist = [peak1, peak2, coa, promA, promB, 
                   coaCat, pairTypeString, cellType, allCategoryString, 
                   distanceString, peak1SizeString, peak2SizeString, 
                   distCheckString, peakSizeCheckString ]
        outline = '\t'.join(outlist) + '\n'
        outfile.write(outline)




def writeOutputFile_ONLY_GOOD (outfilename, cicDict, cellType):
    good_outfileName = outfilename.replace('.txt', '')
    good_outfileName = good_outfileName + '.Only_CP_Pos_Good.txt'
    
    outfile = open(good_outfileName, 'w')
    
    headerList = ['Peak1', 'Peak2', 'coaccess', 'Peak1_Promoter', 'Peak2_Promoter', 
                   'Coaccess_Category', 'Loop_Pair_Type', 'Cell_Type', 'CoACategory_Loop_Pair_Type', 
                   'Dist_bt_Peaks', 'Peak1_Size', 'Peak2_Size', 
                   'MinDistance_bt_Peaks_Check', 'MaxPeakSize_Check' ]
    header = '\t'.join(headerList) + '\n'
    outfile.write(header)
    
    
    
    for key1 in cicDict.keys():
        peak1 = cicDict[key1]['peak1'] 
        peak2 = cicDict[key1]['peak2'] 
        coa = str(cicDict[key1]['coaccess']) 
        coaCat = cicDict[key1]['CoA_Category']
        promA = cicDict[key1]['promA']
        promB = cicDict[key1]['promB']
        pairType = cicDict[key1]['pairType']
        distCheck = cicDict[key1]['distCheck']
        dist = str(cicDict[key1]['dist'])
        peak1Size = str(cicDict[key1]['peak1Size'])
        peak2Size = str(cicDict[key1]['peak2Size'])
        peakSizeCheck = cicDict[key1]['peakSizeCheck']
        
        
        pairTypeString = 'pairType=' + pairType
        allCategoryString = coaCat + '_' + pairType
        distCheckString = 'minimumDistanceBetweenPeaksCheck=' + distCheck
        distanceString = 'distanceBetweenPeaks=' + dist
        peak1SizeString = 'peak1Length=' + peak1Size
        peak2SizeString = 'peak2Length=' + peak2Size
        peakSizeCheckString = 'peakLengthCheck=' + peakSizeCheck
        
        
        
        
        if coaCat == 'Positive' and pairType == 'CP' and distCheck == 'Pass' and peakSizeCheck == 'Pass':
            outlist = [peak1, peak2, coa, promA, promB, 
                       coaCat, pairTypeString, cellType, allCategoryString, 
                       distanceString, peak1SizeString, peak2SizeString, 
                       distCheckString, peakSizeCheckString ]
            outline = '\t'.join(outlist) + '\n'
            outfile.write(outline)
    outfile.close()
        
        
        
        
        
        
        


if __name__ == "__main__":


    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-l', '--refLoopFile', required=True, type=str, help="refLoopFile")
    parser.add_argument('-c', '--originalCiceroFile', required=True, type=str, help="originalCiceroFile")
    parser.add_argument('-o', '--outputFile', required=True, type=str, help="output file name")
    parser.add_argument('-s', '--ciceroScoreThreshold', required=True, type=str, help="minimum cicero score")
    parser.add_argument('-d', '--minimumDistanceBetweenPeaksInLoop', required=True, type=str, help="minimum distance between peaks") # 10kb?
    parser.add_argument('-p', '--maximumPeakSize', required=True, type=str, help="maximum peak size") # 5kb?
    parser.add_argument('-e', '--cellType', required=True, type=str, help="cell type to annotate loops with") # 5kb?
    
    args = parser.parse_args()

    print("\t \t ref loop file = ", args.refLoopFile)
    print("\t \t cicero file = ", args.originalCiceroFile)
    print("\t \t cicero Score Threshold = ", args.ciceroScoreThreshold)
    print("\t \t minimumDistanceBetweenPeaksInLoop = ", args.minimumDistanceBetweenPeaksInLoop)
    print("\t \t maximumPeakSize = ", args.maximumPeakSize)
    print("\t \t cellType = ", args.cellType)
    print("\t \t outputfile = ", args.outputFile)
    
    
    
    print("\t reading ref loop file")
    loopDict = readLoopRefFile(args.refLoopFile, int(args.minimumDistanceBetweenPeaksInLoop), int(args.maximumPeakSize))
    print("\t reading cicero file")
    cicDict = readCiceroFile (args.originalCiceroFile, loopDict, float(args.ciceroScoreThreshold), int(args.minimumDistanceBetweenPeaksInLoop), int(args.maximumPeakSize))
    
    print('\t writing output annotated cicero file')
    writeOutputFile (args.outputFile, cicDict, args.cellType)
    
    print('\t writing output annotated cicero file -- 2nd file with just CP Pos QC Passing loops')
    writeOutputFile_ONLY_GOOD (args.outputFile, cicDict, args.cellType)
    print('\t Done writing annotated cicero file!')
          
          
    