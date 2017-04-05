package cls.pilottery.web.system.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.web.capital.model.MarketManager;
import cls.pilottery.web.system.dao.MarketPwdDao;
import cls.pilottery.web.system.service.MarketPwdService;

@Service
public class MarketPwdServiceImpl implements MarketPwdService {

	@Autowired
	private MarketPwdDao marketPwdDao;

	@Override
	public void updatePwd(MarketManager marketManager) {
		marketPwdDao.updatePwd(marketManager);
	}

	@Override
	public MarketManager getMarketById(Long id) {
		return marketPwdDao.getMarketById(id);
	}

}
