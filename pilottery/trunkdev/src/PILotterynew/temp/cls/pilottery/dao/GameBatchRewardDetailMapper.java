package cls.pilottery.dao;

import cls.pilottery.model.GameBatchRewardDetail;
import cls.pilottery.model.GameBatchRewardDetailKey;

public interface GameBatchRewardDetailMapper {
    int deleteByPrimaryKey(GameBatchRewardDetailKey key);

    int insert(GameBatchRewardDetail record);

    int insertSelective(GameBatchRewardDetail record);

    GameBatchRewardDetail selectByPrimaryKey(GameBatchRewardDetailKey key);

    int updateByPrimaryKeySelective(GameBatchRewardDetail record);

    int updateByPrimaryKey(GameBatchRewardDetail record);
}