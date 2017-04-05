package cls.pilottery.oms.game.form;

import java.util.List;

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

public class GameManagementForm {

	private Short styleId;
	private GameInfo gameInfo;
	private GamePolicyParam gamePolicyParam;
	private GameParameterControlView controlParameter;	//游戏控制参数
	private GameParameterNormalView normalRuleParameter;//普通规则参数
	private GameParameterDynamic gameParameterDynamic;
	private GameParameterHistory gameParameterHistory;
	private List<GameRule> gameRuleList;
	private List<GamePrizeRule> gamePrizeRuleList;
	private List<GameWinRule> gameWinRuleList;
	private GameIssue gameIssue;
	private GamePool gamePool;
	private GamePoolAdj gamePoolAdj;
	private GamePoolHis gamePoolHis;
	private Long beginIssue;
	
	private String str_adjTime1;
	private String str_adjTime2;
	
	//系统参数
	private List<SystemParameter> sysParamList;
	private SystemParameter sysParam;
	private String str_sysParamValue0;
	private String str_sysParamValue1;
	private String str_sysParamValue2;
	private String str_sysParamValue3;
	private String str_sysParamValue4;
	private String str_sysParamValue5;
	private String str_sysParamValue6;
	private String str_sysParamValue7;
	private String strP;	//存储过程传入参数
	
	//算奖参数
	private String isSpecial; //天天赢开启特殊奖级
	private String fdbd;      //七龙星浮动保底
	private String fdfd;      //七龙星浮动封顶
	private String fdmin;     //七龙星抹零余额
	
	public void setStyleId(Short styleId) {
		this.styleId = styleId;
	}
	public Short getStyleId() {
		return styleId;
	}
	
	public GameInfo getGameInfo() {
		if(gameInfo == null)
			gameInfo = new GameInfo();
		return gameInfo;
	}
	public void setGameInfo(GameInfo gameInfo) {
		this.gameInfo = gameInfo;
	}
	
	public GamePolicyParam getGamePolicyParam() {
		return gamePolicyParam;
	}
	public void setGamePolicyParam(GamePolicyParam gamePolicyParam) {
		this.gamePolicyParam = gamePolicyParam;
	}
	
	public GameParameterControlView getControlParameter() {
		if(controlParameter == null)
			controlParameter = new GameParameterControlView();
		return controlParameter;
	}
	public void setControlParameter(GameParameterControlView controlParameter) {
		this.controlParameter = controlParameter;
	}
	
	public GameParameterNormalView getNormalRuleParameter() {
		if(normalRuleParameter == null)
			normalRuleParameter = new GameParameterNormalView();
		return normalRuleParameter;
	}
	public void setNormalRuleParameter(GameParameterNormalView normalRuleParameter) {
		this.normalRuleParameter = normalRuleParameter;
	}
	
	public GameParameterDynamic getGameParameterDynamic() {
		if(gameParameterDynamic == null)
			gameParameterDynamic = new GameParameterDynamic();
		return gameParameterDynamic;
	}

	public void setGameParameterDynamic(GameParameterDynamic gameParameterDynamic) {
		this.gameParameterDynamic = gameParameterDynamic;
	}
	
	public GameParameterHistory getGameParameterHistory() {
		if(gameParameterHistory == null)
			gameParameterHistory = new GameParameterHistory();
		return gameParameterHistory;
	}
	public void setGameParameterHistory(GameParameterHistory gameParameterHistory) {
		this.gameParameterHistory = gameParameterHistory;
	}
	
	public List<GameRule> getGameRuleList() {
		return gameRuleList;
	}
	public void setGameRuleList(List<GameRule> gameRuleList) {
		this.gameRuleList = gameRuleList;
	}
	
	public List<GamePrizeRule> getGamePrizeRuleList() {
		return gamePrizeRuleList;
	}
	public void setGamePrizeRuleList(List<GamePrizeRule> gamePrizeRuleList) {
		this.gamePrizeRuleList = gamePrizeRuleList;
	}
	
	public List<GameWinRule> getGameWinRuleList() {
		return gameWinRuleList;
	}
	public void setGameWinRuleList(List<GameWinRule> gameWinRuleList) {
		this.gameWinRuleList = gameWinRuleList;
	}
	
	public GameIssue getGameIssue() {
		if(gameIssue == null)
			gameIssue = new GameIssue();
		return gameIssue;
	}

	public void setGameIssue(GameIssue gameIssue) {
		this.gameIssue = gameIssue;
	}
	
