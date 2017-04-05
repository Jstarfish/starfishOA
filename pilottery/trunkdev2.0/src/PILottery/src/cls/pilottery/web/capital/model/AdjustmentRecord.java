package cls.pilottery.web.capital.model;

import java.util.Date;

public class AdjustmentRecord implements java.io.Serializable {
	private static final long serialVersionUID = -3699346480846301796L;
	private Date operTime;
	private String agencyCode;
	private String agencyName;
	private long credit;
	private long adjustAmount;
	private long beforeBalance;
	private long afterBalance;
	private String operAdminName;
	private long operAdminId;
	private String reason;

	private String orgCode;
	private String orgName;

	private String fundNo;

	public String getFundNo() {
		return fundNo;
	}

	public void setFundNo(String fundNo) {
		this.fundNo = fundNo;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public Date getOperTime() {
		return operTime;
	}

	public void setOperTime(Date operTime) {
		this.operTime = operTime;
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

	public long getCredit() {
		return credit;
	}

	public void setCredit(long credit) {
		this.credit = credit;
	}

	public long getAdjustAmount() {
		return adjustAmount;
	}

	public void setAdjustAmount(long adjustAmount) {
		this.adjustAmount = adjustAmount;
	}

	public long getBeforeBalance() {
		return beforeBalance;
	}

	public void setBeforeBalance(long beforeBalance) {
		this.beforeBalance = beforeBalance;
	}

	public long getAfterBalance() {
		return afterBalance;
	}

	public void setAfterBalance(long afterBalance) {
		this.afterBalance = afterBalance;
	}

	public String getOperAdminName() {
		return operAdminName;
	}

	public void setOperAdminName(String operAdminName) {
		this.operAdminName = operAdminName;
	}

	public long getOperAdminId() {
		return operAdminId;
	}

	public void setOperAdminId(long operAdminId) {
		this.operAdminId = operAdminId;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}
}
