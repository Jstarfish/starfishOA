package cls.pilottery.oms.monitor.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.oms.monitor.model.GameIssue;
import cls.pilottery.oms.monitor.model.GameIssueDetail;

public interface MGameIssueDao {

	public int saveGameIssue(GameIssue gameIssue);

	public List<GameIssue> listGameIssue(GameIssue gameIssue);
	
	//public int updateGameIssue(GameIssueMsg gameIssue);
	
	public int listCount(GameIssue gameIssue);
	
	public List<GameIssue> listAllGameIssue();
	
	public GameIssue findGameIssueByCode(Map<String,?> map);
	
	public List<GameIssue> findGameIssueByGameCode(long gameCode);
	
	public GameIssueDetail queryGameIssueDetail(GameIssueDetail gameIssueDetail);
	
	public int clearDate();
}
