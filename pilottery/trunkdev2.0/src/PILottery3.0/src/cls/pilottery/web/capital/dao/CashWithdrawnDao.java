package cls.pilottery.web.capital.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.capital.form.CashWithdrawnForm;
import cls.pilottery.web.capital.model.InstitutionAccount;
import cls.pilottery.web.capital.model.withdrawnmodel.CashWithdrawn;

public interface CashWithdrawnDao {

	public Integer getCashWithdrawnCount(CashWithdrawnForm cashWithdrawnForm);
	
	//部门资金服务下的提现申请列表
	public Integer getInstitutionCashWithdrawnCount(CashWithdrawnForm cashWithdrawnForm);
	
	public List<CashWithdrawn> getCashWithdrawnList(CashWithdrawnForm cashWithdrawnForm);
	
	public List<CashWithdrawn> getInstitutionCashWithdrawnList(CashWithdrawnForm cashWithdrawnForm);
	
	// note:修改提现申请的状态  修改的是map 
	int modifyWithdrawnStatus(Map<String, Object> map);
	
	//删除申请
	void deleteWithdrawn(String fundNo);
	
	/* 获得部门账户信息 */
	public InstitutionAccount getInstitutionAccountList(String orgCode);
	
	/* 提现申请 */
	public void forOrgsCashWithdrawn(CashWithdrawnForm cashWithdrawnForm);
	
	/*获取提现申请信息 */
	public CashWithdrawn getCashWithdrawnInfo(CashWithdrawn cashWithdrawn);
	
	/* 提现审批状态修改  确认提现 */
	public void updateWithdrawnAproval(CashWithdrawnForm cashWithdrawnForm);
	
	/* 根据提现编码获取提现信息 */
	public CashWithdrawn getCashWithdrawnInfoById(String fundNo);
	
	//审批
	public void approveWithdrawn(CashWithdrawnForm cashWithdrawnForm);
	
	String getAccNoByOrgCode(String orgCode);

	//审批拒绝后不打印了
	public void refuseWithdrawn(CashWithdrawnForm cashWithdrawnForm);
}
