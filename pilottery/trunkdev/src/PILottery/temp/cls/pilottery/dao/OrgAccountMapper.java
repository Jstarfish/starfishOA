package cls.pilottery.dao;

import cls.pilottery.model.OrgAccount;

public interface OrgAccountMapper {
    int deleteByPrimaryKey(String accNo);

    int insert(OrgAccount record);

    int insertSelective(OrgAccount record);

    OrgAccount selectByPrimaryKey(String accNo);

    int updateByPrimaryKeySelective(OrgAccount record);

    int updateByPrimaryKey(OrgAccount record);
}