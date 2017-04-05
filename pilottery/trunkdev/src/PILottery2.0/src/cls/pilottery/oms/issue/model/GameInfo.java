package cls.pilottery.oms.issue.model;

import cls.pilottery.common.model.BaseEntity;
/**
 *  游戏基本参数 (INF_GAMES)
 *  
 *  @author Woo
 */
public class GameInfo extends BaseEntity {

	private static final long serialVersionUID = 6431097476186602876L;

	private Short gameCode;		 	//游戏编码
	private String gameMark;	 	//游戏标识
	private String fullName;		//游戏全称
	private String shortName;		//游戏简称
	private Long basicType;			//游戏类型
	private String issuingOrganization;		//发行机构
	
	public Short getGameCode() {
		return gameCode;
	}
	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
	}
	public String getGameMark() {
		return gameMark;
	}
	public void setGameMark(String gameMark) {
		this.gameMark = gameMark;
	}
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	public String getShortName() {
		return shortName;
	}
	public void setShortName(String shortName) {
		this.shortName = shortName;
	}
	public Long getBasicType() {
		return basicType;
	}
	public void setBasicType(Long basicType) {
		this.basicType = basicType;
	}
	public String getIssuingOrganization() {
		return issuingOrganization;
	}
	public void setIssuingOrganization(String issuingOrganization) {
		this.issuingOrganization = issuingOrganization;
	}

}
