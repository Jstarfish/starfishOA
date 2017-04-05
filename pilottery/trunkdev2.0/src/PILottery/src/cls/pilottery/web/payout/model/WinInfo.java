package cls.pilottery.web.payout.model;

import cls.pilottery.common.model.BaseEntity;

/*
 * 中奖查询返回奖级信息
 * add by dzg
 */
public class WinInfo extends BaseEntity {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4436566762761877199L;
	private String planCode;
	private String batchNo;
	private String packageCode;
	private String securityString;
	private int payLevel;//兑奖级别用于控制兑奖范围:兑奖级别（1=站点、2=分公司、3=总公司）
	private int winLevel;
	private int winResult;//票中奖结果信息
	private long amount;
	
	public WinInfo()
	{
		
	}
	
	
	public WinInfo(String planCode, String batchNo, String pkgCode, String securityString,int pleve) {
		super();
		this.planCode = planCode;
		this.batchNo = batchNo;
		this.packageCode = pkgCode;
		this.securityString = securityString;
		this.payLevel= pleve;
	}
	
	public String getPlanCode() {
		return planCode;
	}
	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}
	public String getBatchNo() {
		return batchNo;
	}
	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo;
	}
	public String getSecurityString() {
		return securityString;
	}
	public void setSecurityString(String securityString) {
		this.securityString = securityString;
	}
	public int getWinLevel() {
		return winLevel;
	}
	public void setWinLevel(int winLevel) {
		this.winLevel = winLevel;
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}


	public int getWinResult() {
		return winResult;
	}


	public void setWinResult(int winResult) {
		this.winResult = winResult;
	}


	public String getPackageCode() {
		return packageCode;
	}


	public void setPackageCode(String packageCode) {
		this.packageCode = packageCode;
	}


	public int getPayLevel() {
		return payLevel;
	}


	public void setPayLevel(int payLevel) {
		this.payLevel = payLevel;
	}

	@Override
	public String toString() {
		return "WinInfo [amount=" + amount + ", batchNo=" + batchNo
				+ ", packageCode=" + packageCode + ", payLevel=" + payLevel
				+ ", planCode=" + planCode + ", securityString="
				+ securityString + ", winLevel=" + winLevel + ", winResult="
				+ winResult + "]";
	}
	

}
