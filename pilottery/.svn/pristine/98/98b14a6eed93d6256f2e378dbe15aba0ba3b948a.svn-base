#!/bin/sh

#----------------------------------------------------------------
# Startup script for RNG Client Program
#----------------------------------------------------------------

#. /etc/rc.d/init.d/functions
. /ts_rng/sbin/functions

# configuration variables
rng_client="/ts_rng/task/rngclient"
prog="rngsvrctl.sh"
log_dir="/ts_rng/logs"
ipc_dir="/ts_rng/ipcs"
pidfile="${log_dir}/rng_client.pid"
lockfile="${log_dir}/lock"

retval=0

get_rngserver_pid()
{
    local pid
    local pid_tmp
    pid=$(cat "${pidfile}" 2>/dev/null)
    pid_tmp=$(ps -lef|grep ${rng_client}|grep -v "grep ${rng_client}"|awk '{print  $4}' 2>/dev/null)
    
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
    mkdir -p "${ipc_dir}"
    if ! [ -d "${ipc_dir}" ] ; then
        printf 'No such directory: %s\n' "${ipc_dir}"
        exit 1
    fi
    touch ${ipc_dir}"/shm.key"

    mkdir -p "${log_dir}"
    if ! [ -d "${log_dir}" ] ; then
        printf 'No such directory: %s\n' "${log_dir}"
        exit 1
    fi
    
    if [ -f "${pidfile}" ] ; then
        local pid_t
        pid_t=$(get_rngserver_pid)
        if [ "X${pid_t}" != "X" ] ; then
            printf "Starting ${rng_client}:  ${rng_client} has started already.\n"
            exit 0
        else
            rm -fr ${pidfile}
        fi
    fi

    if ! [ -e ${rng_client} ] ; then  
        printf "${rng_client} does not existed.\n" 
        exit 1
    fi 

    cd $(dirname ${rng_client})
    echo -n $"Starting ${rng_client}: "
    daemon --pidfile=${pidfile} ${rng_client} --daemonize --pidfile ${pidfile}
    retval=$?
    echo
    [ ${retval} = 0 ] && touch ${lockfile}
    return ${retval}
}

stop()
{
    local pid_t
    pid_t=$(get_rngserver_pid)
    if [ "X${pid_t}" == "X" ] ; then
        printf "Stopping ${rng_client}:  ${rng_client} has not started already.\n"
        return
    fi
        
    echo -n $"Stopping ${rng_client}: "
    
    killproc -p ${pidfile} -d 1 ${rng_client}
    retval=$?
    echo
    [ $retval = 0 ] && rm -f ${lockfile} ${pidfile}
}

# See how we were called.
case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  status)
        status -p ${pidfile} ${rng_client}
        retval=$?
        ;;
  restart)
        stop
        start
        ;;

  *)
        echo $"Usage: ${prog} {start|stop|restart|status|help}"
        exit 1
esac

exit $retval




