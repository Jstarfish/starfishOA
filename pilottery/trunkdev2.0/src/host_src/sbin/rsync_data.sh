#!/bin/bash

#. /etc/profile.d/ts.sh

LOG_FILE='/ts_host/logs/rsync_data.log'
LOCK_FILE="/ts_host/task/rsync_data.lock"

game_data_src_dir="/ts_host/data/game_data"
dest_host="192.168.26.57"
game_data_dest_dir="/home/release/data_bak"
session_src_dir="/ts_host/data"
session_dest_dir="/home/release/session"
exitcode_file="/ts_host/task/rsync_exitcode"

if [ $# != 1 ] ; then
    echo "Usage: $0 session_id"
    exit 1
fi

session_id=$1

(
flock -x -w 0 200
if [ $? -eq 1 ] ; then
    echo "$(date) -> [$0]: Unable to get the lock for ${LOCK_FILE}." | tee -a ${LOG_FILE}
else
    #Do something here under the protect of file lock
    cmd="rsync -avzS ${game_data_src_dir} $(whoami)@${dest_host}:${game_data_dest_dir}"
    echo "$(date): Try to call: ${cmd}" | tee -a ${LOG_FILE}
    $cmd 1>>${LOG_FILE} 2>&1
    echo $? >${exitcode_file}
    if [ $(cat ${exitcode_file}) != 0 ] ; then
        exit $(cat ${exitcode_file})
    fi

    cmd="rsync -avzS ${session_src_dir}/session_${session_id} $(whoami)@${dest_host}:${session_dest_dir}"
    echo "$(date): Try to call: ${cmd}" | tee -a ${LOG_FILE}
    $cmd 1>>${LOG_FILE} 2>&1
    echo $? >${exitcode_file}
fi
) 200>${LOCK_FILE}

exit $(cat ${exitcode_file})

