#!/bin/bash

	    #########################################
	    #   SSL CERTIFICATES CHEKER by KiRoFF   #
	    #########################################

dir="/etc/ssl/ssl_monitoring/*.crt"

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

state=$STATE_OK

A=`date +%F`

for crt in $dir; do
    B="$(openssl x509 -in "$crt" -noout -enddate | cut -d= -f2-)"
    exp=$( bc <<<  "(`date -d \"$B\" +%s` - `date -d \"$A\" +%s`) / (24*3600)")

    if ([ "$exp" -le 14 ] && [ "$exp" -ge 4 ]); then
        MSG+="$exp days till expiration of $crt<br>"
	if [ $state -le $STATE_CRITICAL ]; then
            state=$STATE_WARNING
        fi
    fi

    if [ "$exp" -le 3 ]; then
        MSG+="$exp days till expiration of $crt<br>"
        state=$STATE_CRITICAL
    fi

done

if [ $state -eq $STATE_OK ]; then
    MSG="OK"
fi
