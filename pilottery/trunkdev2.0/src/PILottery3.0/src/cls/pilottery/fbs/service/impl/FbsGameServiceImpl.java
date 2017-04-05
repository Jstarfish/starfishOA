package cls.pilottery.fbs.service.impl;

import java.util.List;

import cls.pilottery.common.utils.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.fbs.dao.FbsGameDao;
import cls.pilottery.fbs.form.FbsMatchForm;
import cls.pilottery.fbs.model.Competition;
import cls.pilottery.fbs.model.Match;
import cls.pilottery.fbs.model.Team;
import cls.pilottery.fbs.service.FbsGameService;

@Service
public class FbsGameServiceImpl implements FbsGameService {

	@Autowired
	private FbsGameDao fbsGameDao;
	@Override
	public Integer getMatchCount(FbsMatchForm form) {
		return fbsGameDao.getMatchCount(form);
	}

	@Override
	public List<Match> getMatchList(FbsMatchForm form) {
		return fbsGameDao.getMatchList(form);
	}

	@Override
	public List<Competition> getAllCompetition() {
		return fbsGameDao.getAllCompetition();
	}

	@Override
	public List<Team> getTeamsByComptt(String competition) {
		return fbsGameDao.getTeamsByComptt(competition);
	}

	@Override
	public void saveMatch(Match match) {
		String matchDate = DateUtil.format(match.getMatchStartDate(),"yyyy-MM-dd");
		match.setMatchDate(DateUtil.getDate(matchDate));
		fbsGameDao.saveMatch(match);
	}

	@Override
	public Match getMatchInfo(String matchCode) {
		return fbsGameDao.getMatchInfo(matchCode);
	}

	@Override
	public void updateMatch(Match match) {
		String matchDate = DateUtil.format(match.getMatchStartDate(),"yyyy-MM-dd");
		match.setMatchDate(DateUtil.getDate(matchDate));
		fbsGameDao.updateMatch(match);
	}

	@Override
	public void deleteMatch(String matchCode) {
		fbsGameDao.deleteMatch(matchCode);
	}

	@Override
	public Integer getMaxMatchCount(String issueCode) {
		return fbsGameDao.getMaxMatchCount(issueCode);
	}
}
