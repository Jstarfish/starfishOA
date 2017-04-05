package cls.pilottery.oms.issue.service;

import java.util.Calendar;
import java.util.List;

import cls.pilottery.oms.issue.form.IssueManagementForm;
import cls.pilottery.oms.issue.model.DrawNoticeXml;
import cls.pilottery.oms.issue.model.GameDrawInfo;
import cls.pilottery.oms.issue.model.GameInfo;
import cls.pilottery.oms.issue.model.GameIssue;
import cls.pilottery.oms.issue.model.GameIssuePrizeDetail;
import cls.pilottery.oms.issue.model.GameIssuePrizeRule;
import cls.pilottery.oms.issue.model.GameParameterControlView;

public interface IssueManagementService {

	public List<GameInfo> getGameInfo();

	public Integer getGameIssueListCountSingle(IssueManagementForm issueManagementForm);

	public List<GameIssue> getGameIssueListSingle(IssueManagementForm issueManagementForm);

	public GameIssue getgameIssueByPK(Short gameCode, Long issueNumber);

	public GameDrawInfo getCurrentGameIssue(GameDrawInfo gameDrawInfo);

	public DrawNoticeXml getDrawNotice(String winnerBrodcast);

	public List<GameIssuePrizeDetail> getGameIssuePrizeDetail(Short gameCode, Long issueNumber);

	public void deleteIssue(GameIssue gi);

	public void updateGameIssuePrizeRule(List<GameIssuePrizeRule> list);

	public List<GameIssuePrizeRule> getGameIssuePrizeRule(Short gameCode, Long issueNumber);

	public void updateCalcWinningCode(cls.pilottery.oms.game.model.GameIssue gameIssue);

	public int getUnPublishCount(Short gameCode);

	public Long getMinPublishIssueNumber(IssueManagementForm form);

	public Long getMaxPublishIssueNumber(IssueManagementForm form);

	public void updateIssuePublish(IssueManagementForm form);

	public Long getMaxIssueNumber(int gameCode);

	public GameIssue getLastIssue(IssueManagementForm form);

	public Long getMaxIssueSeq(int gameCode);

	public GameIssue getgameIssueByPK(int gameCode, Long tINo);

	public boolean isDrawDay(Calendar calendar, int[] drawDays);

	public Long getMaxIssueSeq(Short gameCode);

	public GameParameterControlView getControlView(Short gameCode);

	public String insertIssuesP(List<GameIssue> issueList);

	public GameIssue getMaxIssueByGame(Short gameCode);

}
