package cls.pilottery.oms.issue.model;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;
/**
 *  游戏玩法规则(GP_RULE)
 * 
 *	@author Woo
 */
public class GameRule extends BaseEntity {

	private static final long serialVersionUID = 4763920678704072462L;

	private Long hisRuleCode;	//HIS_RULE_CODE	历史编号
	private Date hisModifyDate;	//HIS_MODIFY_DATE 修改时间
	private Short gameCode;		//GAME_CODE		游戏编码
	private Short ruleCode;		//RULE_CODE		玩法编码
	private String ruleName;	//RULE_NAME		玩法名称
	private String ruleDesc;	//RULE_DESC		玩法描述（包括投注方式等内容）
	private Short ruleEnable;	//RULE_ENABLE	是否启用（0-禁用，1-启用）
	
	public Long getHisRuleCode() {
		return hisRuleCode;
	}
	public void setHisRuleCode(Long hisRuleCode) {
		this.hisRuleCode = hisRuleCode;
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
	public Short getRuleCode() {
		return ruleCode;
	}
	public void setRuleCode(Short ruleCode) {
		this.ruleCode = ruleCode;
	}
	public String getRuleName() {
		return ruleName;
	}
	public void setRuleName(String ruleName) {
		this.ruleName = ruleName;
	}
	public String getRuleDesc() {
		return ruleDesc;
	}
	public void setRuleDesc(String ruleDesc) {
		this.ruleDesc = ruleDesc;
	}
	public Short getRuleEnable() {
		return ruleEnable;
	}
	public void setRuleEnable(Short ruleEnable) {
		this.ruleEnable = ruleEnable;
	}
	
}
