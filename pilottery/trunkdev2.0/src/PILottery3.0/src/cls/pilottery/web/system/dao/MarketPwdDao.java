package cls.pilottery.web.system.dao;

import cls.pilottery.web.capital.model.MarketManager;

public interface MarketPwdDao {

	void updatePwd(MarketManager marketManager);

	MarketManager getMarketById(Long id);

}
