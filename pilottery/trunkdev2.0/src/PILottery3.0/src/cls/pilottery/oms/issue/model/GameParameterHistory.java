package cls.pilottery.oms.issue.model;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;
/**
 * 游戏历史参数(GP_HISTORY)
 * 
 * @author Woo
 */
public class GameParameterHistory extends BaseEntity{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -2971225398332533571L;
	
	private Long hisHisCode; 			//HIS_HIS_CODE				历史编号
	private Date hisModifyDate;			//HIS_MODIFY_DATE			修改时间
	private Short gameCode; 	  		//GAME_CODE					游戏编码
	private Long isOpenRisk;			//IS_OPEN_RISK				风控开关
	private String riskParam;			//RISK_PARAM				风控参数
	
	public Long getHisHisCode() {
		return hisHisCode;
	}
	public void setHisHisCode(Long hisHisCode) {
		this.hisHisCode = hisHisCode;
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
	public Long getIsOpenRisk() {
		return isOpenRisk;
	}
	public void setIsOpenRisk(Long isOpenRisk) {
		this.isOpenRisk = isOpenRisk;
	}
	public String getRiskParam() {
		return riskParam;
	}
	public void setRiskParam(String riskParam) {
		this.riskParam = riskParam;
	}

	
}
