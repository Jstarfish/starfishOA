package cls.pilottery.dao;

import cls.pilottery.model.WhCheckPointDetail;
import cls.pilottery.model.WhCheckPointDetailKey;

public interface WhCheckPointDetailMapper {
    int deleteByPrimaryKey(WhCheckPointDetailKey key);

    int insert(WhCheckPointDetail record);

    int insertSelective(WhCheckPointDetail record);

    WhCheckPointDetail selectByPrimaryKey(WhCheckPointDetailKey key);

    int updateByPrimaryKeySelective(WhCheckPointDetail record);

    int updateByPrimaryKey(WhCheckPointDetail record);
}