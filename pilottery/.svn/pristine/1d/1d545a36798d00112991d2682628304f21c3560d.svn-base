package cls.pilottery.web.capital.service;

import java.util.List;

import cls.pilottery.web.capital.form.CashWithdrawnForm;
import cls.pilottery.web.capital.model.InstitutionAccount;
import cls.pilottery.web.capital.model.withdrawnmodel.CashWithdrawn;

public interface CashWithdrawnService {

	public Integer getCashWithdrawnCount(CashWithdrawnForm cashWithdrawnForm);
	
	public Integer getInstitutionCashWithdrawnCount(CashWithdrawnForm cashWithdrawnForm);

	public List<CashWithdrawn> getCashWithdrawnList(
			CashWithdrawnForm cashWithdrawnForm);
	
	public List<CashWithdrawn> getInstitutionCashWithdrawnList(
			CashWithdrawnForm cashWithdrawnForm);
	
	//修改提现申请的状态
	int modifyWithdrawnStatus(String fundNo, int applyStatus);
	
	void deleteWithdrawn(String fundNo);
	
	/* 获得部门账户信息 */
	public InstitutionAccount getInstitutionAccountList(String orgCode);
	
	/* 提现申请 */
	public void forOrgsCashWithdrawn(CashWithdrawnForm cashWithdrawnForm);
	
	/*获取提现申请信息 */
	public CashWithdrawn getCashWithdrawnInfo(CashWithdrawn cashWithdrawn);
	
	/* 提现审批状态修改 */
	public void updateWithdrawnAproval(CashWithdrawnForm cashWithdrawnForm);
	
	/* 根据提现编码获取提现信息 */
	public CashWithdrawn getCashWithdrawnInfoById(String fundNo);
	
	public void approveWithdrawn(CashWithdrawnForm cashWithdrawnForm);
	
	String getAccNoByOrgCode(String orgCode);
	
	public void refuseWithdrawn(CashWithdrawnForm cashWithdrawnForm);
}
