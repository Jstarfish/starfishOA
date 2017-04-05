#!/bin/bash

TS_HOST='/ts_host'

LOG_FILE="${TS_HOST}/logs/ts_servctl.log"
PID_FILE="${TS_HOST}/logs/ts.pid"
LOCK_FILE="${TS_HOST}/task/ts_running.lock"
SESSION_DATE_FILE="${TS_HOST}/data/tfe_data/session"
TFE_FILE="${TS_HOST}/data/tfe_data/datazoo_0.tf"

# Define some colors first:
green='\e[0;1;32m'
red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
NC='\e[0m' # No Color

P ()
{
    if [ "X$@" = "X" ]; then
        ps -elf;
    else
        ps -elf | grep "$@" | grep -v grep;
    fi
}

view(){
cnt=`ps -aef|grep tstop|grep -v grep|wc -l`
if [ $cnt -eq 1 ]; then
	pstree -A `ps -aef|grep tstop|grep -v grep|awk '{print $2}'`
fi
}

check_sessionDate(){
    if [ ! -s $SESSION_DATE_FILE ]; then
        if [ ! -s $TFE_FILE ]; then
            date +"%Y%m%d" > $SESSION_DATE_FILE
        else
            echo "There are some tfe files but NO session data file, enter key Y to create it, other keys to exit..."
            read -n 1 -p "Input:" ifcreat
            inputKey=`echo $ifcreat | tr [a-z] [A-Z]`
            if [ "$inputKey"z = "Y"z ]; then
                date +"%Y%m%d" > $SESSION_DATE_FILE
                echo "create session date file: $SESSION_DATE_FILE ..."
                cat $SESSION_DATE_FILE
            else
                echo "TaiShan exit!"
                exit 0
            fi
        fi
    fi
}

check_user_is_taishan(){
myid=`id -u`
tsid=`id -u taishan`
if [ $myid -ne $tsid ];then
    echo "Please run this shell with user: taishan !"
    exit
fi
}

start(){
check_user_is_taishan

#mkdir
mkdir -p ${TS_HOST}/{ipcs,logs,data/{win_data,seal_data,tfe_data,tidx_data,game_data,upload_data,pub_data,snapshot_data}}
touch ${TS_HOST}/ipcs/sem.key
touch ${TS_HOST}/ipcs/shm.key
touch ${TS_HOST}/ipcs/msg.key

rm -rf /dev/shm/ts_game
mkdir /dev/shm/ts_game

mkdir ${TS_HOST}/data/game_data/game_SSC
mkdir ${TS_HOST}/data/game_data/game_SSC/draw
ln -sf ${TS_HOST}/task/gl_draw ${TS_HOST}/task/gl_draw_SSC

mkdir ${TS_HOST}/data/game_data/game_KOC7LX
mkdir ${TS_HOST}/data/game_data/game_KOC7LX/draw
ln -sf ${TS_HOST}/task/gl_draw ${TS_HOST}/task/gl_draw_KOC7LX

mkdir ${TS_HOST}/data/game_data/game_KOCTTY
mkdir ${TS_HOST}/data/game_data/game_KOCTTY/draw
ln -sf ${TS_HOST}/task/gl_draw ${TS_HOST}/task/gl_draw_KOCTTY

mkdir ${TS_HOST}/data/game_data/game_KOCK3
mkdir ${TS_HOST}/data/game_data/game_KOCK3/draw
ln -sf ${TS_HOST}/task/gl_draw ${TS_HOST}/task/gl_draw_KOCK3

mkdir ${TS_HOST}/data/game_data/game_K11X5
mkdir ${TS_HOST}/data/game_data/game_K11X5/draw
ln -sf ${TS_HOST}/task/gl_draw ${TS_HOST}/task/gl_draw_K11X5

mkdir ${TS_HOST}/data/game_data/game_TEMA
mkdir ${TS_HOST}/data/game_data/game_TEMA/draw
ln -sf ${TS_HOST}/task/gl_draw ${TS_HOST}/task/gl_draw_TEMA

mkdir ${TS_HOST}/data/game_data/game_FBS
mkdir ${TS_HOST}/data/game_data/game_FBS/draw

clear
echo -e "$(date): Welcome to ${green}TaiShan${NC} system."  | tee -a ${LOG_FILE}

#person=$(w| grep  $(lsof -p $$| grep 0u|awk '{print $8}'| awk -F'/' '{print $3"/"$4}'))
#echo "who: [${person}]" >> ${LOG_FILE}
check_sessionDate
(
flock -x -w 0 200
if [ $? -eq 1 ] ; then
    echo "$(date) -> [$0]: Unable to get the lock for ${LOCK_FILE}. MAYBE SYSTEM IS RUNNING..." | tee -a ${LOG_FILE}
else
    #Do something here under the protect of file lock
    old_pid=$(cat ${PID_FILE} 2>/dev/null)
    if [ "X${old_pid}" != "X" ] ; then
        tstop=$(P ${old_pid}| awk '{print $4}')
        if [ "X${tstop}" != "X" ] ; then
            echo "TaiShan has started already!"
            exit 0
        fi
    fi


    echo "$(date): TaiShan starting..." >>${LOG_FILE}
    cd ${TS_HOST}/task
    ${TS_HOST}/task/tstop start
    sleep 2
    pid=$(P tstop|awk '{print $4}')
    echo ${pid} >${PID_FILE}

    cd ${TS_HOST}/sbin/tsview_web
    nohup python ts_main.py >${TS_HOST}/logs/tsview_web.log 2>&1 &
    pid=$(P ts_main.py|awk '{print $4}')
    if [ "X${pid}" == "X" ] ; then
        echo "tsview_web start failure!"
    fi
fi
) 200>${LOCK_FILE} &
}

