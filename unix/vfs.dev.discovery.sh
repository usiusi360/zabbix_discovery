#!/bin/bash

######################################################################
# FILE          : vfs.dev.discovery.sh
# SUMMARY       : Discover the name of the disk device
######################################################################


OS_CHK=`uname`

case "${OS_CHK}" in
   "Linux")
            LIST=`cat /proc/partitions | awk '{print $4}' | tail -n +3` ;;
   "SunOS")
            LIST=`iostat -x | awk '{print $1}' | tail +3` ;;
   *)
            echo "ZBX_NOTSUPPORTED"
            exit 1 ;;
esac

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

   echo -e -n "\t\t{ \"{#DEVNAME}\":\"${VER}\" }"

done

 
echo ""
echo "	]"
echo "}"


