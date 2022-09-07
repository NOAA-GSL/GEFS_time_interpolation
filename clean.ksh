#!/bin/ksh --login
set -x
#
#-----------------------------------------------------------------------
# set up currentime from CDATE 
#-----------------------------------------------------------------------
#
currentime=$(echo "${CDATE}" | sed 's/\([[:digit:]]\{2\}\)$/ \1/')
current_day=$( echo "${CDATE}" | cut -c1-8 )
current_doy=$( date +%j --date="${current_day}" )
current_yy=$( echo "${CDATE}" | cut -c3-4 )

#-----------------------------------------------------------------------
# Delete old GEFS data
#-----------------------------------------------------------------------
deletetime=$(date +%Y%m%d -d "${currentime} ${CLEAN_HRS} hours ago")
deleteyy=$( echo "${deletetime}" | cut -c3-4 )
deleteday=$( echo "${deletetime}" | cut -c1-8 )
deletedoy=$( date +%j  --date="${deleteday}" )
echo "Deleting GEFS data before ${deletetime}..."
cd ${GEFS_targetdir}
set -A XX $(ls  ${deleteyy}* | sort -r)
for files in ${XX[*]}; do
  onetime=$( echo $files | cut -c1-5 )
  if [[ ${onetime} -le ${deleteyy}${deletedoy} ]]; then
    rm -f ${onetime}*
    echo "Deleted ${onetime}*"
  fi
done

#-----------------------------------------------------------------------
# Delete logs directories
#-----------------------------------------------------------------------

# Remove template date from last two levels
logs=$(echo ${LOGDIR} | rev | cut -f 2- -d / | rev)
cd ${logs} 
pwd
set -A XX $(ls -d 20* | sort -r)
for onetime in ${XX[*]}; do
  if [[ ${onetime} -le ${deletetime} ]]; then
    echo "Deleting files from ${logs}/${onetime}"
    rm -rf ${onetime}
  fi
done

exit 0

