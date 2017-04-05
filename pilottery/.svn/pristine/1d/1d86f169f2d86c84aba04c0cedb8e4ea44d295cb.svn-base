#!/bin/bash

let SAVE_LINE=3
SNAPSHOT_PATH=/ts_host/data/snapshot_data

dicrectCount=`ls -l $SNAPSHOT_PATH | grep -v total  | wc -l`

if [ $dicrectCount > $SAVE_LINE ]
then
    let line=$dicrectCount-$SAVE_LINE
    for mydic in `ls -lrt $SNAPSHOT_PATH | grep -v total | head -n $line | awk '{print $NF}'`
    do
        deldic=`echo "$SNAPSHOT_PATH/$mydic"`
        rm -rf $deldic
        echo "del $deldic over"
    done
fi
