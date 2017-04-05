package cls.pilottery.dao;

import cls.pilottery.model.DeliveryOrderDetail;
import cls.pilottery.model.DeliveryOrderDetailKey;

public interface DeliveryOrderDetailMapper {
    int deleteByPrimaryKey(DeliveryOrderDetailKey key);

    int insert(DeliveryOrderDetail record);

    int insertSelective(DeliveryOrderDetail record);

    DeliveryOrderDetail selectByPrimaryKey(DeliveryOrderDetailKey key);

    int updateByPrimaryKeySelective(DeliveryOrderDetail record);

    int updateByPrimaryKey(DeliveryOrderDetail record);
}