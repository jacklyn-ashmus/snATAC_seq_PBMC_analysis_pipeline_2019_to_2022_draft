#!/usr/bin/env bash

INFILE=$1
OUTFILE=$2

INFILE_INTERMED="${INFILE}.lesscol.txt"
INFILE_INTERMED2="${INFILE}.lftmtx.unsort.txt"

awk '{print $4 "\t" $8 }' "$INFILE" > "$INFILE_INTERMED"



#   1         2       3                4                             5      6           7      8                                        9      10                    
# chr1    778525  778925  Schwann_General_ccreID_0000042724       chr1    778492  778692  Single1_CoCl2_MM779_MM765_TAGCGGCTCTTACTCG-1  60      +
    
    awk '{
        combination = $1 "\t" $2
        count[combination]++
    }
    END {
        for (comb in count) {
            print comb, count[comb]
        }
    }' "$INFILE_INTERMED" > "$INFILE_INTERMED2"
    
    
    
sort -k1,1 -k2,2n  "$INFILE_INTERMED2" > "$OUTFILE"