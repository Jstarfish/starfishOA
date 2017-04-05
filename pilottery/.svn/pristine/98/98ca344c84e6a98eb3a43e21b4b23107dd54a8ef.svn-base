package cls.pilottery.oms.issue.dao;

import java.util.List;

import cls.pilottery.oms.issue.form.IssueManagementForm;
import cls.pilottery.oms.issue.model.DrawNoticeXml;
import cls.pilottery.oms.issue.model.GameDrawInfo;
import cls.pilottery.oms.issue.model.GameInfo;
import cls.pilottery.oms.issue.model.GameIssue;
import cls.pilottery.oms.issue.model.GameIssuePrizeDetail;
import cls.pilottery.oms.issue.model.GameIssuePrizeRule;
import cls.pilottery.oms.issue.model.GameParameterControlView;

public interface IssueManagementDao {

	Integer getGameIssueListCountSingle(IssueManagementForm issueManagementForm);

	List<GameIssue> getGameIssueListSingle(IssueManagementForm issueManagementForm);

	List<GameInfo> getGameInfo();

	GameIssue getgameIssueByPK(Short gameCode, Long issueNumber);

	GameDrawInfo getCurrentGameIssue(GameDrawInfo gameDrawInfo);

	DrawNoticeXml getDrawNotice(String winnerBrodcast);

	List<GameIssuePrizeDetail> getGameIssuePrizeDetail(Long gameCode, Long issueNumber);

	void deleteIssue(GameIssue gi);

	List<GameIssuePrizeRule> getGameIssuePrizeRule(Short gameCode, Long issueNumber);

	void updateGameIssuePrizeRule(List<GameIssuePrizeRule> list);

	void updateCalcWinningCode(cls.pilottery.oms.game.model.GameIssue gameIssue);

	Long getMaxPublishIssueNumber(IssueManagementForm form);

	Long getMinPublishIssueNumber(IssueManagementForm form);

	int getUnPublishCount(Short gameCode);

	void updateIssuePublish(IssueManagementForm form);

	GameParameterControlView getControlView(Short gameCode);

	GameIssue getLastIssue(IssueManagementForm form);

	Long getMaxIssueNumber(int gameCode);

	Long getMaxIssueSeq(int gameCode);

	GameIssue getgameIssueByPK(int gameCode);

	GameIssue getMaxIssueByGame(Short gameCode);

}
