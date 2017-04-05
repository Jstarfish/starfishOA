package cls.pilottery.web.marketManager.dao;

import cls.pilottery.web.marketManager.entity.AccountBalance;

public interface AccountBalanceDao {
	
	public AccountBalance getMarketAccountInfo(Long maketAdmin);
}
