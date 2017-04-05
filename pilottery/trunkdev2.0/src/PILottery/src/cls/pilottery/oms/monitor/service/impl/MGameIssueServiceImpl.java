package cls.pilottery.oms.monitor.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.monitor.dao.MGameIssueDao;
import cls.pilottery.oms.monitor.model.GameIssue;
import cls.pilottery.oms.monitor.model.GameIssueDetail;
import cls.pilottery.oms.monitor.model.xmlEntity.Location;
import cls.pilottery.oms.monitor.model.xmlEntity.Prize;
import cls.pilottery.oms.monitor.service.MGameIssueService;

@Service
public class MGameIssueServiceImpl implements MGameIssueService {

	@Autowired
	private MGameIssueDao mGameIssueDao;

	@Override
	public int listCount(GameIssue gameIssue) {
		return mGameIssueDao.listCount(gameIssue);
	}

	@Override
	public List<GameIssue> listGameIssue(GameIssue gameIssue) {
		return mGameIssueDao.listGameIssue(gameIssue);
	}

	@Override
	public GameIssue findGameIssueByCode(Map<String, ?> map) {
		return mGameIssueDao.findGameIssueByCode(map);
	}

	@Override
	public GameIssueDetail queryGameIssueDetail(GameIssueDetail gameIssueDetail) {
		return mGameIssueDao.queryGameIssueDetail(gameIssueDetail);
	}

	@Override
	public List<Prize> getPriceList(GameIssueDetail gid) {
		return mGameIssueDao.getPriceList(gid);
	}

	@Override
	public List<Location> getHighPriceList(GameIssueDetail gid) {
		return mGameIssueDao.getHighPriceList(gid);
	}

}
