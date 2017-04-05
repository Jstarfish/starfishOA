package cls.pilottery.oms.issue.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.issue.dao.GameDrawDao;
import cls.pilottery.oms.issue.model.AreaSaleDetail;
import cls.pilottery.oms.issue.model.GameDrawInfo;
import cls.pilottery.oms.issue.model.PrizeLevel;
import cls.pilottery.oms.issue.service.GameDrawService;

@Service
public class GameDrawServiceImpl implements GameDrawService{

    @Autowired
    private GameDrawDao gameDrawDao;

    public List<GameDrawInfo> getManualDrawGameList() {
        return gameDrawDao.getManualDrawGameList();
    }

    @Override
    public GameDrawInfo getCurrentGameIssue(GameDrawInfo gameDrawInfo) {
        return gameDrawDao.getCurrentGameIssue(gameDrawInfo);
    }

    @Override
    public int updateGameIssue(GameDrawInfo gameDrawInfo) {
        return gameDrawDao.updateGameIssue(gameDrawInfo);
    }
    
    @Override
    public List<PrizeLevel> getPrizeLevels(int gameCode) {
        return gameDrawDao.getPrizeLevels(gameCode);
    }
    
    @Override
    public List<AreaSaleDetail> getLevelAreas() {
        return gameDrawDao.getLevelAreas();
    }

	@Override
	public int redrawGameIssue(GameDrawInfo manualDraw) {
		return gameDrawDao.redrawGameIssue(manualDraw);
	}
}
