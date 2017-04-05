package cls.pilottery.dao;

import cls.pilottery.model.WhCheckPointDetailBe;
import cls.pilottery.model.WhCheckPointDetailBeKey;

public interface WhCheckPointDetailBeMapper {
    int deleteByPrimaryKey(WhCheckPointDetailBeKey key);

    int insert(WhCheckPointDetailBe record);

    int insertSelective(WhCheckPointDetailBe record);

    WhCheckPointDetailBe selectByPrimaryKey(WhCheckPointDetailBeKey key);

    int updateByPrimaryKeySelective(WhCheckPointDetailBe record);

    int updateByPrimaryKey(WhCheckPointDetailBe record);
}