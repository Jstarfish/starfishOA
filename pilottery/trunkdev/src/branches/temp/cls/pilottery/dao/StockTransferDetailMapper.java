package cls.pilottery.dao;

import cls.pilottery.model.StockTransferDetail;
import cls.pilottery.model.StockTransferDetailKey;

public interface StockTransferDetailMapper {
    int deleteByPrimaryKey(StockTransferDetailKey key);

    int insert(StockTransferDetail record);

    int insertSelective(StockTransferDetail record);

    StockTransferDetail selectByPrimaryKey(StockTransferDetailKey key);

    int updateByPrimaryKeySelective(StockTransferDetail record);

    int updateByPrimaryKey(StockTransferDetail record);
}