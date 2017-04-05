package cls.pilottery.web.system.service;

import cls.pilottery.web.capital.model.MarketManager;

public interface MarketPwdService {

	void updatePwd(MarketManager marketManager);

	MarketManager getMarketById(Long id);
}
