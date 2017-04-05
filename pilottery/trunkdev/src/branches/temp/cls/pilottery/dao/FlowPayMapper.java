package cls.pilottery.dao;

import cls.pilottery.model.FlowPay;

public interface FlowPayMapper {
    int deleteByPrimaryKey(String payFlow);

    int insert(FlowPay record);

    int insertSelective(FlowPay record);

    FlowPay selectByPrimaryKey(String payFlow);

    int updateByPrimaryKeySelective(FlowPay record);

    int updateByPrimaryKey(FlowPay record);
}