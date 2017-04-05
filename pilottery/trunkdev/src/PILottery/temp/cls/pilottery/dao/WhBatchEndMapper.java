package cls.pilottery.dao;

import cls.pilottery.model.WhBatchEnd;

public interface WhBatchEndMapper {
    int deleteByPrimaryKey(String beNo);

    int insert(WhBatchEnd record);

    int insertSelective(WhBatchEnd record);

    WhBatchEnd selectByPrimaryKey(String beNo);

    int updateByPrimaryKeySelective(WhBatchEnd record);

    int updateByPrimaryKey(WhBatchEnd record);
}