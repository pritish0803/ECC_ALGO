#! /bin/csh

ns wrls-aodv.tcl
exec awk -f getRatio.awk tracef.tr >sam.tr & #----------------------------------------------------------------------------------------
exec awk -f measuredelay.awk tracef.tr >sam2.tr &

g++ test.cpp
./a.out


rm -f sim.*
# that meanig put choosing colum form file tracef.tr to file sam.tr packet deliver ratio information
