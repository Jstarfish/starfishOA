

TSBACKPATH=/backupdata/nsl/host_data_backup
NCPLOGSYNCPATH=/backupdata/nsl/ncp_webncp_log
TAR_PATH_HOST=/backupdata/nsl/tarback/host
TAR_PATH_NCP=/backupdata/nsl/tarback/ncp

yesdate=`date -d yesterday "+%F"`
yesyymmdd=`date -d -2day +"%Y/%m/%d"`
todate=`date "+%F"`
timestamp=`date +%s`

LOG_DELETE_DAYS=100
TF_DELETE_DAYS=10
DEALDATA_DELETE_DAYS=100

myecho () {
	if [ $1 -eq 0 ]; then
		echo "tarbzip $2 success"
	else
		echo "tarbzip $2 failure"
	fi
}
echo "-----------------------------------------tar and bzip start.----------------------------------------------"
date

######################### host logs ##############################################
if [ ! -f ${TAR_PATH_HOST}/log_${yesdate}.tar.bz2 ];then
    tar cvf ${TAR_PATH_HOST}/log_${yesdate}.tar ${TSBACKPATH}/logs/${yesdate} &&
	tar rf ${TAR_PATH_HOST}/log_${yesdate}.tar ${TSBACKPATH}/logs/tstop.log &&
	bzip2 -9 ${TAR_PATH_HOST}/log_${yesdate}.tar
	myecho $? "host log"

fi

############################# upload_data ##########################################
if [ ! -f ${TAR_PATH_HOST}/upload_data_${yesdate}.tar.bz2 ];then
    tar -jcvf ${TAR_PATH_HOST}/upload_data_${yesdate}.tar.bz2 ${TSBACKPATH}/data/upload_data/*_${yesdate}.log
	myecho $? "upload data"
fi

############################### tfe_data ##################################################
tar -jcvf ${TAR_PATH_HOST}/tfe_data_${todate}_${timestamp}.tar.bz2 ${TSBACKPATH}/data/tfe_data
myecho $? "tfe data"


############################### seal_data ###################################################
tar -N "$yesyymmdd" -jcvf ${TAR_PATH_HOST}/seal_data_${todate}_${timestamp}.tar.bz2 ${TSBACKPATH}/data/seal_data/game*
myecho $? "seal data"


################################ win_data ###################################################
tar -N "$yesyymmdd" -jcvf ${TAR_PATH_HOST}/win_data_${todate}_${timestamp}.tar.bz2 ${TSBACKPATH}/data/win_data/game*
myecho $? "win data"


################################# game_data ##################################################
tar -jcvf ${TAR_PATH_HOST}/game_data_${todate}_${timestamp}.tar.bz2 ${TSBACKPATH}/data/game_data
myecho $? "game data"


############################# ftp up date ##########################################
if [ ! -f ${TAR_PATH_HOST}/ftpup_data_${yesdate}.tar.bz2 ];then
    tar -jcvf ${TAR_PATH_HOST}/ftpup_data_${yesdate}.tar.bz2 ${TSBACKPATH}/ftpup/*_${yesdate}.log
	myecho $? "ftp upload"
fi

################################# ncp log ##################################################
for k in $( seq 1 2 )
do
    tar -jcvf ${TAR_PATH_NCP}/ncp${k}_${yesdate}_${timestamp}.tar.bz2 ${NCPLOGSYNCPATH}/ncp${k}/${yesdate}
	myecho $? "ncp log"
done


###############################  delet outtime files #########################################
find $TAR_PATH_HOST -type f -name "log_*.bz2" -ctime +$LOG_DELETE_DAYS -exec rm -f {} \;
find $TAR_PATH_HOST -type f -name "upload_data_*.bz2" -ctime +$LOG_DELETE_DAYS -exec rm -f {} \;
find $TAR_PATH_HOST -type f -name "tfe_data_*.bz2" -ctime +$TF_DELETE_DAYS -exec rm -f {} \;
find $TAR_PATH_HOST -type f -name "seal_data_*.bz2" -ctime +$DEALDATA_DELETE_DAYS -exec rm -f {} \;
find $TAR_PATH_HOST -type f -name "win_data_*.bz2" -ctime +$DEALDATA_DELETE_DAYS -exec rm -f {} \;
find $TAR_PATH_HOST -type f -name "game_data_*.bz2" -ctime +$DEALDATA_DELETE_DAYS -exec rm -f {} \;
find $TAR_PATH_HOST -type f -name "ftpup_data_*.bz2" -ctime +$LOG_DELETE_DAYS -exec rm -f {} \;

find $TAR_PATH_NCP -type f -name "ncp*.bz2" -ctime +$LOG_DELETE_DAYS -exec rm -f {} \;

date
echo "--------------------------------------------tar and bzip2 over.----------------------------------------------------"
