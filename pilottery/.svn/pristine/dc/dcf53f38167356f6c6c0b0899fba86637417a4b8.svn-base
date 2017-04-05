package cls.pilottery.oms.game.service;

import java.util.List;
import java.util.Map;

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

public interface GameManagementService {

	public List<GameInfo> getGameInfo();
	public GameInfo getGameInfoByCode(Short code);
	public void updateGameInfo(GameInfo gameInfo);
	
	public GamePolicyParam getPolicyParamByCode(Short code);
	public void updateGamePolicyParam(GamePolicyParam gamePolicyParam);
	
	public Integer getDeviceListCount(GameDrawDevice device);
	public List<GameDrawDevice> getDeviceList(GameDrawDevice device);
	
	public GameParameterNormalView getNormalRuleView(Short gameCode);
	public GameParameterHistory getGameParameterHistory(Short gameCode);
	public GameParameterDynamic getGameParameterDynamicByCode(Short gameCode);
	
	public GameParameterControlView getControlView(Short gameCode);
	public void updateControlParameter1(GameParameterDynamic gameParameter);
	public void updateControlParameter2(GameParameterDynamic gameParameter);
	public void updateGameParameterNormalView(GameParameterNormalView param);
	public void updateControlParameter(GameParameterControlView param);
	
	public Integer getPoolAdjListCount(GameManagementForm gameManagementForm);
	public List<GamePoolHis> getPoolAdjList(GameManagementForm gameManagementForm);
	public void insertPoolAdj(GamePoolAdj gamePoolAdj);
	
	public Map<Short, String> getGameInfoMap();
	
	public List<GameRule> getGameRuleByCode(Short gameCode);
	public List<GamePrizeRule> getGamePrizeRuleByCode(Short gameCode);
	public void updateGameRule(List<GameRule> l);
	public String updateGamePrizeRule(List<GamePrizeRule> l);
	
	public Long getMaxBaseCode(Short gameCode);
	public Long getMaxPolicyCode(Short gameCode);
	public Long getMaxRuleCode(Short gameCode);
	public Long getMaxPrizeCode(Short gameCode);
	public Long getMaxWinCode(Short gameCode);
	
	public List<GamePrizeRule> getGamePrizeRuleByKey(GamePrizeRule vo);
	public void updateRiskParam(GameParameterHistory gph);
	public List<GameWinRule> getGameWinRuleByCode(Short gameCode);
	public void changeParamStatus(GameParameterDynamic gp);
	
	public List<GameDrawDevice> getDeviceListByCode(Short gameCode);
	
	public GamePool getGamePool(Short gameCode);
	
	public List<SystemParameter> getSystemParameterList();
	public void updateSystemParameter(GameManagementForm gameManagementForm);
	
	public void updateCalcWinningCode(GameParameterDynamic dy);
	
	public GameParameterHistory getRiskParam(Short gameCode, Long issueNumber);
	public GamePolicyParam getPolicyParam(Short gameCode, Long issueNumber);
	
	//期次相关
	public GameIssue getCurrentIssue(GameIssue gameIssue);
	public Integer getGameIssueListCount(GameManagementForm gameManagementForm);
	public List<GameIssue> getGameIssueList(GameManagementForm gameManagementForm);
	public boolean checkIssueExist(Short gameCode);
}
