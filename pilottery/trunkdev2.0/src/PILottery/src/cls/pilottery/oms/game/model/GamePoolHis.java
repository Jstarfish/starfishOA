package cls.pilottery.oms.game.model;

import java.util.Date;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.model.BaseEntity;
/**
 * 游戏奖池信息调整
 * 
 * ISS_GAME_POOL_ADJ
 */
public class GamePoolHis extends BaseEntity{

	private static final long serialVersionUID = 3182823959625503863L;

	private Long hisCode;		//历史序号
	private Short gameCode;		//游戏编码
	private Short poolCode;		//奖池编码
	private Long issueNumber;	//期次号
	private Integer poolAdjType;	//奖池变更类型（1、期次开奖滚入；2、弃奖滚入；3、调节基金自动拨入；4、调节基金手动拨入；5、发行费手动拨入；6、其他来源手动拨入；7、奖池初始化设置。）
	private Long changeAmount;		//变更金额
	private String adjReason;		//变更备注
	private Long poolAmountBefore;	//变更前奖池金额
	private Long poolAmountAfter;	//变更后奖池金额
	private Date adjTime;		//变更时间
	private String poolFlow;	//手工变更流水
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
	public Short getPoolCode() {
		return poolCode;
	}
	public void setPoolCode(Short poolCode) {
		this.poolCode = poolCode;
	}
	public Long getIssueNumber() {
		return issueNumber;
	}
	public void setIssueNumber(Long issueNumber) {
		this.issueNumber = issueNumber;
	}
	public Integer getPoolAdjType() {
		return poolAdjType;
	}
	public void setPoolAdjType(Integer poolAdjType) {
		this.poolAdjType = poolAdjType;
	}
	public Long getChangeAmount() {
		return changeAmount;
	}
	public void setChangeAmount(Long changeAmount) {
		this.changeAmount = changeAmount;
	}
	public String getAdjReason() {
		return adjReason;
	}
	public void setAdjReason(String adjReason) {
		Map map = null;
		try {
			map = JSONObject.parseObject(adjReason,Map.class);
			adjReason = (String)map.get("en");
		} catch (Exception e) {
			
		} finally{
			this.adjReason = adjReason;
		}
	}
	public Long getPoolAmountBefore() {
		return poolAmountBefore;
	}
	public void setPoolAmountBefore(Long poolAmountBefore) {
		this.poolAmountBefore = poolAmountBefore;
	}
	public Long getPoolAmountAfter() {
		return poolAmountAfter;
	}
	public void setPoolAmountAfter(Long poolAmountAfter) {
		this.poolAmountAfter = poolAmountAfter;
	}
	public Date getAdjTime() {
		return adjTime;
	}
	public void setAdjTime(Date adjTime) {
		this.adjTime = adjTime;
	}
	public String getPoolFlow() {
		return poolFlow;
	}
	public void setPoolFlow(String poolFlow) {
		this.poolFlow = poolFlow;
	}
    
}
