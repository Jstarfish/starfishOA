package cls.pilottery.web.report.model;

import java.io.Serializable;

public class NetSalesModel implements Serializable {

	private static final long serialVersionUID = 6873543128592431301L;

	private String showDate;
	private String institutionCode;
	private String institutionName;
	private double pilUSDSaleAmount;
	private double pilKHRSaleAmount;
	private double pilUSDReturnAmount;
	private double pilKHRReturnAmount;
	private double pilUSDNetSaleAmount;
	private double ctgUSDSaleAmount;
	private double ctgKHRSaleAmount;
	private double ctgUSDReturnAmount;
	private double ctgKHRReturnAmount;
	private double ctgUSDNetSaleAmount;
	private double netSaleAmount; // 总净销售额
	public String getShowDate() {
		return showDate;
	}
	public void setShowDate(String showDate) {
		this.showDate = showDate;
	}
	public String getInstitutionCode() {
		return institutionCode;
	}
	public void setInstitutionCode(String institutionCode) {
		this.institutionCode = institutionCode;
	}
	public String getInstitutionName() {
		return institutionName;
	}
	public void setInstitutionName(String institutionName) {
		this.institutionName = institutionName;
	}
	public double getPilUSDSaleAmount() {
		return pilUSDSaleAmount;
	}
	public void setPilUSDSaleAmount(double pilUSDSaleAmount) {
		this.pilUSDSaleAmount = pilUSDSaleAmount;
	}
	public double getPilKHRSaleAmount() {
		return pilKHRSaleAmount;
	}
	public void setPilKHRSaleAmount(double pilKHRSaleAmount) {
		this.pilKHRSaleAmount = pilKHRSaleAmount;
	}
	public double getPilUSDReturnAmount() {
		return pilUSDReturnAmount;
	}
	public void setPilUSDReturnAmount(double pilUSDReturnAmount) {
		this.pilUSDReturnAmount = pilUSDReturnAmount;
	}
	public double getPilKHRReturnAmount() {
		return pilKHRReturnAmount;
	}
	public void setPilKHRReturnAmount(double pilKHRReturnAmount) {
		this.pilKHRReturnAmount = pilKHRReturnAmount;
	}
	public double getPilUSDNetSaleAmount() {
		return pilUSDNetSaleAmount;
	}
	public void setPilUSDNetSaleAmount(double pilUSDNetSaleAmount) {
		this.pilUSDNetSaleAmount = pilUSDNetSaleAmount;
	}
	public double getCtgUSDSaleAmount() {
		return ctgUSDSaleAmount;
	}
	public void setCtgUSDSaleAmount(double ctgUSDSaleAmount) {
		this.ctgUSDSaleAmount = ctgUSDSaleAmount;
	}
	public double getCtgKHRSaleAmount() {
		return ctgKHRSaleAmount;
	}
	public void setCtgKHRSaleAmount(double ctgKHRSaleAmount) {
		this.ctgKHRSaleAmount = ctgKHRSaleAmount;
	}
	public double getCtgUSDReturnAmount() {
		return ctgUSDReturnAmount;
	}
	public void setCtgUSDReturnAmount(double ctgUSDReturnAmount) {
		this.ctgUSDReturnAmount = ctgUSDReturnAmount;
	}
	public double getCtgKHRReturnAmount() {
		return ctgKHRReturnAmount;
	}
	public void setCtgKHRReturnAmount(double ctgKHRReturnAmount) {
		this.ctgKHRReturnAmount = ctgKHRReturnAmount;
	}
	public double getCtgUSDNetSaleAmount() {
		return ctgUSDNetSaleAmount;
	}
	public void setCtgUSDNetSaleAmount(double ctgUSDNetSaleAmount) {
		this.ctgUSDNetSaleAmount = ctgUSDNetSaleAmount;
	}
	public double getNetSaleAmount() {
		return netSaleAmount;
	}
	public void setNetSaleAmount(double netSaleAmount) {
		this.netSaleAmount = netSaleAmount;
	}
}
