package cls.pilottery.dao;

import cls.pilottery.model.WhCheckPoint;

public interface WhCheckPointMapper {
    int deleteByPrimaryKey(String cpNo);

    int insert(WhCheckPoint record);

    int insertSelective(WhCheckPoint record);

    WhCheckPoint selectByPrimaryKey(String cpNo);

    int updateByPrimaryKeySelective(WhCheckPoint record);

    int updateByPrimaryKey(WhCheckPoint record);
}