#!/bin/ksh --login

set -e
source /home/rtrr/PARM_EXEC/modulefiles/modulefile.jet.ROCOTO

rocotorun  -w GEFS_interpolation.xml -d GEFS_interpolation.db -v 10

