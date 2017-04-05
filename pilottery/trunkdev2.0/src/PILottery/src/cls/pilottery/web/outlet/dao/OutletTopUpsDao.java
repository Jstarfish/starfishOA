package cls.pilottery.web.outlet.dao;

import java.util.List;

import cls.pilottery.web.capital.form.CashWithdrawnForm;
import cls.pilottery.web.capital.model.OutletAccount;
import cls.pilottery.web.outlet.form.OutletTopUpsForm;
import cls.pilottery.web.outlet.model.Agencys;
import cls.pilottery.web.outlet.model.OutletTopUps;

public interface OutletTopUpsDao {

	// 总记录数
	public Integer getOutletTopUpsCount(OutletTopUpsForm outletTopUpsForm);

	// 每页显示的List
	public List<OutletTopUps> getOutletTopUpsList(OutletTopUpsForm outletTopUpsForm);
	
	
	//根据当前用户id获取列表
	public List<OutletTopUps> getOutletListByUser(short userId);

	// 部门账户资金充值
	public void forOutletTopup(OutletTopUpsForm outletTopUpsForm);
	// 部门账户资金提现
	public void forOutletCashWithdrawn(CashWithdrawnForm cashWithdrawnForm);
	
	// 获取打印凭证的信息
	OutletTopUps getOutletTopUpsByPk(String fundNo);
	
	List<OutletTopUps> getOutletTopUpsById(String agencyCode);
	
	// 级联站点名称和编号
	public Agencys getAgencyName(String agencyCode);
	
	public OutletAccount getAgencyBalance(String agencyCode);
	
	public OutletTopUpsForm getOutletInfo(String agencyCode);
	
	
	
}
