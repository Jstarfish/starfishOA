package cls.pilottery.dao;

import cls.pilottery.model.FlowGuiPay;

public interface FlowGuiPayMapper {
    int deleteByPrimaryKey(String guiPayNo);

    int insert(FlowGuiPay record);

    int insertSelective(FlowGuiPay record);

    FlowGuiPay selectByPrimaryKey(String guiPayNo);

    int updateByPrimaryKeySelective(FlowGuiPay record);

    int updateByPrimaryKey(FlowGuiPay record);
}