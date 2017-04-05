package cls.pilottery.dao;

import cls.pilottery.model.AgencyAccount;

public interface AgencyAccountMapper {
    int deleteByPrimaryKey(String accNo);

    int insert(AgencyAccount record);

    int insertSelective(AgencyAccount record);

    AgencyAccount selectByPrimaryKey(String accNo);

    int updateByPrimaryKeySelective(AgencyAccount record);

    int updateByPrimaryKey(AgencyAccount record);
}