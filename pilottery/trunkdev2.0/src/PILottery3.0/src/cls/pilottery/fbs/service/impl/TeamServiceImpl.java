package cls.pilottery.fbs.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.fbs.dao.TeamDao;
import cls.pilottery.fbs.model.Country;
import cls.pilottery.fbs.model.Match;
import cls.pilottery.fbs.model.Team;
import cls.pilottery.fbs.service.TeamService;

@Service
public class TeamServiceImpl implements TeamService {

	@Autowired
	private TeamDao teamDao;
	
	@Override
	public Integer getTeamCount(Team team) {
		return teamDao.getTeamCount(team);
	}

	@Override
	public List<Team> getTeamList(Team team) {
		return teamDao.getTeamList(team);
	}

	@Override
	public void addTeam(Team team) {
		Integer maxCode = this.teamDao.getMaxTeamCode();
		if(maxCode == null){
			maxCode = 9;
		}
		maxCode++;
		team.setTeamCode(maxCode+"");
		teamDao.addTeam(team);
	}

	@Override
	public Integer haveMatch(String teamCode) {
		return teamDao.haveMatch(teamCode);
	}

	@Override
	public void deleteTeam(Team team) {
		teamDao.deleteTeam(team);
	}

	@Override
	public List<Country> getCountry() {
		return teamDao.getCountry();
	}

	@Override
	public List<Match> getMatchList(String teamCode) {
		return teamDao.getMatchList(teamCode);
	}

	@Override
	public Team getTeamByCode(String teamCode) {
		return teamDao.getTeamByCode(teamCode);
	}

	@Override
	public void modifyTeam(Team team) {
		teamDao.modifyTeam(team);
	}

	@Override
	public Match getMatchNumber(String teamCode) {
		return teamDao.getMatchNumber(teamCode);
	}

}
