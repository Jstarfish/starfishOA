package cls.pilottery.dao;

import cls.pilottery.model.RolePrivilegeKey;

public interface RolePrivilegeMapper {
    int deleteByPrimaryKey(RolePrivilegeKey key);

    int insert(RolePrivilegeKey record);

    int insertSelective(RolePrivilegeKey record);
}