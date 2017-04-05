package cls.pilottery.oms.game.service.impl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.common.utils.DBConnectUtil;
import cls.pilottery.oms.game.dao.GameManagementDao;
import cls.pilottery.oms.game.form.GameManagementForm;
import cls.pilottery.oms.game.model.GameDrawDevice;
import cls.pilottery.oms.game.model.GameInfo;
import cls.pilottery.oms.game.model.GameIssue;
import cls.pilottery.oms.game.model.GameParameterControlView;
import cls.pilottery.oms.game.model.GameParameterDynamic;
import cls.pilottery.oms.game.model.GameParameterHistory;
import cls.pilottery.oms.game.model.GameParameterNormalView;
import cls.pilottery.oms.game.model.GamePolicyParam;
import cls.pilottery.oms.game.model.GamePool;
import cls.pilottery.oms.game.model.GamePoolAdj;
import cls.pilottery.oms.game.model.GamePoolHis;
import cls.pilottery.oms.game.model.GamePrizeRule;
import cls.pilottery.oms.game.model.GameRule;
import cls.pilottery.oms.game.model.GameWinRule;
import cls.pilottery.oms.game.model.SystemParameter;
import cls.pilottery.oms.game.service.GameManagementService;
import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

@Service
public class GameManagementServiceImpl implements GameManagementService {

	@Autowired
	private GameManagementDao gameManagementDao;
	
	public List<GameInfo> getGameInfo() {
		return gameManagementDao.getGameInfo();
	}
	
	public GameInfo getGameInfoByCode(Short code) {
		return gameManagementDao.getGameInfoByCode(code);
	}
	
	public void updateGameInfo(GameInfo gameInfo) {
		gameManagementDao.updateGameInfo(gameInfo);
	}
	
	public GamePolicyParam getPolicyParamByCode(Short gameCode) {
		return gameManagementDao.getPolicyParamByCode(gameCode);
	}
	
	public void updateGamePolicyParam(GamePolicyParam gamePolicyParam) {
		gameManagementDao.updateGamePolicyParam(gamePolicyParam);
	}
	
	public Integer getDeviceListCount(GameDrawDevice device) {
		return gameManagementDao.getDeviceListCount(device);
	}
	
	public List<GameDrawDevice> getDeviceList(GameDrawDevice device) {
		return gameManagementDao.getDeviceList(device);
	}
	
	public GameParameterNormalView getNormalRuleView(Short gameCode) {
		return gameManagementDao.getNormalRuleView(gameCode);
	}
	
	public GameParameterHistory getGameParameterHistory(Short gameCode) {
		return gameManagementDao.getGameParameterHistory(gameCode);
	}
	
	public GameParameterDynamic getGameParameterDynamicByCode(Short gameCode) {
		return gameManagementDao.getGameParameterDynamicByCode(gameCode);
	}
	
	public GameParameterControlView getControlView(Short gameCode) {
		return gameManagementDao.getControlView(gameCode);
	}
	
	public void updateControlParameter1(GameParameterDynamic gameParameter) {
		gameManagementDao.updateControlParameter1(gameParameter);
	}
	
	public void updateControlParameter2(GameParameterDynamic gameParameter) {
		gameManagementDao.updateControlParameter2(gameParameter);
	}
	
	public void updateGameParameterNormalView(GameParameterNormalView param) {
		gameManagementDao.updateGameParameterNormalView(param);
	}
	
	public void updateControlParameter(GameParameterControlView param) {
		gameManagementDao.updateControlParameter_S(param);
		gameManagementDao.updateControlParameter_D(param);
	}
	
	public Integer getPoolAdjListCount(GameManagementForm gameManagementForm) {
		return gameManagementDao.getPoolAdjListCount(gameManagementForm);
	}
	
	public List<GamePoolHis> getPoolAdjList(GameManagementForm gameManagementForm) {
		return gameManagementDao.getPoolAdjList(gameManagementForm);
	}
	
	public void insertPoolAdj(GamePoolAdj gamePoolAdj) {
		gameManagementDao.insertPoolAdj(gamePoolAdj);
	}
	
	public Map<Short, String> getGameInfoMap() {
		Map<Short, String> map = new HashMap<Short, String>();
		List<GameInfo> infoList = getGameInfo();
		for (Iterator<GameInfo> it = infoList.iterator(); it.hasNext();) {
			GameInfo gi = (GameInfo) it.next();
			map.put(gi.getGameCode(), gi.getShortName());
		}
		return map;
	}
	
	public List<GameRule> getGameRuleByCode(Short gameCode) {
		return gameManagementDao.getGameRuleByCode(gameCode);
	}
	
	public List<GamePrizeRule> getGamePrizeRuleByCode(Short gameCode) {
		return gameManagementDao.getGamePrizeRuleByCode(gameCode);
	}
	
