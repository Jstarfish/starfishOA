package cls.pilottery.dao;

import cls.pilottery.model.OrganizationAreaKey;

public interface OrganizationAreaMapper {
    int deleteByPrimaryKey(OrganizationAreaKey key);

    int insert(OrganizationAreaKey record);

    int insertSelective(OrganizationAreaKey record);
}