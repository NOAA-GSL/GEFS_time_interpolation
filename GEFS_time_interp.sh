#!/bin/ksh --login
set -x
#------------------------------
# from https://www.cpc.ncep.noaa.gov/products/wesley/wgrib2/time_interpolation.html
#------------------------------
# use wgrib2 to interpolate to time interpolate two forecast files
#
# ASSUMPTION: THE TWO FORECAST FILES MUST HAVE THE RECORDS IN THE
# SAME ORDER
#
# $1 = 3 hour forecast
# $2 = 6 hour forecast
# $3 = output   ( 4 and 5 hour forecasts)
#
# note: wgrib2 v2.0.5 is needed for the -set_scaling same same
#    for older versions of wgrib2, remove the "-set_scaling same same"
#    the output will be written in the default mode .. 12 bits
# for wgrib2 on Jet, the default version is old so swtich to my own wgrib2 under my miniconda3
#   to do so, simply switch to bash by doing "bash" in command line
#   it will point to /mnt/lfs4/HFIP/gsihyb/Chunhua.Zhou/code/Miniconda3/miniconda3/bin/wgrib2
#
module purge
module load intel/18.0.5.274
module load wgrib2/2.0.8
wgrib2=/apps/wgrib2/2.0.8/intel/18.0.5.274/bin/wgrib2

#for yyyymmdd in 20220831 ; do
yyyymmdd=$PDY
yy="${yyyymmdd:2:2}"
doy=`date  --date=$yyyymmdd +%j `
#  for mem in $(seq -w 1 30); do
#GEFS_sourcedir=/public/data/grids/gens/pgrb2b/gep${mem}
#GEFS_targetdir=/mnt/lfs4/BMC/wrfruc/RRFSE/data/gens/gep${mem}
    datadir=${GEFS_sourcedir}
    workdir=${GEFS_targetdir}
    if [ ! -d $workdir ]; then
       mkdir -p $workdir
    fi
    cd $workdir
#    for hh in $(seq -w 0 6 18); do
      hh=$HH
      for fcsthr in $( seq $HR1 3 $HR2 ); do
      fcsthr1=$(( $fcsthr + 1))
      fcsthr2=$(( $fcsthr + 2))
      fcsthr3=$(( $fcsthr + 3))
      ifcsthr=$(printf "%02d" $fcsthr ) 
      ifcsthr1=$(printf "%02d" $fcsthr1 ) 
      ifcsthr2=$(printf "%02d" $fcsthr2 ) 
      ifcsthr3=$(printf "%02d" $fcsthr3 ) 

      in1=${yy}${doy}${hh}0000${ifcsthr}
      in2=${yy}${doy}${hh}0000${ifcsthr3}

      out1=${yy}${doy}${hh}0000${ifcsthr1}
      out2=${yy}${doy}${hh}0000${ifcsthr2}
      vtime=$( date +%Y%m%d%H -d "${yyyymmdd} ${hh} +$fcsthr hours" )
 
      while [ ! -s ${datadir}/$in1 ] || [ ! -s  ${datadir}/$in2 ]; do  
        sleep 30
      done
      if [ ! -s $in1 ]; then
        ln -sf ${datadir}/$in1 .
      fi  
      if [ ! -s $in2 ]; then
        ln -sf ${datadir}/$in2 .
      fi  
      
#in1=2209406000003
#in2=2209406000006
#a="3 hour forecast"
#a="vt=2022040409"
a="vt=${vtime}"

if [ ! -s $out1 ]; then
d1="${fcsthr1} hour forecast"
b1=0.6667
c1=0.3333
$wgrib2 $in1 -rpn sto_1 -import_grib $in2 -rpn sto_2 -set_grib_type same \
  -if ":$a:" \
     -rpn "rcl_1:$b1:*:rcl_2:$c1:*:+" -set_ftime "$d1" -set_scaling same same -grib_out $out1 
fi

if [ ! -s $out2 ]; then
d2="${fcsthr2} hour forecast"
b2=0.3333
c2=0.6667
$wgrib2 $in1 -rpn sto_1 -import_grib $in2 -rpn sto_2 -set_grib_type same \
  -if ":$a:" \
     -rpn "rcl_1:$b2:*:rcl_2:$c2:*:+" -set_ftime "$d2" -set_scaling same same -grib_out $out2 
fi

      done
#    done
#  done
#done


