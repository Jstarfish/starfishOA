package cls.pilottery.oms.business.model.areamodel;

import java.io.Serializable;

public class OMSAreaAuth implements Serializable {

	private static final long serialVersionUID = 5733300638263728611L;
	private String  areaCode;                  //区域编码
	private Integer gameCode;                  //游戏CODE
	private String  gameName;                  //游戏缩写
	private Integer gameType = 1;              //游戏类型（1=基诺,2=乐透,3=数字）
	private Integer enabled = 2;               //是否可用（1=可用，2=不可用）
	private Long    payCommissionRate = 0L;    //兑奖佣金比例（千分位）
	private Long    saleCommissionRate = 0L;   //销售佣金比例（千分位）
	private Integer allowPay = 0;              //是否可兑奖（1=是；0=否）
	private Integer allowSale = 0;             //是否允许销售（1=是；0=否）
	private Integer allowCancel = 0;           //是否允许退票（1=是；0=否）
	
	public String getAreaCode() {
		return areaCode;
	}
	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}
	public Integer getGameCode() {
		return gameCode;
	}
	public void setGameCode(Integer gameCode) {
		this.gameCode = gameCode;
	}
	public String getGameName() {
		return gameName;
	}
	public void setGameName(String gameName) {
		this.gameName = gameName;
	}
	public Integer getGameType() {
		return gameType;
	}
	public void setGameType(Integer gameType) {
		this.gameType = gameType;
	}
	public Integer getEnabled() {
		return enabled;
	}
	public void setEnabled(Integer enabled) {
		this.enabled = enabled;
	}
	public Long getPayCommissionRate() {
		return payCommissionRate;
	}
	public void setPayCommissionRate(Long payCommissionRate) {
		this.payCommissionRate = payCommissionRate;
	}
	public Long getSaleCommissionRate() {
		return saleCommissionRate;
	}
	public void setSaleCommissionRate(Long saleCommissionRate) {
		this.saleCommissionRate = saleCommissionRate;
	}
	public Integer getAllowPay() {
		return allowPay;
	}
	public void setAllowPay(Integer allowPay) {
		this.allowPay = allowPay;
	}
	public Integer getAllowSale() {
		return allowSale;
	}
	public void setAllowSale(Integer allowSale) {
		this.allowSale = allowSale;
	}
	public Integer getAllowCancel() {
		return allowCancel;
	}
	public void setAllowCancel(Integer allowCancel) {
		this.allowCancel = allowCancel;
	}
}
