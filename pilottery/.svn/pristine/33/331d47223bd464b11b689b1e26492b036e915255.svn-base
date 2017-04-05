package cls.pilottery.oms.monitor.service;

import java.util.List;
import java.util.Map;

import cls.pilottery.oms.monitor.model.GameIssue;
import cls.pilottery.oms.monitor.model.GameIssueDetail;
import cls.pilottery.oms.monitor.model.xmlEntity.Location;
import cls.pilottery.oms.monitor.model.xmlEntity.Prize;

public interface MGameIssueService {

	public int listCount(GameIssue gameIssue);

	public GameIssue findGameIssueByCode(Map<String, ?> map);

	public List<GameIssue> listGameIssue(GameIssue gameIssue);

	public GameIssueDetail queryGameIssueDetail(GameIssueDetail gameIssueDetail);

	public List<Prize> getPriceList(GameIssueDetail gid);

	public List<Location> getHighPriceList(GameIssueDetail gid);

}
