package cls.pilottery.dao;

import cls.pilottery.model.GamePlans;

public interface GamePlansMapper {
    int deleteByPrimaryKey(String planCode);

    int insert(GamePlans record);

    int insertSelective(GamePlans record);

    GamePlans selectByPrimaryKey(String planCode);

    int updateByPrimaryKeySelective(GamePlans record);

    int updateByPrimaryKey(GamePlans record);
}