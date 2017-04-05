package cls.pilottery.dao;

import cls.pilottery.model.ItemCheck;

public interface ItemCheckMapper {
    int deleteByPrimaryKey(String checkNo);

    int insert(ItemCheck record);

    int insertSelective(ItemCheck record);

    ItemCheck selectByPrimaryKey(String checkNo);

    int updateByPrimaryKeySelective(ItemCheck record);

    int updateByPrimaryKey(ItemCheck record);
}