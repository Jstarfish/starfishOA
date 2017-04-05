#检测本机ip 是否包含bind IP
#包含则退出
ip a | grep "172.16.35.3"
ret=$?
if [ $ret -eq 0 ]
then
   echo "this machine has bind address 172.16.35.3 !"
   exit
fi

#检测是否可ping通预bing IP
ping -w 1 -c 1 172.16.35.3 >/dev/null
ret=$?
if [ $ret -eq 0 ]
then 
   echo "There is IP 172.16.35.3 in somewhere!"
   exit
fi

#1、设置虚拟IP（ROOT）
ifconfig bond0:1 172.16.35.3

#2、挂载NFS文件系统
mount -t ext4 /dev/mapper/nfsdatap1 /nfs_export

#3、启动NFS服务（ROOT）
service nfs start

#4、挂载主机相关目录（ROOT）
mount -t ext4 /dev/mapper/tfedatap1 /ts_host
mount -t ext4 /dev/mapper/logdatap1 /ts_host/logs
mount 172.16.35.3:/nfs_export/seal_data /ts_host/data/seal_data
mount 172.16.35.3:/nfs_export/win_data /ts_host/data/win_data


/usr/bin/rsync --daemon

#5、启动主机服务（TAISHAN）
# 切换到taishan用户，启动主机系统
# su - taishan << EOF
# /ts_host/sbin/ts_servctl.sh start
# EOF

