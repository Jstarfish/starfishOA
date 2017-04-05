package cls.pilottery.dao;

import cls.pilottery.model.ItemReceipt;

public interface ItemReceiptMapper {
    int deleteByPrimaryKey(String irNo);

    int insert(ItemReceipt record);

    int insertSelective(ItemReceipt record);

    ItemReceipt selectByPrimaryKey(String irNo);

    int updateByPrimaryKeySelective(ItemReceipt record);

    int updateByPrimaryKey(ItemReceipt record);
}