stop(){
check_user_is_taishan
echo "$(date): try to stop TaiShan system." >> ${LOG_FILE}
#person=$(w| grep  $(lsof -p $$| grep 0u|awk '{print $8}'| awk -F'/' '{print $3"/"$4}'))
#echo "who: [${person}]" >> ${LOG_FILE}

echo "First, think carefully before you type!"
echo -e "Are you sure to kill TaiShan system? ${red}[Y]/[N]/[F]${NC}"

printf "${cyan}>> ${NC}"
read answer

if [ "X${answer}" == "XY" ] ; then
    echo "TaiShan system safe exit begin ..."
    killall -q tsview
    cd ${TS_HOST}/task
    ${TS_HOST}/task/tstop stop
    sleep 2
    rm -f ${LOCK_FILE}
    exit 0
fi

if [ "X${answer}" == "XN" ] ; then
    exit 0
fi

if [ "X${answer}" != "XF" ] ; then
    echo -e "Unknown answer [${cyan}${answer}${NC}], exit...."
    exit 0
fi

tasks='tstop
        bqueuesd
        ncpc_task
		ncpc_ap_pay
        report
        tfe_adder
        tfe_flush
        tfe_reply
        tfe_updater
        tfe_scan
        tfe_updater_db
        tfe_updater_db2
        gl_driver
		gl_fbs_driver
        gl_draw_SSQ
        gl_draw_3D
        gl_draw_7LC
        gl_draw_SSC
        gl_draw_KLC
        gl_draw_KOCKENO
        gl_draw_KOC7LX
        gl_draw_KOCC30S6
        gl_draw_KOCTTY
        gl_draw_KOCK2
        gl_draw_KOCK3
        gl_draw_K11X5
		gl_draw_TEMA
        gl_draw_FBS
        rng_server
        tsview
        ts_main.py'

echo -e  "${red}Begin kill tasks...${NC}"
for task in ${tasks} ; do
    pid=`pidof ${task}`
    if [ ${#pid} != 0 ] ; then
        echo -e  "${cyan}kill ${task}[${pid}]${NC}"
        kill -9 ${pid}
    fi
done

# waiting task to exit...
exit_flag='0'

while [ ${exit_flag} = '0' ] ; do
    exit_flag='1'
    for task in ${tasks} ; do
       pid=`pidof ${task}`
       if [ ${#pid} != 0 ] ; then
          exit_flag='0'
       fi
    done
    usleep 1
done

echo -e "$(date): ${red}All tasks are killed${NC}"

echo -e "${red}Begin delete ipc...${NC}"

echo -e "${cyan}"
myname=`whoami`;export $myname

echo -e "${red}--- delete shared memory ---${NC}"
ipcs -m|awk -v a=$myname '
{
        if($3 == a)
        {
                print $0;
                str = sprintf("ipcrm -m %s", $2);
                system(str);
        }
}'

echo -e "${red}--- delete semaphore ---${NC}"
ipcs -s|awk -v a=$myname '
{
        if($3 == a)
        {
                print $0;
                str = sprintf("ipcrm -s %s", $2);
                system(str);
        }
}'

echo -e "${red}--- delete message queues ---${NC}"
ipcs -q|awk -v a=$myname '
{
        if($3 == a)
        {
                print $0;
                str = sprintf("ipcrm -q %s", $2);
                system(str);
        }
}'

echo -e "$(date): ${red}All ipc are deleted${NC}"

echo -e "$(date): TaiShan stopped." | tee -a ${LOG_FILE}

rm -fr ${PID_FILE}

rm -f ${LOCK_FILE}

}

parmStr=`echo $1|tr a-z A-Z`

if [ "$parmStr" = "VIEW" ]
then
view
fi

if [ "$parmStr" = "START" ]
then
start
fi

if [ "$parmStr" = "STOP" ]
then
stop
fi

