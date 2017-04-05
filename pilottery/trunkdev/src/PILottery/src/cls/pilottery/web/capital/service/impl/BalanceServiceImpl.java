package cls.pilottery.web.capital.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.capital.dao.BalanceDao;
import cls.pilottery.web.capital.model.balancemodel.Balance;
import cls.pilottery.web.capital.service.BalanceService;

@Service
public class BalanceServiceImpl implements BalanceService {

	@Autowired
	private BalanceDao balanceDao;

	@Override
	public Balance getAccountBalanceInfo(String orgCode) {
		return balanceDao.getAccountBalanceInfo(orgCode);
	}


}
