package cls.pilottery.web.capital.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.capital.dao.RepaymentDao;
import cls.pilottery.web.capital.form.NewRepaymentForm;
import cls.pilottery.web.capital.form.RepaymentQueryForm;
import cls.pilottery.web.capital.model.MarketManagerAccount;
import cls.pilottery.web.capital.model.RepaymentRecord;
import cls.pilottery.web.capital.service.RepaymentService;

@Service
public class RepaymentServiceImpl implements RepaymentService {

	@Autowired
	private RepaymentDao repaymentDao;
	
	/* 获得还款记录总数 */
	@Override
	public Integer getRepaymentCount(RepaymentQueryForm repaymentQueryForm) {
		return this.repaymentDao.getRepaymentCount(repaymentQueryForm);
	}

	/* 获得还款记录 */
	@Override
	public List<RepaymentRecord> getRepaymentList(RepaymentQueryForm repaymentQueryForm) {
		return this.repaymentDao.getRepaymentList(repaymentQueryForm);
	}
	
	/* 获得市场管理员账户信息 */
	@Override
	public List<MarketManagerAccount> getMarketManagerAccountList(String orgCode) {
		return this.repaymentDao.getMarketManagerAccountList(orgCode);
	}
	
	/* 提交还款记录 */
	@Override
	public void addRepayment(NewRepaymentForm newRepaymentForm) {
		this.repaymentDao.addRepayment(newRepaymentForm);
	}
}
