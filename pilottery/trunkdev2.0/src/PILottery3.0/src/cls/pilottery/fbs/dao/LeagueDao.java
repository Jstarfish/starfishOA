package cls.pilottery.fbs.dao;

import java.util.List;

import cls.pilottery.fbs.model.League;
import cls.pilottery.fbs.model.LeagueTeamRelation;
import cls.pilottery.fbs.model.Team;

public interface LeagueDao {

	Integer getLeagueCount(League league);

	List<League> getLeagueList(League league);

	List<Team> getTeam();

	void addLeague(League league);

	void deleteLeague(League league);

	League getLeagueByCode(String competitionCode);

	List<Team> getTeamByLeagueCode(String competitionCode);

	void saveLeagueTeamRelation(LeagueTeamRelation relation);

	void deleteLeagueTeam(String competitionCode);

	void updateLeague(League league);

	Integer getMaxLeagueCode();

	Integer haveMatch(String competitionCode);
}
