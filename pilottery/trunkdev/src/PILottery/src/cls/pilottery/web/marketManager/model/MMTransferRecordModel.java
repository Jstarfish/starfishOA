package cls.pilottery.web.marketManager.model;

import java.io.Serializable;
import java.util.Date;

public class MMTransferRecordModel implements Serializable {
	private static final long serialVersionUID = -6646378134174957067L;

	private Date contractDate;
	private int dealType;
	private String outletCode;
	private String outletName;
	private double amount;
	private String marketManager;
	private String marketManagerName;
	private String contractNo; // 编码
	private String flowNo;

	public String getFlowNo() {
		return flowNo;
	}

	public void setFlowNo(String flowNo) {
		this.flowNo = flowNo;
	}

	public String getMarketManager() {
		return marketManager;
	}

	public void setMarketManager(String marketManager) {
		this.marketManager = marketManager;
	}

	public Date getContractDate() {
		return contractDate;
	}

	public void setContractDate(Date contractDate) {
		this.contractDate = contractDate;
	}

	public String getContractNo() {
		return contractNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}

	public int getDealType() {
		return dealType;
	}

	public void setDealType(int dealType) {
		this.dealType = dealType;
	}

	public String getOutletCode() {
		return outletCode;
	}

	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}

	public String getOutletName() {
		return outletName;
	}

	public void setOutletName(String outletName) {
		this.outletName = outletName;
	}

	public double getAmount() {
		return amount;
	}

	public void setAmount(double amount) {
		this.amount = amount;
	}

	public String getMarketManagerName() {
		return marketManagerName;
	}

	public void setMarketManagerName(String marketManagerName) {
		this.marketManagerName = marketManagerName;
	}

}
