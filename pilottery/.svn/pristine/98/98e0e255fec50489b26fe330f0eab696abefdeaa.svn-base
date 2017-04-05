package cls.pilottery.fbs.dao;

import java.util.List;

import cls.pilottery.fbs.model.Country;
import cls.pilottery.fbs.model.Match;
import cls.pilottery.fbs.model.Team;

public interface TeamDao {

	Integer getTeamCount(Team team);

	List<Team> getTeamList(Team team);

	void addTeam(Team team);

	Integer haveMatch(String teamCode);

	void deleteTeam(Team team);

	List<Country> getCountry();

	List<Match> getMatchList(String teamCode);

	Team getTeamByCode(String teamCode);

	void modifyTeam(Team team);

	Match getMatchNumber(String teamCode);

	Integer getMaxTeamCode();

}
