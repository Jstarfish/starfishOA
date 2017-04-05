#########################################################################################
##
##  log_dump.sh  date  log_level
##
## example:
##  log_dump.sh  20140922 error
##
##  log_dump.sh  2014/08/15 warn
##
##  log_dump.sh  2014-09-11 ERROR
##
## return:
##    no filename be echo if find nothing with "log_level",include tstop.log
########################################################################################

LOG_DATE=`date -d "$1" "+%F"`
if [ -z "$LOG_DATE" ];then
    echo "input date error!"
    exit
fi

KEY_WORK=`echo $2|tr "[:lower:]" "[:upper:]"`

if [ $KEY_WORK != "ERROR" ] && [ $KEY_WORK != "WARN" ]; then
    echo "input log_level: error / warn !"
    exit
fi

find /ts_host/logs/$LOG_DATE -type f -name "*.log" -exec grep -n -w "$KEY_WORK" {} \; -print

grep -n "$LOG_DATE" /ts_host/logs/tstop.log | grep -w "$KEY_WORK"
if [ $? = 0 ]; then
    echo "/ts_host/logs/tstop.log"
fi

