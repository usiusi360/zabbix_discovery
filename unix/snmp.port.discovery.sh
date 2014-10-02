#!/bin/bash

######################################################################
# FILE          : snmp.port.discovery.sh
# SUMMARY       : Discovered the port of snmp device 
# DATE          : 2013/2/11
# VERSION       : 1.0
######################################################################

C_STRING=$1
if [ "${C_STRING}" = "" ] ;then
    echo "NO ARGUMENT"
    echo "### ./snmp.port.discovery.sh [community string] [target ip]"
    exit 1
fi

TARGET=$2
if [ "${TARGET}" = "" ] ;then
    echo "NO ARGUMENT"
    echo "### ./snmp.port.discovery.sh [community string] [target ip]"
    exit 1
fi


IFS=$'\n'
array1=(`snmpwalk -c ${C_STRING} -v 1 ${TARGET} IF-MIB::ifIndex | cut -d ":" -f4 | sed 's/^ //g'`)
if [ "${array1[1]}" = "" ] ;then
    echo "ZBX_NOTSUPPORTED"
    exit 1
fi

array2=(`snmpwalk -c ${C_STRING} -v 1 ${TARGET} IF-MIB::ifDescr | cut -d ":" -f4 | sed 's/^ //g'`)
array3=(`snmpwalk -c ${C_STRING} -v 1 ${TARGET} IF-MIB::ifAlias | cut -d ":" -f4 `)


echo "{"
echo "  \"data\":["

FIRST=1
i=0

for VER in ${array1[@]}
do

  if [ ${FIRST} -eq 1 ] ; then
     echo ""
     FIRST=0
  else
     echo ","
  fi

  if [ "${array3[i]}" = " " ] ;then
     array3[i]=Unknown
  else
     array3[i]=`echo "${array3[i]}" | sed 's/^ //g' `
  fi

  echo -e -n "\t\t{ \"{#IF_INDEX}\":\"${array1[i]}\",\"{#IF_DESCR}\":\"${array2[i]}\",\"{#IF_NAME}\":\"${array3[i]}\" }"

  i=${i}+1

done

echo ""
echo "  ]"
echo "}"


