#!/bin/bash

######################################################################
# FILE          : ntp.discovery.sh
# SUMMARY       : Discover the ntp server
######################################################################

OS_CHK=`uname`

case "${OS_CHK}" in
   "Linux")
       TAIL_COMM="tail -n" ;;
   "SunOS")
       TAIL_COMM="tail" ;;
   *)
       echo "ZBX_NOTSUPPORTED"
       exit 1 ;;
esac


LIST=`/usr/sbin/ntpq -p -n | ${TAIL_COMM} +3 | awk '{print $1}' | sed 's/^[\*|\+]//g'`

if [ "${LIST}" = "" ] ;then
    echo "ZBX_NOTSUPPORTED"
    exit 1
fi

 
echo "{"
echo "	\"data\":["

FIRST=1

for VER in ${LIST}
do

   if [ ${FIRST} -eq 1 ] ; then
      echo ""
      FIRST=0
   else
      echo ","
   fi

   echo -e -n "\t\t{ \"{#NTP_SERVER}\":\"${VER}\" }"

done

 
echo ""
echo "	]"
echo "}"


