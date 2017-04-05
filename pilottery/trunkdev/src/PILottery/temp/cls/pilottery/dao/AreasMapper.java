package cls.pilottery.dao;

import cls.pilottery.model.Areas;

public interface AreasMapper {
    int deleteByPrimaryKey(String areaCode);

    int insert(Areas record);

    int insertSelective(Areas record);

    Areas selectByPrimaryKey(String areaCode);

    int updateByPrimaryKeySelective(Areas record);

    int updateByPrimaryKey(Areas record);
}