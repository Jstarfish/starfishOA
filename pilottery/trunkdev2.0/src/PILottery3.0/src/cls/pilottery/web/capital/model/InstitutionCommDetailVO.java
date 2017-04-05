package cls.pilottery.web.capital.model;

import java.io.Serializable;

/*
 * For Institution Commision Detail
 */
public class InstitutionCommDetailVO implements Serializable {
	private static final long serialVersionUID = -755660150240434643L;
	private String orgCommFlow;
	private String orgFundFlow;
	private String agencyCode;
	private String agencyName;
	private String transDate;
	private double Amount;
	private double saleAmount;//agency sale 
	private double saleComm;//org sale comm
	private double payout;//agency pay
	private double payoutComm;//org pay comm
	private double returnAmount;//agency return
	private double returnComm;//org return comm
	private double agencySaleRate;
	private double orgSaleRate;
	private double agencyPayRate;
	private double orgPayRate;
	public String getOrgCommFlow() {
		return orgCommFlow;
	}
	public void setOrgCommFlow(String orgCommFlow) {
		this.orgCommFlow = orgCommFlow;
	}
	public String getOrgFundFlow() {
		return orgFundFlow;
	}
	public void setOrgFundFlow(String orgFundFlow) {
		this.orgFundFlow = orgFundFlow;
	}

	public String getTransDate() {
		return transDate;
	}
	public void setTransDate(String transDate) {
		this.transDate = transDate;
	}
	public double getAmount() {
		return Amount;
	}
	public void setAmount(double amount) {
		Amount = amount;
	}
	public double getSaleAmount() {
		return saleAmount;
	}
	public void setSaleAmount(double saleAmount) {
		this.saleAmount = saleAmount;
	}
	public double getSaleComm() {
		return saleComm;
	}
	public void setSaleComm(double saleComm) {
		this.saleComm = saleComm;
	}
	public double getPayout() {
		return payout;
	}
	public void setPayout(double payout) {
		this.payout = payout;
	}
	public double getPayoutComm() {
		return payoutComm;
	}
	public void setPayoutComm(double payoutComm) {
		this.payoutComm = payoutComm;
	}
	public double getReturnAmount() {
		return returnAmount;
	}
	public void setReturnAmount(double returnAmount) {
		this.returnAmount = returnAmount;
	}
	public double getReturnComm() {
		return returnComm;
	}
	public void setReturnComm(double returnComm) {
		this.returnComm = returnComm;
	}
	public double getAgencySaleRate() {
		return agencySaleRate;
	}
	public void setAgencySaleRate(double agencySaleRate) {
		this.agencySaleRate = agencySaleRate;
	}
	public double getOrgSaleRate() {
		return orgSaleRate;
	}
	public void setOrgSaleRate(double orgSaleRate) {
		this.orgSaleRate = orgSaleRate;
	}
	public double getAgencyPayRate() {
		return agencyPayRate;
	}
	public void setAgencyPayRate(double agencyPayRate) {
		this.agencyPayRate = agencyPayRate;
	}
	public double getOrgPayRate() {
		return orgPayRate;
	}
	public void setOrgPayRate(double orgPayRate) {
		this.orgPayRate = orgPayRate;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
	public String getAgencyName() {
		return agencyName;
	}
	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}
	
	
	

}
