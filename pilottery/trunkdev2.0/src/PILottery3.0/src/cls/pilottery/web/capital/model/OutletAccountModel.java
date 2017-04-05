package cls.pilottery.web.capital.model;

import java.io.Serializable;
import java.util.List;

import cls.pilottery.web.goodsreceipts.model.GamePlans;

public class OutletAccountModel implements Serializable {
	private static final long serialVersionUID = 4433591652876504685L;
	private String agencyCode;
	private Long creditLimit;
	private String agencyName;
	private String saleComm;
	private String payComm;
	private String planName;
	private String planCode;
	private long balance;
	
	//游戏方案
	private List<GamePlans> gamePlanList;
	
	
	public List<GamePlans> getGamePlanList() {
		return gamePlanList;
	}
	public void setGamePlanList(List<GamePlans> gamePlanList) {
		this.gamePlanList = gamePlanList;
	}
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
	public Long getCreditLimit() {
		return creditLimit;
	}
	public void setCreditLimit(Long creditLimit) {
		this.creditLimit = creditLimit;
	}
	public String getAgencyName() {
		return agencyName;
	}
	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}
	public String getSaleComm() {
		return saleComm;
	}
	public void setSaleComm(String saleComm) {
		this.saleComm = saleComm;
	}
	public String getPayComm() {
		return payComm;
	}
	public void setPayComm(String payComm) {
		this.payComm = payComm;
	}
	public String getPlanName() {
		return planName;
	}
	public void setPlanName(String planName) {
		this.planName = planName;
	}
	public String getPlanCode() {
		return planCode;
	}
	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}
	public long getBalance() {
		return balance;
	}
	public void setBalance(long balance) {
		this.balance = balance;
	}
}
