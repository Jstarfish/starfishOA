package cls.pilottery.dao;

import cls.pilottery.model.RoleAdminKey;

public interface RoleAdminMapper {
    int deleteByPrimaryKey(RoleAdminKey key);

    int insert(RoleAdminKey record);

    int insertSelective(RoleAdminKey record);
}