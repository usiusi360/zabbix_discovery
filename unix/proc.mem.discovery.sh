#!/bin/bash

######################################################################
# FILE          : proc.mem.discovery.sh
# SUMMARY       : Discovered the process with a high memory usage
######################################################################

# description
#  $1 
#    RSS : 0
#    VSZ : 1
#  $2
#    Showing Top N

case "$1" in
   "0")
            MEM_TYPE=rss ;;
   "1")
            MEM_TYPE=vsz ;;
   *)
            echo "ZBX_NOTSUPPORTED"
            exit 1 ;;
esac

TOP_line=$2
if [ "${TOP_line}" = "" ] ;then
    echo "NO ARGUMENT"
    echo "Must be specified head line."
    exit 1
fi

LIST=`ps -eo ${MEM_TYPE},pid,comm | grep -v "PID COMMAND" | sort -nr | head -${TOP_line}`

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

   PROC_SIZE=`echo ${VER} | awk '{print $1}'`
   PROC_ID=`echo ${VER} | awk '{print $2}'`
   PROC_NAME=`echo ${VER} | awk '{print $3}'`

   if [ ${FIRST} -eq 1 ] ; then
      echo ""
      FIRST=0
   else
      echo ","
   fi

   echo -e -n "\t\t{ \"{#PROC_SIZE}\":\"${PROC_SIZE}\",\"{#PROC_NAME}\":\"${PROC_NAME}\",\"{#PROC_ID}\":\"${PROC_ID}\" }"

done

 
echo ""
echo "	]"
echo "}"


