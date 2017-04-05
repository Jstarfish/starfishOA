package cls.pilottery.web.capital.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.capital.form.InstitutionAcctForm;
import cls.pilottery.web.capital.model.InstitutionAccount;
import cls.pilottery.web.capital.model.InstitutionAccountModel;

public interface InstitutionAcctDao {
	// 总记录数
	public Integer getInstitutionAcctCount(
			InstitutionAcctForm institutionAcctForm);

	// 每页显示的List
	public List<InstitutionAccount> getInstitutionAcctList(
			InstitutionAcctForm institutionAcctForm);

	// 删除账户信息，更改状态 deleteupdeSatus
	public int deleteupdeSatus(String agencyCode);

	// 查询设置需要的账户信息
	public List<InstitutionAccountModel> getInstitutionAcctInfo(String orgCode);

	public List<InstitutionAccountModel> getInstitutionAcctInfo2(String orgCode);

	public void updateInstitutionLimit(Map<String,Object> map);


}
