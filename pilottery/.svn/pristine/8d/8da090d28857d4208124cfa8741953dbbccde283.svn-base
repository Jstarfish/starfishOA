##############################
##
## change MV2PATH to path of back
##
## change DAY_BEFORE to days need to mv 
##
###############################
DAY_BEFORE=10
TS_PATH=/ts_host/data
MV2PATH=/ts_host/cpp/echo2/back

NOT_FIND1=/ts_host/data/tfe_data
NOT_FIND2=/ts_host/data/snapshot_data

oldPath="zzzxxxzzz"

mkdir -p "$MV2PATH"
if [ $? -ne 0 ];then
    echo "mkdir $MV2PATH error, shell exit!"
    exit
fi

for tsDataFile in `find $TS_PATH \( -path $NOT_FIND1 -o -path $NOT_FIND2 \) -prune -o -atime +$DAY_BEFORE`
do
    tmpPath=`dirname $tsDataFile`
    newPath=`echo $MV2PATH$tmpPath`
    if [ "$newPath"x != "$oldPath"x ]; then
        mkdir -p "$newPath"
        if [ $? -ne 0 ];then
            echo "mkdir $tmpPath error, shell exit!"
            exit
        fi
        oldPath=$newPath
        cp $tsDataFile $newPath
        if [ $? -ne 0 ];then
            echo "cp $tsDataFile to  $newPath   error, shell exit!"
            exit
        fi
        rm -f $tsDataFile
    fi
done
overTime=`date`
echo "[$overTime ] mv ts data over!"
