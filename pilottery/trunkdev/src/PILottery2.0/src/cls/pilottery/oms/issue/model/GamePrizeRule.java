package cls.pilottery.oms.issue.model;

import java.util.Date;
import java.util.List;

import cls.pilottery.common.model.BaseEntity;
/**
 *  游戏奖级规则(GP_PRIZE_RULE)
 *  
 *  @author Woo
 */
public class GamePrizeRule extends BaseEntity {

	private static final long serialVersionUID = 2339424433413007595L;

	private Long hisPrizeCode;	//HIS_PRIZE_CODE 历史编号
	private Date hisModifyDate;	//HIS_MODIFY_DATE修改时间
	private Short gameCode;		//GAME_CODE		  游戏编码
	private Short pruleLevel;	//PRULE_LEVEL	  奖等
	private String pruleName;	//PRULE_NAME	  奖级名称
	private String pruleDesc;	//PRULE_DESC	  描述
	private Long levelPrize;	//LEVEL_PRIZE	  金额
	
	private List<GamePrizeRule> list ;

	public Long getHisPrizeCode() {
		return hisPrizeCode;
	}

	public void setHisPrizeCode(Long hisPrizeCode) {
		this.hisPrizeCode = hisPrizeCode;
	}

	public Date getHisModifyDate() {
		return hisModifyDate;
	}

	public void setHisModifyDate(Date hisModifyDate) {
		this.hisModifyDate = hisModifyDate;
	}

	public Short getGameCode() {
		return gameCode;
	}

	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
	}

	public Short getPruleLevel() {
		return pruleLevel;
	}

	public void setPruleLevel(Short pruleLevel) {
		this.pruleLevel = pruleLevel;
	}

	public String getPruleName() {
		return pruleName;
	}

	public void setPruleName(String pruleName) {
		this.pruleName = pruleName;
	}

	public String getPruleDesc() {
		return pruleDesc;
	}

	public void setPruleDesc(String pruleDesc) {
		this.pruleDesc = pruleDesc;
	}

	public Long getLevelPrize() {
		return levelPrize;
	}

	public void setLevelPrize(Long levelPrize) {
		this.levelPrize = levelPrize;
	}

	public List<GamePrizeRule> getList() {
		return list;
	}

	public void setList(List<GamePrizeRule> list) {
		this.list = list;
	}
	
}
