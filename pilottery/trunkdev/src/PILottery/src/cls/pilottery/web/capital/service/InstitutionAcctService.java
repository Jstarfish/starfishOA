package cls.pilottery.web.capital.service;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.capital.form.InstitutionAcctForm;
import cls.pilottery.web.capital.model.InstitutionAccount;
import cls.pilottery.web.capital.model.InstitutionAccountExt;
import cls.pilottery.web.capital.model.InstitutionAccountModel;
import cls.pilottery.web.capital.model.OutletAccountModel;

public interface InstitutionAcctService {

	//信息列表
	public List<InstitutionAccount> getInstitutionAcctList(
			InstitutionAcctForm institutionAcctForm);

	// 总记录数
	public Integer getInstitutionAcctCount(
			InstitutionAcctForm institutionAcctForm);

	// 修改
	public void updateCommRate(InstitutionAccountExt insitutionInfo);

	// 查询账户信息
	public List<InstitutionAccountModel> getInstitutionAcctInfo(String orgCode);

	//删除
	public int deleteupdeSatus(String orgCode);

	public List<InstitutionAccountModel> getInstitutionAcctInfo2(String orgCode);

	public void updateInstitutionLimit(Map<String,Object> map);
}
