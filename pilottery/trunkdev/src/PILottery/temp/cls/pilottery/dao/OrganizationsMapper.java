package cls.pilottery.dao;

import cls.pilottery.model.Organizations;

public interface OrganizationsMapper {
    int deleteByPrimaryKey(String orgCode);

    int insert(Organizations record);

    int insertSelective(Organizations record);

    Organizations selectByPrimaryKey(String orgCode);

    int updateByPrimaryKeySelective(Organizations record);

    int updateByPrimaryKey(Organizations record);
}