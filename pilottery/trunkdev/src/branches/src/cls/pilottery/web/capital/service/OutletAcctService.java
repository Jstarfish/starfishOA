package cls.pilottery.web.capital.service;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.capital.form.OutletAcctForm;
import cls.pilottery.web.capital.model.OutletAccount;
import cls.pilottery.web.capital.model.OutletAccountExt;
import cls.pilottery.web.capital.model.OutletAccountModel;
import cls.pilottery.web.goodsreceipts.model.GamePlans;

public interface OutletAcctService {

	// 总记录数
	public Integer getOutletAcctCount(OutletAcctForm outletAcctForm);

	// 每一页显示的信息list
	public List<OutletAccount> getOutletAcctList(OutletAcctForm outletAcctForm);

	// 查询账户信息
	public List<OutletAccountModel> getOutletAcctInfo(String agencyCode);

	// 取得站点方案佣金
	public List<OutletAccountModel> getOutletCommRateInfo();

	// 获取游戏方案
	public List<GamePlans> getGamePlans();

	// 删除，更新状态
	public int deleteupdeSatus(String agencyCode);

	// 修改
	public void updateAccountComm(OutletAccountExt outlet);

	public List<OutletAccountModel> getOutletAcctInfo2(String agencyCode);

	public void updateAccountLimit(Map<String, Object> map);

}
