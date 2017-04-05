#1、关闭主机服务（TAISHAN）
# 使用taishan用户关闭主机系统
# su - taishan << EOF
# /ts_host/sbin/ts_servctl.sh force_exit
# EOF

# 之后的操作，使用root用户进行

#2、卸载挂载点（ROOT）
umount /ts_host/data/win_data
umount /ts_host/data/seal_data
umount /ts_host/logs
umount /ts_host

#3、关闭NFS服务（ROOT）
service nfs stop

#4、卸载NFS文件系统
umount /nfs_export

#5、删除虚拟IP（ROOT）
#ifconfig bond0:1 del 172.16.35.3
ip addr del 172.16.35.3 dev bond0
