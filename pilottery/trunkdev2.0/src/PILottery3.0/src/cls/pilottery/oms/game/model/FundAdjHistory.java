package cls.pilottery.oms.game.model;

import java.util.Date;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.model.BaseEntity;
/**
 *  游戏调节基金历史（ADJ_GAME_HIS）
 * @author Woo
 */
public class FundAdjHistory extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5444284172494162488L;

	private Long hisCode;
	private Short gameCode;
	private Long issueNumber;
	private Integer adjChangeType;
	private Long adjAmount;
	private Long adjAmountBefore;
	private Long adjAmountAfter;
	private Date adjTime;
	private String adjReason;
	private String adjFlow;
	
	public Long getHisCode() {
		return hisCode;
	}
	public void setHisCode(Long hisCode) {
		this.hisCode = hisCode;
	}
	public Short getGameCode() {
		return gameCode;
	}
	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
	}
	public Long getIssueNumber() {
		return issueNumber;
	}
	public void setIssueNumber(Long issueNumber) {
		this.issueNumber = issueNumber;
	}
	public Integer getAdjChangeType() {
		return adjChangeType;
	}
	public void setAdjChangeType(Integer adjChangeType) {
		this.adjChangeType = adjChangeType;
	}
	public Long getAdjAmount() {
		return adjAmount;
	}
	public void setAdjAmount(Long adjAmount) {
		this.adjAmount = adjAmount;
	}
	public Long getAdjAmountBefore() {
		return adjAmountBefore;
	}
	public void setAdjAmountBefore(Long adjAmountBefore) {
		this.adjAmountBefore = adjAmountBefore;
	}
	public Long getAdjAmountAfter() {
		return adjAmountAfter;
	}
	public void setAdjAmountAfter(Long adjAmountAfter) {
		this.adjAmountAfter = adjAmountAfter;
	}
	public Date getAdjTime() {
		return adjTime;
	}
	public void setAdjTime(Date adjTime) {
		this.adjTime = adjTime;
	}
	public String getAdjReason() {
		return adjReason;
	}
	public void setAdjReason(String adjReason) {
		Map map = null;
		try {
			String[] strs = adjReason.split("}");
			if(strs.length>1){
				map = JSONObject.parseObject(strs[0]+"}",Map.class);
				adjReason = (String)map.get("en")+strs[1];
			}else{
				map = JSONObject.parseObject(adjReason,Map.class);
				adjReason = (String)map.get("en");
			}
			
		} catch (Exception e) {
			
		} finally{
			this.adjReason = adjReason;
		}
	}
	public String getAdjFlow() {
		return adjFlow;
	}
	public void setAdjFlow(String adjFlow) {
		this.adjFlow = adjFlow;
	}
	
}
