package cls.pilottery.dao;

import cls.pilottery.model.Agencys;

public interface AgencysMapper {
    int deleteByPrimaryKey(String agencyCode);

    int insert(Agencys record);

    int insertSelective(Agencys record);

    Agencys selectByPrimaryKey(String agencyCode);

    int updateByPrimaryKeySelective(Agencys record);

    int updateByPrimaryKey(Agencys record);
}