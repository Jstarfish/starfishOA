package cls.pilottery.oms.issue.model;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;
/**
 *  游戏中奖规则(GP_WIN_RULE)
 * 
 *	@author Woo
 */
public class GameWinRule extends BaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = -8038083750791748815L;

	private Long hisWinCode;  //历史编号
	private Date hisModifyDate;//修改时间
	private Short gameCode;   //游戏编码
	private Long wRuleCode;   //中奖规则
	private String wRuleName; //规则名称
	private String wRuleDesc; //规则描述
	
	public Long getHisWinCode() {
		return hisWinCode;
	}
	public void setHisWinCode(Long hisWinCode) {
		this.hisWinCode = hisWinCode;
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
	public Long getwRuleCode() {
		return wRuleCode;
	}
	public void setwRuleCode(Long wRuleCode) {
		this.wRuleCode = wRuleCode;
	}
	public String getwRuleName() {
		return wRuleName;
	}
	public void setwRuleName(String wRuleName) {
		this.wRuleName = wRuleName;
	}
	public String getwRuleDesc() {
		return wRuleDesc;
	}
	public void setwRuleDesc(String wRuleDesc) {
		this.wRuleDesc = wRuleDesc;
	}

}
