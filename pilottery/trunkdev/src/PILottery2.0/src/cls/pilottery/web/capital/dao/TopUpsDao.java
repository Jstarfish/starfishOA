package cls.pilottery.web.capital.dao;

import java.util.List;

import cls.pilottery.web.capital.form.TopUpsForm;
import cls.pilottery.web.capital.model.InstitutionAccount;
import cls.pilottery.web.capital.model.paymodel.TopUps;
import cls.pilottery.web.institutions.model.InfOrgs;

public interface TopUpsDao {

	// 总记录数
	public Integer getTopUpsCount(TopUpsForm topUpsForm);

	// 每页显示的List
	public List<TopUps> getTopUpsList(TopUpsForm topUpsForm);

	// 充值准备
	public List<TopUps> getTopUpsInfo(String aoCode);

	// 级联 部门名称和编号
	public InfOrgs getOrgInfoByOrgCode(String orgCode);

	// 级联部门名称和余额
	public InstitutionAccount getOrgBalanceByOrgCode(String orgCode);

	// 部门账户资金充值
	public void insititutionTopUps(TopUpsForm topUpsForm);

	// 获取打印凭证的信息
	TopUps getTopUpsByPk(String fundNo);
}
