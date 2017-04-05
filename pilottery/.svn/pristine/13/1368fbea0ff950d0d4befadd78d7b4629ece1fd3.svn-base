package cls.pilottery.fbs.service.impl;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cls.pilottery.fbs.dao.LeagueDao;
import cls.pilottery.fbs.model.League;
import cls.pilottery.fbs.model.LeagueTeamRelation;
import cls.pilottery.fbs.model.Team;
import cls.pilottery.fbs.service.LeagueService;
@Service
public class LeagueServiceImpl implements LeagueService {

	@Autowired
	private LeagueDao leagueDao;
	@Override
	public Integer getLeagueCount(League league) {
		return leagueDao.getLeagueCount(league);
	}

	@Override
	public List<League> getLeagueList(League league) {
		return leagueDao.getLeagueList(league);
	}

	@Override
	public List<Team> getTeam() {
		return leagueDao.getTeam();
	}
	
	@Transactional(rollbackFor={Exception.class})
	@Override
	public void addLeague(League league) {
		//编号自增，从10开始
		Integer maxCode = this.leagueDao.getMaxLeagueCode();
		if(maxCode == null){
			maxCode = 9;
		}
		maxCode++;
		league.setCompetitionCode(""+maxCode);
		leagueDao.addLeague(league);
	}

	@Override
	public void deleteLeague(League league) {
		leagueDao.deleteLeague(league);
	}

	@Override
	public League getLeagueByCode(String competitionCode) {
		return leagueDao.getLeagueByCode(competitionCode);
	}

	@Override
	public List<Team> getTeamByLeagueCode(String competitionCode) {
		return leagueDao.getTeamByLeagueCode(competitionCode);
	}

	@Override
	public void updateLeague(League league) {
		leagueDao.updateLeague(league);
	}

	@Override
	public Integer haveMatch(String competitionCode) {
		return leagueDao.haveMatch(competitionCode);
	}

}
