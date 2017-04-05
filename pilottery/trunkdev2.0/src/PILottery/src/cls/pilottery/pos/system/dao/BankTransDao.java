package cls.pilottery.pos.system.dao;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import cls.pilottery.pos.system.model.bank.AgencyDigitalTranInfo;
import cls.pilottery.pos.system.model.bank.BankTopupRequest;
import cls.pilottery.pos.system.model.bank.OutletAccoutInfo;


public interface BankTransDao {

	List<OutletAccoutInfo> getOutletPayType(@Param("outletCode")String outletCode,@Param("pType")int pType);

	AgencyDigitalTranInfo getOutletTranInfo(BankTopupRequest agency);
	
	AgencyDigitalTranInfo getOutletTranInfoNoFlow(BankTopupRequest agency);
	
	//插入交易日志
	void insertTranLog(AgencyDigitalTranInfo info);
	
	//用于失败，更新状态和原因
	void updataTranLog(AgencyDigitalTranInfo info);
	
	//交易确认，用于充值成功后的调用存储等进行交易流水相关信息，账户余额变更等相关操作
	void topupConfirm(AgencyDigitalTranInfo info);
	
	//申请提线
	void applyForWithdraw(AgencyDigitalTranInfo info);
	
	//提现退款
	void withdrawCancel(AgencyDigitalTranInfo info);
	
	
	
}
