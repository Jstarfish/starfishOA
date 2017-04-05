package cls.pilottery.fbs.dao;

import java.util.List;

import cls.pilottery.fbs.form.FbsMatchForm;
import cls.pilottery.fbs.model.Competition;
import cls.pilottery.fbs.model.Match;
import cls.pilottery.fbs.model.Team;
import org.springframework.stereotype.Component;

@Component
public interface FbsGameDao {

	Integer getMatchCount(FbsMatchForm form);

	List<Match> getMatchList(FbsMatchForm form);

	List<Competition> getAllCompetition();

	List<Team> getTeamsByComptt(String competition);

	void saveMatch(Match match);

	Match getMatchInfo(String matchCode);

	void updateMatch(Match match);

	void deleteMatch(String matchCode);

	Integer getMaxMatchCount(String issueCode);

}
