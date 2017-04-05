package cls.pilottery.dao;

import cls.pilottery.model.AgencyDelete;

public interface AgencyDeleteMapper {
    int deleteByPrimaryKey(String deleteNo);

    int insert(AgencyDelete record);

    int insertSelective(AgencyDelete record);

    AgencyDelete selectByPrimaryKey(String deleteNo);

    int updateByPrimaryKeySelective(AgencyDelete record);

    int updateByPrimaryKey(AgencyDelete record);
}