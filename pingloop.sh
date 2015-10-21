#!/opt/bin/bash

LOG=/opt/script/pinglog.log
SECONDS=2

EMAIL=someone@somedomain.local

for i in $@; do
        echo "$i-UP!" > $LOG.$i

done

while true; do
        for i in $@; do

ping -c 1 $i > /dev/null
if [ $? -ne 0 ]; then
        STATUS=$(cat $LOG.$i)
                if [ $STATUS != "$i-DOWN!" ]; then
                        echo "`date`: ping failed, $i host is down!" |
                        mail -s "$i host is down!" $EMAIL

                fi
        echo "$i-DOWN!" > $LOG.$i

fi
done

sleep $SECONDS
done
