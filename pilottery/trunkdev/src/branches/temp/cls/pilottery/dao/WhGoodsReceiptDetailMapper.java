package cls.pilottery.dao;

import cls.pilottery.model.WhGoodsReceiptDetail;
import cls.pilottery.model.WhGoodsReceiptDetailKey;

public interface WhGoodsReceiptDetailMapper {
    int deleteByPrimaryKey(WhGoodsReceiptDetailKey key);

    int insert(WhGoodsReceiptDetail record);

    int insertSelective(WhGoodsReceiptDetail record);

    WhGoodsReceiptDetail selectByPrimaryKey(WhGoodsReceiptDetailKey key);

    int updateByPrimaryKeySelective(WhGoodsReceiptDetail record);

    int updateByPrimaryKey(WhGoodsReceiptDetail record);
}