	public void updateGameRule(List<GameRule> l) {
		Iterator<GameRule> it = l.iterator();
		while (it.hasNext()) {
			gameManagementDao.updateGameRule(it.next());
		}
	}
	
	public String updateGamePrizeRule(List<GamePrizeRule> l) {
		Connection conn = null;
		CallableStatement stmt = null;
		int resultCode = 0;
		String resultMesg = "";
		try {
			conn = DBConnectUtil.getConnection();
			conn.setAutoCommit(false);
			StructDescriptor sd = new StructDescriptor("TYPE_GAME_PRIZE_INFO",
					conn);
			STRUCT[] result = new STRUCT[l.size()];
			for (int index = 0; index < l.size(); index++) {
				GamePrizeRule gpr = l.get(index);
				Object[] o = new Object[5];
				o[0] = (int) gpr.getGameCode(); // 游戏编号
				o[1] = (int) gpr.getPruleLevel(); // 奖等
				o[2] = gpr.getPruleName(); // 奖级名称
				o[3] = gpr.getPruleDesc(); // 奖级描述
				o[4] = gpr.getLevelPrize(); // 奖金
				result[index] = new STRUCT(sd, conn, o);
			}
			ArrayDescriptor orc_table = ArrayDescriptor.createDescriptor(
					"TYPE_GAME_PRIZE_LIST", conn);
			ARRAY oracle_array = new ARRAY(orc_table, conn, result);

			stmt = conn
					.prepareCall("{ call p_om_game_prize_batchinsert(?,?,?) }");
			stmt.setObject(1, oracle_array);
			stmt.registerOutParameter(2, OracleTypes.NUMBER);
			stmt.registerOutParameter(3, OracleTypes.VARCHAR);
			stmt.execute();

			resultCode = stmt.getInt(2);
			resultMesg = stmt.getString(3);
			System.out.println("return code: " + resultCode);
			System.out.println("return mesg: " + resultMesg);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBConnectUtil.close(stmt);
			DBConnectUtil.close(conn);
		}
		return resultCode + "#" + resultMesg;
	}
	
	public Long getMaxBaseCode(Short gameCode) {
		return gameManagementDao.getMaxBaseCode(gameCode);
	}

	public Long getMaxPolicyCode(Short gameCode) {
		return gameManagementDao.getMaxPolicyCode(gameCode);
	}

	public Long getMaxRuleCode(Short gameCode) {
		return gameManagementDao.getMaxRuleCode(gameCode);
	}

	public Long getMaxPrizeCode(Short gameCode) {
		return gameManagementDao.getMaxPrizeCode(gameCode);
	}

	public Long getMaxWinCode(Short gameCode) {
		return gameManagementDao.getMaxWinCode(gameCode);
	}
	
	public List<GamePrizeRule> getGamePrizeRuleByKey(GamePrizeRule vo) {
		return gameManagementDao.getGamePrizeRuleByKey(vo);
	}
	
	public void updateRiskParam(GameParameterHistory gph) {
		gameManagementDao.updateRiskParam(gph);
	}
	
	public List<GameWinRule> getGameWinRuleByCode(Short gameCode) {
		return gameManagementDao.getGameWinRuleByCode(gameCode);
	}
	
	public void changeParamStatus(GameParameterDynamic gp) {
		gameManagementDao.changeParamStatus(gp);
	}
	
	public List<GameDrawDevice> getDeviceListByCode(Short gameCode) {
		return gameManagementDao.getDeviceListByCode(gameCode);
	}
	
	public GamePool getGamePool(Short gameCode) {
		return gameManagementDao.getGamePool(gameCode);
	}
	
	public List<SystemParameter> getSystemParameterList() {
		return gameManagementDao.getSystemParameterList();
	}
	
	public void updateSystemParameter(GameManagementForm gameManagementForm) {
		gameManagementDao.updateSystemParameter(gameManagementForm);
	}
	
	public void updateCalcWinningCode(GameParameterDynamic dy) {
		gameManagementDao.updateCalcWinningCode(dy);
	}
	
	public GameParameterHistory getRiskParam(Short gameCode, Long issueNumber) {
		return gameManagementDao.getRiskParam(gameCode,issueNumber);
	}

	public GamePolicyParam getPolicyParam(Short gameCode, Long issueNumber) {
		return gameManagementDao.getPolicyParam(gameCode,issueNumber);
	}
	
	//期次相关
	public GameIssue getCurrentIssue(GameIssue gameIssue) {
		return gameManagementDao.getCurrentIssue(gameIssue);
	}
	
	public Integer getGameIssueListCount(GameManagementForm gameManagementForm) {
		return gameManagementDao.getGameIssueListCount(gameManagementForm);
	}

	public List<GameIssue> getGameIssueList(GameManagementForm gameManagementForm) {
		return gameManagementDao.getGameIssueList(gameManagementForm);
	}
	
	public boolean checkIssueExist(Short gameCode) {
		return gameManagementDao.checkIssueExist(gameCode) > 0;
	}
}
