package cls.pilottery.web.capital.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.capital.form.OutletAcctForm;
import cls.pilottery.web.capital.model.OutletAccount;
import cls.pilottery.web.capital.model.OutletAccountExt;
import cls.pilottery.web.capital.model.OutletAccountModel;
import cls.pilottery.web.goodsreceipts.model.GamePlans;

public interface OutletAcctDao {

	// 总记录数
	public Integer getOutletAcctCount(OutletAcctForm outletAcctForm);

	// 每页显示的List
	public List<OutletAccount> getOutletAcctList(OutletAcctForm outletAcctForm);

	// 查询设置需要的账户信息
	public List<OutletAccountModel> getOutletAcctInfo(String agencyCode);

	// 根据code查询信息
	public List<OutletAccount> getOutletAcctByCode(String agencyCode);

	// 根据name查询信息
	public List<OutletAccount> getOutletAcctByName(String accName);

	// 删除账户信息，更改状态 deleteupdeSatus
	public int deleteupdeSatus(String agencyCode);

	// 修改账户信息 ，只是更新了信用额度Credit Limit
	public void updateOutletAccount(OutletAccountModel outletAccount);

	// 更新销售、兑奖提成比例
	public void updateOutletRate(OutletAccountModel outletAccount);

	// 获取站点方案，佣金
	public List<OutletAccountModel> getOutletCommRateInfo();

	// 获取游戏方案列表
	public List<GamePlans> getGamePlans();

	public List<OutletAccountModel> getOutletAcctInfo2(String agencyCode);

	public void updateAccountLimit(Map<String, Object> map);

}
