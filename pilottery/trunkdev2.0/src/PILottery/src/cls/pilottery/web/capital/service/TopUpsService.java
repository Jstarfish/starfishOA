package cls.pilottery.web.capital.service;

import java.util.List;

import cls.pilottery.web.capital.form.TopUpsForm;
import cls.pilottery.web.capital.model.InstitutionAccount;
import cls.pilottery.web.capital.model.paymodel.TopUps;
import cls.pilottery.web.institutions.model.InfOrgs;

public interface TopUpsService {

	// 总记录数
	public Integer getTopUpsCount(TopUpsForm topUpsForm);

	// 每页显示的List
	public List<TopUps> getTopUpsList(TopUpsForm topUpsForm);

	public List<TopUps> getTopUpsInfo(String aoCode);

	public InfOrgs getOrgInfoByOrgCode(String orgCode);

	public InstitutionAccount getOrgBalanceByOrgCode(String orgCode);

	public void insititutionTopUps(TopUpsForm topUpsForm);

	TopUps getTopUpsByPk(String fundNo);
}
