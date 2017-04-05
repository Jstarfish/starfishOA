package cls.pilottery.dao;

import cls.pilottery.model.ItemQuantity;
import cls.pilottery.model.ItemQuantityKey;

public interface ItemQuantityMapper {
    int deleteByPrimaryKey(ItemQuantityKey key);

    int insert(ItemQuantity record);

    int insertSelective(ItemQuantity record);

    ItemQuantity selectByPrimaryKey(ItemQuantityKey key);

    int updateByPrimaryKeySelective(ItemQuantity record);

    int updateByPrimaryKey(ItemQuantity record);
}