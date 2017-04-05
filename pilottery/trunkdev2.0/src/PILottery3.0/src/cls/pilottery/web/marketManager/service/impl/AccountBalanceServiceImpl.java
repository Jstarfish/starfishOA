package cls.pilottery.web.marketManager.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.marketManager.dao.AccountBalanceDao;
import cls.pilottery.web.marketManager.entity.AccountBalance;
import cls.pilottery.web.marketManager.service.AccountBalanceService;

@Service
public class AccountBalanceServiceImpl implements AccountBalanceService{

	@Autowired
	private AccountBalanceDao accouontBalanceDao;

	@Override
	public AccountBalance getMarketAccountInfo(Long maketAdmin) {
		return accouontBalanceDao.getMarketAccountInfo(maketAdmin);
	}

}
