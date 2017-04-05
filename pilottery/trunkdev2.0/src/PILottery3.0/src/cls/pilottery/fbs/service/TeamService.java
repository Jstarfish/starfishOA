package cls.pilottery.fbs.service;

import java.util.List;

import cls.pilottery.fbs.model.Country;
import cls.pilottery.fbs.model.Match;
import cls.pilottery.fbs.model.Team;

public interface TeamService {

	public Integer getTeamCount(Team team);

	public List<Team> getTeamList(Team team);

	public void addTeam(Team team);

	public Integer haveMatch(String teamCode);

	public void deleteTeam(Team team);

	public List<Country> getCountry();

	public List<Match> getMatchList(String teamCode);

	public Team getTeamByCode(String teamCode);

	public void modifyTeam(Team team);

	public Match getMatchNumber(String teamCode);


}
