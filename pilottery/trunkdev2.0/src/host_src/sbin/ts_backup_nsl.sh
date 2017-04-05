
TSBACKPATH=/backupdata/nsl/host_data_backup
PASSWDPATH=/backupdata/nsl

myecho () {
	if [ $1 -eq 0 ]; then
		echo "rsync $2 success"
	else
		echo "rsync $2 failure"
	fi
}

echo "----------------------------------------- host data and logs rsync start.------------------------------------------"
date
rsync -avzP tsback@172.16.34.101::tslog ${TSBACKPATH}/logs --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "host log"

rsync -avzP tsback@172.16.34.101::tsdata ${TSBACKPATH}/data --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "host data"

rsync -avzP tsback@172.16.34.101::ftpup ${TSBACKPATH}/ftpup --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "ftp upload"

rsync -avzP tsback@172.16.34.101::ftpdown ${TSBACKPATH}/ftpdown --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "ftp down"



rsync -avzP tsback@172.16.32.4::ncplog ${PASSWDPATH}/ncp_webncp_log/ncp1 --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "ncp1: 32.4 log"

rsync -avzP tsback@172.16.32.4::webncp ${PASSWDPATH}/ncp_webncp_log/webncp1 --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "webncp1: 32.4 log"

rsync -avzP tsback@172.16.32.5::ncplog ${PASSWDPATH}/ncp_webncp_log/ncp2 --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "ncp2: 32.5 log"

rsync -avzP tsback@172.16.32.5::webncp ${PASSWDPATH}/ncp_webncp_log/webncp2 --password-file=${PASSWDPATH}/sbin/rsyncd.passwd
myecho $? "webncp2: 32.5 log"

date
echo "------------------------------------------ host data and logs rsync over.--------------------------------------------"
