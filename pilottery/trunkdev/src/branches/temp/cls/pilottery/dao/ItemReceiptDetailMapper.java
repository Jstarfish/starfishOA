package cls.pilottery.dao;

import cls.pilottery.model.ItemReceiptDetail;
import cls.pilottery.model.ItemReceiptDetailKey;

public interface ItemReceiptDetailMapper {
    int deleteByPrimaryKey(ItemReceiptDetailKey key);

    int insert(ItemReceiptDetail record);

    int insertSelective(ItemReceiptDetail record);

    ItemReceiptDetail selectByPrimaryKey(ItemReceiptDetailKey key);

    int updateByPrimaryKeySelective(ItemReceiptDetail record);

    int updateByPrimaryKey(ItemReceiptDetail record);
}