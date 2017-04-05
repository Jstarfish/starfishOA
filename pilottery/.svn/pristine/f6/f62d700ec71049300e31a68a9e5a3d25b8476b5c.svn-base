
TSBACKPATH=/backupdata/host_data_backup
date
rsync -avzP tsback@172.16.35.3::tslog $TSBACKPATH/logs --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncLog -o $?
rsync -avzP tsback@172.16.35.3::tsdata $TSBACKPATH/data --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncData -o $?
rsync -avzP tsback@172.16.35.3::ftpup $TSBACKPATH/ftpup --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncFtpUpData -o $?
rsync -avzP tsback@172.16.35.3::ftpdown $TSBACKPATH/ftpdown --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncFtpDownData -o $?


rsync -avzP tsback@172.16.32.1::ncplog /backupdata/ncp_webncp_log/ncp1 --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncNcpLog1 -o $?
rsync -avzP tsback@172.16.32.1::webncp /backupdata/ncp_webncp_log/webncp1 --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncWebNcpLog1 -o $?

rsync -avzP tsback@172.16.32.2::ncplog /backupdata/ncp_webncp_log/ncp2 --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncNcpLog2 -o $?
rsync -avzP tsback@172.16.32.2::webncp /backupdata/ncp_webncp_log/webncp2 --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncWebNcpLog2 -o $?

rsync -avzP tsback@172.16.32.3::ncplog /backupdata/ncp_webncp_log/ncp3 --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncNcpLog3 -o $?
rsync -avzP tsback@172.16.32.3::webncp /backupdata/ncp_webncp_log/webncp3 --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncWebNcpLog3 -o $?

rsync -avzP tsback@172.16.32.4::ncplog /backupdata/ncp_webncp_log/ncp4 --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncNcpLog4 -o $?
rsync -avzP tsback@172.16.32.4::webncp /backupdata/ncp_webncp_log/webncp4 --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncWebNcpLog4 -o $?

rsync -avzP tsback@172.16.32.5::ncplog /backupdata/ncp_webncp_log/ncp5 --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncNcpLog5 -o $?
rsync -avzP tsback@172.16.32.5::webncp /backupdata/ncp_webncp_log/webncp5 --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncWebNcpLog5 -o $?

rsync -avzP tsback@172.16.32.6::ncplog /backupdata/ncp_webncp_log/ncp6 --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncNcpLog6 -o $?
rsync -avzP tsback@172.16.32.6::webncp /backupdata/ncp_webncp_log/webncp6 --password-file=/backupdata/sbin/rsyncd.passwd
zabbix_sender -c "/etc/zabbix/zabbix_agentd.conf"  -k host.rsyncWebNcpLog6 -o $?

echo "host data and logs rsync over."
