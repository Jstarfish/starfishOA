package cls.pilottery.web.report.model;

import java.io.Serializable;

public class OutletFundVO implements Serializable {
	private static final long serialVersionUID = -5547754549772243177L;
	private String balanceDate;
	private String agencyCode;
	private double initialBalance;
	private double topUp;
	private double withdraw;
	private double saleAmount;
	private double saleComm;
	private double payout;
	private double payoutComm;
	private double returnAmount;
	private double returnComm;
	private double income;
	private double finalBalance;
	public String getBalanceDate() {
		return balanceDate;
	}
	public void setBalanceDate(String balanceDate) {
		this.balanceDate = balanceDate;
	}
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
	public double getInitialBalance() {
		return initialBalance;
	}
	public void setInitialBalance(double initialBalance) {
		this.initialBalance = initialBalance;
	}
	public double getTopUp() {
		return topUp;
	}
	public void setTopUp(double topUp) {
		this.topUp = topUp;
	}
	public double getWithdraw() {
		return withdraw;
	}
	public void setWithdraw(double withdraw) {
		this.withdraw = withdraw;
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
	public double getIncome() {
		return income;
	}
	public void setIncome(double income) {
		this.income = income;
	}
	public double getFinalBalance() {
		return finalBalance;
	}
	public void setFinalBalance(double finalBalance) {
		this.finalBalance = finalBalance;
	}
}
