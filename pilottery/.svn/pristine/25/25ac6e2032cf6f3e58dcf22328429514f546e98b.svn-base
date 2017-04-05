#!/bin/bash

TICKET_FILE=$1
HOST_URL='http://192.168.26.69:20080/do'
AGENCY_CODE=03010002
count=10000000
Today=`date "+%Y%m%d" | cut -c 3-8`

curlcmd()
{
    timestamp=$1
	reqfn=$2
	bet_string=$3
	rsp=`curl --request POST --url "${HOST_URL}" --header 'content-type: application/json' --data '{"when": '${timestamp}', "msn": 2, "token": 0, "version": "1.0.0","func": 55001,"type": 5,"params": {"agencyCode": '${AGENCY_CODE}',"reqfn": "'${reqfn}'","bet_string": "'${bet_string}'"}}\r\n'`
	echo "rsp:[${rsp}]"
}

while read line
do
    times=`date +%s`
	count=$((count+1))
	reqfnstr=`echo "${Today}${times}${count}"`
	curlcmd ${times} "${reqfnstr}" "${line}"
done<$TICKET_FILE
