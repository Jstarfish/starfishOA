package cls.pilottery.web.outlet.model;

import java.io.Serializable;
import java.util.Date;

public class OutletTopUps implements Serializable {

	/**
	 * 站点充值查询实体类
	 */
	private static final long serialVersionUID = -8229140664100062543L;

	/**
	 * 站点信息列表，和充值无关，只是显示站点信息列表
	 */
	private String agencyCode; // AGENCY_CODE
	private String agencyName; // AGENCY_NAME
	/**
	 * 用于查询充值记录的
	 */
	private String aoCode;
	private String aoName;
	private Integer status; // STATUS
	private Integer agencyType; // AGENCY_TYPE
	private String telephone; // TELEPHONE
	private String contactPerson; // CONTACT_PERSON 负责人
	private Integer marketManagerId; // MARKET_MANAGER_ID 市场管理员编号

	private String password; // 市场管理员密码
	private Long creditLimit; // CREDIT_LIMIT 站点信用额度
	private Long accountBalance; // ACCOUNT_BALANCE 可用余额
	private Long afterBalance; // AF_ACCOUNT_BALANCE 可用余额

	private String fundId; // 充值编码
	private Date applyDate; // 充值时间
	private Long applyAmount; // 充值金额
	private String realName;
	private Long tickets;

	public Long getAfterBalance() {
		return afterBalance;
	}

	public void setAfterBalance(Long afterBalance) {
		this.afterBalance = afterBalance;
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

	public String getRealName() {
		return realName;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

	public Date getApplyDate() {
		return applyDate;
	}

	public void setApplyDate(Date applyDate) {
		this.applyDate = applyDate;
	}

	public Long getApplyAmount() {
		return applyAmount;
	}

	public void setApplyAmount(Long applyAmount) {
		this.applyAmount = applyAmount;
	}

	public Long getAccountBalance() {
		return accountBalance;
	}

	public String getAgencyCode() {
		return agencyCode;
	}

	public String getAgencyName() {
		return agencyName;
	}

	public Integer getAgencyType() {
		return agencyType;
	}

	public String getContactPerson() {
		return contactPerson;
	}

	public Long getCreditLimit() {
		return creditLimit;
	}

	public String getFundId() {
		return fundId;
	}

	public Integer getMarketManagerId() {
		return marketManagerId;
	}

	public String getPassword() {
		return password;
	}

	public Integer getStatus() {
		return status;
	}

	public String getTelephone() {
		return telephone;
	}

	public void setAccountBalance(Long accountBalance) {
		this.accountBalance = accountBalance;
	}

	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public void setAgencyType(Integer agencyType) {
		this.agencyType = agencyType;
	}

	public void setContactPerson(String contactPerson) {
		this.contactPerson = contactPerson;
	}

	public void setCreditLimit(Long creditLimit) {
		this.creditLimit = creditLimit;
	}

	public void setFundId(String fundId) {
		this.fundId = fundId;
	}

	public void setMarketManagerId(Integer marketManagerId) {
		this.marketManagerId = marketManagerId;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public Long getTickets() {
		return tickets;
	}

	public void setTickets(Long tickets) {
		this.tickets = tickets;
	}

}
