package cls.pilottery.web.report.model;

import java.io.Serializable;

public class InventoryDaliyReportVo implements Serializable{
	
	  
	private static final long serialVersionUID = 1L;
	private String calcDate;
	private String marketAdmin;
	private String planName;
	private Long  openInv;//期初库存
	private Long   closeInv;//期末库存
	private Long  gotTickets;//收货数量
	private Long  saledTickets;//销售数量
	private Long  canceledTickets;//退货数量
	private Long  returnTickets;//还货数量
	private Long brokenTickets;//损毁数量
	public String getCalcDate() {
		return calcDate;
	}
	public void setCalcDate(String calcDate) {
		this.calcDate = calcDate;
	}
	public String getMarketAdmin() {
		return marketAdmin;
	}
	public void setMarketAdmin(String marketAdmin) {
		this.marketAdmin = marketAdmin;
	}
	public String getPlanName() {
		return planName;
	}
	public void setPlanName(String planName) {
		this.planName = planName;
	}
	public Long getOpenInv() {
		return openInv;
	}
	public void setOpenInv(Long openInv) {
		this.openInv = openInv;
	}
	public Long getCloseInv() {
		return closeInv;
	}
	public void setCloseInv(Long closeInv) {
		this.closeInv = closeInv;
	}
	public Long getGotTickets() {
		return gotTickets;
	}
	public void setGotTickets(Long gotTickets) {
		this.gotTickets = gotTickets;
	}
	public Long getSaledTickets() {
		return saledTickets;
	}
	public void setSaledTickets(Long saledTickets) {
		this.saledTickets = saledTickets;
	}
	public Long getCanceledTickets() {
		return canceledTickets;
	}
	public void setCanceledTickets(Long canceledTickets) {
		this.canceledTickets = canceledTickets;
	}
	public Long getReturnTickets() {
		return returnTickets;
	}
	public void setReturnTickets(Long returnTickets) {
		this.returnTickets = returnTickets;
	}
	public Long getBrokenTickets() {
		return brokenTickets;
	}
	public void setBrokenTickets(Long brokenTickets) {
		this.brokenTickets = brokenTickets;
	}
	
}
