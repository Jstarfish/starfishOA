package cls.pilottery.web.capital.dao;

import cls.pilottery.web.capital.model.balancemodel.Balance;

public interface BalanceDao {

	// 查询当前部门账户余额
	public Balance getAccountBalanceInfo(String orgCode);
	
}
