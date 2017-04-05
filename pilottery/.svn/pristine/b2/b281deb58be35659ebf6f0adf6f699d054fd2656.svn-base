
TSBACKPATH=/backupdata/kpw/host_data_backup
PASSWDPATH=/backupdata/kpw

myecho () {
	if [ $1 -eq 0 ]; then
		echo "rsync $2 success"
	else
		echo "rsync $2 failure"
	fi
}
echo "--------------------------------------- host data and logs rsync start ----------------------------------------------------"
date
rsync -avzP tsback@172.16.34.8::tslog ${TSBACKPATH}/logs --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "host log"

rsync -avzP tsback@172.16.34.8::tsdata ${TSBACKPATH}/data --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "host data"

rsync -avzP tsback@172.16.34.8::ftpup ${TSBACKPATH}/ftpup --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "ftp upload"

rsync -avzP tsback@172.16.34.8::ftpdown ${TSBACKPATH}/ftpdown --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "ftp down"



rsync -avzP tsback@172.16.32.1::ncplog ${PASSWDPATH}/ncp_webncp_log/ncp1 --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "ncp1: 32.1 log"

rsync -avzP tsback@172.16.32.1::webncp ${PASSWDPATH}/ncp_webncp_log/webncp1 --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "webncp1: 32.1 log"

rsync -avzP tsback@172.16.32.2::ncplog ${PASSWDPATH}/ncp_webncp_log/ncp2 --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "ncp2: 32.2 log"

rsync -avzP tsback@172.16.32.2::webncp ${PASSWDPATH}/ncp_webncp_log/webncp2 --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "webncp2: 32.2 log"

rsync -avzP tsback@172.16.32.3::ncplog ${PASSWDPATH}/ncp_webncp_log/ncp3 --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "ncp3: 32.3 log"

rsync -avzP tsback@172.16.32.3::webncp ${PASSWDPATH}/ncp_webncp_log/webncp3 --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "webncp3: 32.3 log"



date
echo "---------------------------------------- host data and logs rsync over.---------------------------------------------------------"
