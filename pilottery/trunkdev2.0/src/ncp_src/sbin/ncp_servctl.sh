#!/bin/sh

#----------------------------------------------------------------
# Startup script for the server of NCP
#----------------------------------------------------------------

#. /etc/rc.d/init.d/functions
. /ts_ncp/sbin/functions

# configuration variables
ncp_server="/ts_ncp/task/ncp_server"
prog="ncp_servctl.sh"
log_dir="/ts_ncp/logs"
pidfile="${log_dir}/ncp_server.pid"
lockfile="${log_dir}/lock"

retval=0

get_ncp_server_pid()
{
    local pid
    local pid_tmp
    pid=$(cat "${pidfile}" 2>/dev/null)
    pid_tmp=$(ps -lef|grep ${ncp_server}|grep -v "grep ${ncp_server}"|awk '{print  $4}' 2>/dev/null)

    if [ "X${pid}" == "X" ] ; then
        echo ""
        
        return
    fi

    if [ "${pid}" != "${pid_tmp}" ] ; then
        echo ""
        
        return
    fi

    echo "${pid_tmp}"
}

# start the server
start()
{
    mkdir -p "${log_dir}"
    if ! [ -d "${log_dir}" ] ; then
        printf 'No such directory: %s\n' "${log_dir}"
        exit 1
    fi

    if [ -f "${pidfile}" ] ; then
        local pid_t
        pid_t=$(get_ncp_server_pid)
        if [ "X${pid_t}" != "X" ] ; then
            printf "Starting ${ncp_server}:  ${ncp_server} has started already.\n"
            exit 0
        else
            rm -fr ${pidfile}
        fi
    fi

    if ! [ -e ${ncp_server} ] ; then  
        printf "${ncp_server} does not exist.\n" 
        exit 1
    fi 

    cd $(dirname ${ncp_server})
    echo -n $"Starting ${ncp_server}: "
    daemon --pidfile=${pidfile} ${ncp_server} --daemonize --pidfile ${pidfile}
    retval=$?
    echo
    [ ${retval} = 0 ] && touch ${lockfile}
    return ${retval}
}

stop()
{
    local pid_t
    pid_t=$(get_ncp_server_pid)
    if [ "X${pid_t}" == "X" ] ; then
        printf "Stopping ${ncp_server}:  ${ncp_server} has not started already.\n"
        return
    fi
        
    echo -n $"Stopping ${ncp_server}: "

    killproc -p ${pidfile} -d 1 ${ncp_server}
    retval=$?
    echo
    [ $retval = 0 ] && rm -f ${lockfile} ${pidfile}
}

# see how we were called.
case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  status)
        status -p ${pidfile} ${ncp_server}
        retval=$?
        ;;
  restart)
        stop
        start
        ;;
  *)
        echo $"Usage: ${prog} {start|stop|restart|status}"
        exit 1
esac

exit $retval




