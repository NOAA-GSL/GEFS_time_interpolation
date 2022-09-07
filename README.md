# GEFS_time_interpolation

This includes scripts for time interpolating WGRIB-2 GEFS data. The example scripts are to get hourly data from 3-hourly data, using WGRIB-2 (wgrib2 v2.0.5 and above is needed).
- <em><b>run_GEFS_interpolation.ksh</b></em> is the wrapper script to run GEFS_interpolation.xml in rocoto
- <em><b>GEFS_interpolation.xml</b></em> is the xml to run the following 2 tasks: 
  - <em>GEFS_time_interp.sh</em> for the time interpolation task  
  - <em>clean.ksh</em> to clean up the old data
