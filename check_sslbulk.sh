#!/bin/bash

dir="/etc/ssl/ssl_monitoring/*.crt"

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

A=`date +%F`

state=$STATE_OK

for crt in $dir; do
    B="$(openssl x509 -in "$crt" -noout -enddate | cut -d= -f2-)"
    exp=$( bc <<<  "(`date -d \"$B\" +%s` - `date -d \"$A\" +%s`) / (24*3600)")
                if ([ "$exp" -le 14 ] && [ "$exp" -ge 4 ])
                 then
                    echo $exp "days till expire" $crt "is expiring in 2 weeks!"
                    state=$STATE_WARNING
                fi
                if [ "$exp" -le 3 ]
                        then
                        echo $exp "days till expiration" $crt " Renew it ASAP"
                        state=$STATE_CRITICAL
                fi
#echo $exp $crt
done
exit $state
