package cls.pilottery.dao;

import cls.pilottery.model.GameBatchImportReward;
import cls.pilottery.model.GameBatchImportRewardKey;

public interface GameBatchImportRewardMapper {
    int deleteByPrimaryKey(GameBatchImportRewardKey key);

    int insert(GameBatchImportReward record);

    int insertSelective(GameBatchImportReward record);

    GameBatchImportReward selectByPrimaryKey(GameBatchImportRewardKey key);

    int updateByPrimaryKeySelective(GameBatchImportReward record);

    int updateByPrimaryKey(GameBatchImportReward record);
}