package cls.pilottery.oms.monitor.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.monitor.dao.MGamesDao;
import cls.pilottery.oms.monitor.model.Games;

@Service
public class MGamesService implements cls.pilottery.oms.monitor.service.MGamesService {

	@Autowired
	private MGamesDao mGameDao;

	@Override
	public List<Games> queryGames() {
		return mGameDao.queryGames();
	}

}
