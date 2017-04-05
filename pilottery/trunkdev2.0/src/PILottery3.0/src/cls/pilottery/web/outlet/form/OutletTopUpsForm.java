package cls.pilottery.web.outlet.form;

import cls.pilottery.common.model.BaseEntity;

public class OutletTopUpsForm extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5321550171421663662L;

	private String agencyCode; // AGENCY_CODE
	private String agencyName; // AGENCY_NAME
	private Integer status; // STATUS
	private Integer agencyType; // AGENCY_TYPE
	private String telephone; // TELEPHONE
	private String contactPerson; // CONTACT_PERSON 负责人
	private Long marketManagerId; // MARKET_MANAGER_ID 市场管理员编号

	private String password; // 市场管理员密码
	private Long creditLimit; // CREDIT_LIMIT 站点信用额度
	private Long accountBalance; // ACCOUNT_BALANCE 可用余额

	private String fundId; // 充值编码 ,资金流水
	private Long operAmount; // 充值金额

	private Long beforeBalance;
	private Long afterBalance;

	private int currentUserId;

	public int getCurrentUserId() {
		return currentUserId;
	}

	public void setCurrentUserId(int currentUserId) {
		this.currentUserId = currentUserId;
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

	public Long getOperAmount() {
		return operAmount;
	}

	public void setOperAmount(Long operAmount) {
		this.operAmount = operAmount;
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

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getAgencyType() {
		return agencyType;
	}

	public void setAgencyType(Integer agencyType) {
		this.agencyType = agencyType;
	}

	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String getContactPerson() {
		return contactPerson;
	}

	public void setContactPerson(String contactPerson) {
		this.contactPerson = contactPerson;
	}

	public Long getMarketManagerId() {
		return marketManagerId;
	}

	public void setMarketManagerId(Long marketManagerId) {
		this.marketManagerId = marketManagerId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Long getCreditLimit() {
		return creditLimit;
	}

	public void setCreditLimit(Long creditLimit) {
		this.creditLimit = creditLimit;
	}

	public Long getAccountBalance() {
		return accountBalance;
	}

	public void setAccountBalance(Long accountBalance) {
		this.accountBalance = accountBalance;
	}

	public String getFundId() {
		return fundId;
	}

	public void setFundId(String fundId) {
		this.fundId = fundId;
	}

}
