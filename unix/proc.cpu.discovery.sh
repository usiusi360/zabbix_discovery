#!/bin/bash

######################################################################
# FILE          : proc.cpu.discovery.sh
# SUMMARY       : Discovered the process with a high cpu usage
######################################################################

# description
#  $1 : Showing Top N


TOP_line=$1

if [ "${TOP_line}" = "" ] ;then
    echo "NO ARGUMENT"
    echo "Must be specified head line."
    exit 1
fi

LIST=`pidstat -u | sed -e '0,3d' | awk '{print $6, $2, $8}' | sort -nr | head -${TOP_line}`

if [ "${LIST}" = "" ] ;then
    echo "ZBX_NOTSUPPORTED"
    exit 1
fi
 
echo "{"
echo "	\"data\":["

IFS=$'\n'
FIRST=1

for VER in ${LIST}
do

   PROC_NAME=`echo ${VER} | awk '{print $3}'`
   PROC_ID=`echo ${VER} | awk '{print $2}'`

   if [ ${FIRST} -eq 1 ] ; then
      echo ""
      FIRST=0
   else
      echo ","
   fi

   echo -e -n "\t\t{ \"{#PROC_NAME}\":\"${PROC_NAME}\",\"{#PROC_ID}\":\"${PROC_ID}\" }"

done

 
echo ""
echo "	]"
echo "}"


