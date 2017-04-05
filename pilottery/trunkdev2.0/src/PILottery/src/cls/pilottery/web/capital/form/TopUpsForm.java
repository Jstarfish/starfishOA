package cls.pilottery.web.capital.form;

import cls.pilottery.common.model.BaseEntity;

public class TopUpsForm extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6781496322917039090L;
	private String fundNo;
	private Integer accountType;
	private String aoCode;
	private String aoName;
	private String accNo;
	private Long operAmount;
	private Long beforeBalance;
	private Long afterBalance;

	private String operTime;
	private Long operAdmin;
	private String realName;

	private String orgCode;

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public String getFundNo() {
		return fundNo;
	}

	public void setFundNo(String fundNo) {
		this.fundNo = fundNo;
	}

	public Integer getAccountType() {
		return accountType;
	}

	public void setAccountType(Integer accountType) {
		this.accountType = accountType;
	}

	public String getAoCode() {
		return aoCode;
	}

	public void setAoCode(String aoCode) {
		this.aoCode = aoCode;
	}

	public String getAoName() {
		return aoName;
	}

	public void setAoName(String aoName) {
		this.aoName = aoName;
	}

	public String getAccNo() {
		return accNo;
	}

	public void setAccNo(String accNo) {
		this.accNo = accNo;
	}

	public Long getOperAmount() {
		return operAmount;
	}

	public void setOperAmount(Long operAmount) {
		this.operAmount = operAmount;
	}

	public Long getBeforeBalance() {
		return beforeBalance;
	}

	public void setBeforeBalance(Long beforeBalance) {
		this.beforeBalance = beforeBalance;
	}

	public Long getAfterBalance() {
		return afterBalance;
	}

	public void setAfterBalance(Long afterBalance) {
		this.afterBalance = afterBalance;
	}

	public String getOperTime() {
		return operTime;
	}

	public void setOperTime(String operTime) {
		this.operTime = operTime;
	}

	public Long getOperAdmin() {
		return operAdmin;
	}

	public void setOperAdmin(Long operAdmin) {
		this.operAdmin = operAdmin;
	}

	public String getRealName() {
		return realName;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

}
