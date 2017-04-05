package cls.pilottery.oms.issue.service.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.List;

import javax.annotation.Resource;

import oracle.jdbc.OracleTypes;
import oracle.jdbc.driver.OracleConnection;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.issue.dao.IssueManagementDao;
import cls.pilottery.oms.issue.form.IssueManagementForm;
import cls.pilottery.oms.issue.model.DrawNoticeXml;
import cls.pilottery.oms.issue.model.GameDrawInfo;
import cls.pilottery.oms.issue.model.GameInfo;
import cls.pilottery.oms.issue.model.GameIssue;
import cls.pilottery.oms.issue.model.GameIssuePrizeDetail;
import cls.pilottery.oms.issue.model.GameIssuePrizeRule;
import cls.pilottery.oms.issue.model.GameParameterControlView;
import cls.pilottery.oms.issue.service.IssueManagementService;

@Service
public class IssueManagementServiceImpl implements IssueManagementService {
	static Logger log = Logger.getLogger(IssueManagementServiceImpl.class);
	@Autowired
	private IssueManagementDao issueManagementDao;
	@Resource
	private JdbcTemplate jdbcTemplateTwo;

	@Override
	public List<GameInfo> getGameInfo() {
		return issueManagementDao.getGameInfo();
	}

	@Override
	public Integer getGameIssueListCountSingle(IssueManagementForm issueManagementForm) {
		return issueManagementDao.getGameIssueListCountSingle(issueManagementForm);
	}

	@Override
	public List<GameIssue> getGameIssueListSingle(IssueManagementForm issueManagementForm) {
		return issueManagementDao.getGameIssueListSingle(issueManagementForm);
	}

	@Override
	public GameIssue getgameIssueByPK(Short gameCode, Long issueNumber) {
		return issueManagementDao.getgameIssueByPK(gameCode, issueNumber);
	}

	@Override
	public GameDrawInfo getCurrentGameIssue(GameDrawInfo gameDrawInfo) {
		return issueManagementDao.getCurrentGameIssue(gameDrawInfo);
	}

	@Override
	public DrawNoticeXml getDrawNotice(String winnerBrodcast) {
		return issueManagementDao.getDrawNotice(winnerBrodcast);
	}

	@Override
	public List<GameIssuePrizeDetail> getGameIssuePrizeDetail(Short gameCode, Long issueNumber) {
		return issueManagementDao.getGameIssuePrizeDetail((long) gameCode, issueNumber);
	}

	@Override
	public void deleteIssue(GameIssue gi) {
		issueManagementDao.deleteIssue(gi);
	}

	@Override
	public List<GameIssuePrizeRule> getGameIssuePrizeRule(Short gameCode, Long issueNumber) {
		return issueManagementDao.getGameIssuePrizeRule(gameCode, issueNumber);
	}

	@Override
	public void updateGameIssuePrizeRule(List<GameIssuePrizeRule> list) {
		issueManagementDao.updateGameIssuePrizeRule(list);
	}

	@Override
	public void updateCalcWinningCode(cls.pilottery.oms.game.model.GameIssue gameIssue) {
		issueManagementDao.updateCalcWinningCode(gameIssue);
	}

	@Override
	public Long getMaxPublishIssueNumber(IssueManagementForm form) {
		return issueManagementDao.getMaxPublishIssueNumber(form);
	}

	@Override
	public Long getMinPublishIssueNumber(IssueManagementForm form) {
		return issueManagementDao.getMinPublishIssueNumber(form);
	}

	@Override
	public int getUnPublishCount(Short gameCode) {
		return issueManagementDao.getUnPublishCount(gameCode);
	}

	@Override
	public void updateIssuePublish(IssueManagementForm form) {
		issueManagementDao.updateIssuePublish(form);
	}

	@Override
	public GameParameterControlView getControlView(Short gameCode) {
		return issueManagementDao.getControlView(gameCode);
	}

	@Override
	public GameIssue getLastIssue(IssueManagementForm form) {
		return issueManagementDao.getLastIssue(form);
	}

	@Override
	public Long getMaxIssueNumber(int gameCode) {
		return issueManagementDao.getMaxIssueNumber(gameCode);
	}

	@Override
	public Long getMaxIssueSeq(int gameCode) {
		return issueManagementDao.getMaxIssueSeq(gameCode);
	}

	@Override
	public Long getMaxIssueSeq(Short gameCode) {
		return issueManagementDao.getMaxIssueSeq(gameCode);
	}

	@Override
	public GameIssue getgameIssueByPK(int gameCode, Long issueNumber) {
		return issueManagementDao.getgameIssueByPK((short)gameCode,issueNumber);
	}

	@Override
	public String insertIssuesP(List<GameIssue> issueList) {
		int resultCode = 0;
		String resultMesg = "";

		Connection conn = null;
		try {
			conn = jdbcTemplateTwo.getDataSource().getConnection();// 通过注解的方式获取数据源，并获取连接

			if (conn.isWrapperFor(OracleConnection.class)) {
				conn = conn.unwrap(OracleConnection.class);
			}
			conn.setAutoCommit(false);

			StructDescriptor sd = new StructDescriptor("TYPE_GAME_ISSUE_INFO", conn);
			STRUCT[] result = new STRUCT[issueList.size()];
			for (int index = 0; index < issueList.size(); index++) {
				GameIssue issue = issueList.get(index);
				Object[] o = new Object[5];
				o[0] = (int) issue.getGameCode(); // 游戏编号
				o[1] = issue.getIssueNumber(); // 期次号
				o[2] = new java.sql.Timestamp(issue.getPlanStartTime().getTime()); // 预计开始时间
				o[3] = new java.sql.Timestamp(issue.getPlanCloseTime().getTime()); // 预计结束时间
				o[4] = new java.sql.Timestamp(issue.getPlanRewardTime().getTime()); // 预计开奖时间
				result[index] = new STRUCT(sd, conn, o);
			}
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor("TYPE_GAME_ISSUE_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);

			CallableStatement stmt = conn.prepareCall("{ call p_om_issue_create(?,?,?) }");
			stmt.setObject(1, oracle_array);
			stmt.registerOutParameter(2, OracleTypes.NUMBER);
			stmt.registerOutParameter(3, OracleTypes.VARCHAR);
			stmt.execute();

			resultCode = stmt.getInt(2);
			resultMesg = stmt.getString(3);
			log.info("return code:" + resultCode + ",return mesg:" + resultMesg);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
					conn = null;
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return resultCode + "#" + resultMesg;
	}

	@Override
	public boolean isDrawDay(Calendar date, int[] drawDays) {
		for (int i = 0; i < drawDays.length; i++) {
			if ((date.get(Calendar.DAY_OF_WEEK) - 1) == drawDays[i])
				return true;
		}
		return false;
	}

	@Override
	public GameIssue getMaxIssueByGame(Short gameCode) {
		return issueManagementDao.getMaxIssueByGame(gameCode);
	}

}
