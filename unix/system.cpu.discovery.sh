#!/bin/bash

######################################################################
# FILE          : system.cpu.discovery.sh
# SUMMARY       : Discover the number of the cpu core
######################################################################


OS_CHK=`uname`

case "${OS_CHK}" in
   "Linux")
            LIST=`cat /proc/cpuinfo | grep processor  | cut -d ":" -f2 | sed 's/ //g'` ;;
   "SunOS")
            LIST=`/usr/sbin/psrinfo | cut -f1` ;;
   *)
            echo "ZBX_NOTSUPPORTED"
            exit 1 ;;
esac

if [ "${LIST}" = "" ] ;then
    echo "ZBX_NOTSUPPORTED"
    exit 1
fi

echo "{"
echo "  \"data\":["

FIRST=1

for VER in ${LIST}
do

   if [ ${FIRST} -eq 1 ] ; then
      echo ""
      FIRST=0
   else
      echo ","
   fi

   echo -e -n "\t\t{ \"{#CPU_NO}\":\"${VER}\" }"

done


echo ""
echo "  ]"
echo "}"