	public GamePool getGamePool() {
		if(gamePool == null)
			gamePool = new GamePool();
		return gamePool;
	}
	public void setGamePool(GamePool gamePool) {
		this.gamePool = gamePool;
	}
	
	public GamePoolAdj getGamePoolAdj() {
		if(gamePoolAdj == null)
			gamePoolAdj = new GamePoolAdj();
		return gamePoolAdj;
	}

	public void setGamePoolAdj(GamePoolAdj gamePoolAdj) {
		this.gamePoolAdj = gamePoolAdj;
	}
	
	public GamePoolHis getGamePoolHis() {
		if (gamePoolHis == null)
			gamePoolHis = new GamePoolHis();
		return gamePoolHis;
	}
	public void setGamePoolHis(GamePoolHis gamePoolHis) {
		this.gamePoolHis = gamePoolHis;
	}
	
	public Long getBeginIssue() {
		return beginIssue;
	}
	public void setBeginIssue(Long beginIssue) {
		this.beginIssue = beginIssue;
	}
	
	public String getStr_sysParamValue0() {
		return str_sysParamValue0;
	}

	public void setStr_sysParamValue0(String str_sysParamValue0) {
		this.str_sysParamValue0 = str_sysParamValue0;
	}

	public String getStr_sysParamValue1() {
		return str_sysParamValue1;
	}
	public void setStr_sysParamValue1(String str_sysParamValue1) {
		this.str_sysParamValue1 = str_sysParamValue1;
	}

	public String getStr_sysParamValue2() {
		return str_sysParamValue2;
	}
	public void setStr_sysParamValue2(String str_sysParamValue2) {
		this.str_sysParamValue2 = str_sysParamValue2;
	}

	public String getStr_sysParamValue3() {
		return str_sysParamValue3;
	}
	public void setStr_sysParamValue3(String str_sysParamValue3) {
		this.str_sysParamValue3 = str_sysParamValue3;
	}

	public String getStr_sysParamValue4() {
		return str_sysParamValue4;
	}
	public void setStr_sysParamValue4(String str_sysParamValue4) {
		this.str_sysParamValue4 = str_sysParamValue4;
	}

	public String getStr_sysParamValue5() {
		return str_sysParamValue5;
	}
	public void setStr_sysParamValue5(String str_sysParamValue5) {
		this.str_sysParamValue5 = str_sysParamValue5;
	}

	public String getStr_sysParamValue6() {
		return str_sysParamValue6;
	}
	public void setStr_sysParamValue6(String str_sysParamValue6) {
		this.str_sysParamValue6 = str_sysParamValue6;
	}

	public String getStr_sysParamValue7() {
		return str_sysParamValue7;
	}
	public void setStr_sysParamValue7(String str_sysParamValue7) {
		this.str_sysParamValue7 = str_sysParamValue7;
	}
	
	public List<SystemParameter> getSysParamList() {
		return sysParamList;
	}
	public void setSysParamList(List<SystemParameter> sysParamList) {
		this.sysParamList = sysParamList;
	}
	
	public String getStr_adjTime1() {
		return str_adjTime1;
	}
	public void setStr_adjTime1(String str_adjTime1) {
		this.str_adjTime1 = str_adjTime1;
	}

	public String getStr_adjTime2() {
		return str_adjTime2;
	}
	public void setStr_adjTime2(String str_adjTime2) {
		this.str_adjTime2 = str_adjTime2;
	}
	
	public SystemParameter getSysParam() {
		if(sysParam == null)
			sysParam = new SystemParameter();
		return sysParam;
	}
	public void setSysParam(SystemParameter sysParam) {
		this.sysParam = sysParam;
	}
	
	public String getStrP() {
		return strP;
	}
	public void setStrP(String strP) {
		this.strP = strP;
	}
	
	public String getIsSpecial() {
		return isSpecial;
	}
	public void setIsSpecial(String isSpecial) {
		this.isSpecial = isSpecial;
	}
	
	public String getFdbd() {
		return fdbd;
	}
	public void setFdbd(String fdbd) {
		this.fdbd = fdbd;
	}
	
	public String getFdfd() {
		return fdfd;
	}
	public void setFdfd(String fdfd) {
		this.fdfd = fdfd;
	}
	
	public String getFdmin() {
		return fdmin;
	}
	public void setFdmin(String fdmin) {
		this.fdmin = fdmin;
	}
}
