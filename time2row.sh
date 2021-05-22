#! /bin/bash
#
# @file time2row.sh
# @brief 
# @author TangJX, mrytsr@gmail.com
# @version 0.1
# @date 2015-07-23
#


TARGET_TIME=$2

if [ $1 = '' | ${TARGET_TIME} = '' ]; then
    echo 'usage: time2row.sh {file} {time}'
    echo 'example1: time2row.sh aa.log 2014-03-03 10:00:00'
    echo 'example2: time2row.sh aa.log 2014-03-03 10:00'
    exit
fi

WRAP_COUNT_FILE=/tmp/`ls -la $1|md5sum|awk '{print $1}'`
WRAP_COUNT="`head $WRAP_COUNT_FILE 2>&1|egrep -o ^[0-9]+$`"
if [ "$WRAP_COUNT" == "" ]; then
    WRAP_COUNT=`wc -l $1|awk '{print $1}'`
    echo "$WRAP_COUNT">"$WRAP_COUNT_FILE"
fi

START_ROW=1
END_ROW=$WRAP_COUNT

MATCH_ROW=0
while [ $MATCH_ROW == 0 ]
do
    ROW=`expr $START_ROW / 2 + $END_ROW / 2`
    ROW_1=`expr ${ROW} + 1`

    ROW_TIME=`sed -n "${ROW_1}q;${ROW},${ROW}p" $1|egrep -o '[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}'`

    if [ "`echo "$ROW_TIME" |egrep -o "^$TARGET_TIME.*$"`" != "" ]; then
        MATCH_ROW=$ROW
        echo $ROW
        exit
    elif [ "$ROW_TIME" \> "$TARGET_TIME" ]; then
        END_ROW=$ROW
        echo "END_ROW=$ROW"
    elif [ "$ROW_TIME" \< "$TARGET_TIME" ]; then
        START_ROW=$ROW
        echo "START_ROW=$ROW"
    fi
done
