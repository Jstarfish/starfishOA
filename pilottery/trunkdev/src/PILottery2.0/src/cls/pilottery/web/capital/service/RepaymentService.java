package cls.pilottery.web.capital.service;

import java.util.List;

import cls.pilottery.web.capital.form.NewRepaymentForm;
import cls.pilottery.web.capital.form.RepaymentQueryForm;
import cls.pilottery.web.capital.model.MarketManagerAccount;
import cls.pilottery.web.capital.model.RepaymentRecord;

public interface RepaymentService {
	/* 获得还款记录总数 */
	public Integer getRepaymentCount(RepaymentQueryForm repaymentQueryForm);
	
	/* 获得还款记录 */
	public List<RepaymentRecord> getRepaymentList(RepaymentQueryForm repaymentQueryForm);
	
	/* 获得市场管理员账户信息 */
	public List<MarketManagerAccount> getMarketManagerAccountList(String orgCode);
	
	/* 提交还款记录 */
	public void addRepayment(NewRepaymentForm newRepaymentForm);
}
