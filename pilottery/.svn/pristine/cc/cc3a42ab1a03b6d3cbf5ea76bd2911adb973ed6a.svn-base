package cls.pilottery.oms.issue.dao;

import java.util.List;

import cls.pilottery.oms.issue.model.AreaSaleDetail;
import cls.pilottery.oms.issue.model.GameDrawInfo;
import cls.pilottery.oms.issue.model.PrizeLevel;

public interface GameDrawDao {

    public List<GameDrawInfo> getManualDrawGameList();

    public GameDrawInfo getCurrentGameIssue(GameDrawInfo gameDrawInfo);

    public int updateGameIssue(GameDrawInfo gameDrawInfo);
    
    public List<PrizeLevel> getPrizeLevels(int gameCode);
    
    public List<AreaSaleDetail> getLevelAreas();

}
