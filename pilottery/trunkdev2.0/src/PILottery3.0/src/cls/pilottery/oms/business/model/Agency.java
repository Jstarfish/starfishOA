package cls.pilottery.oms.business.model;

import java.util.List;

import cls.pilottery.common.entity.AbstractEntity;
import cls.pilottery.web.area.model.GameAuth;

public class Agency extends AbstractEntity {
	private static final long serialVersionUID = -4257217686811430429L;

	private String agencyName; // 销售站名称
	private Integer shopType = new Integer(1);
	private AreaParent areaParent; // 销售站父区域
	private AgencyStatus agencyStatus; // 销售站状态
	private AgencyType agencyType; // 销售站类型
	private AgencyBank agencyBank;
	private String bankAccount; // 银行名称
	private Long bankId; // 银行卡
	private Long creditLimit; // 临时信用额度
	private Long accountBalance; // 永久信用额度
	private Long frozenBalance;
	private String agencyPhone; // 销售站电话
	private String agencyManager; // 联系人
	private String agencyAddress; // 销售站地址
	private String auditResult = "jiaoyanziduan";
	private String startTime; // 开始营业时间
	private String endTime; // 结束营业时间
	private String agencyKey = "key";
	private Long useDefaultGames = 0L; // 游戏默认参数
	List<GameAuth> validGames;
	private String agencyCode; // 销售站编码
	private String agencyCodeToChar; // 格式化后的销售站编码
	private String areaCode;
	private Long areaType;

	private String orgCode;
	private String orgName;

	private String contractNo; // 合同编号

	public String getContractNo() {
		return contractNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}

	public Long getUseDefaultGames() {
		return useDefaultGames;
	}

	public void setUseDefaultGames(Long useDefaultGames) {
		this.useDefaultGames = useDefaultGames;
	}

	public String getAgencyName() {
		return agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public Integer getShopType() {
		return shopType;
	}

	public void setShopType(Integer shopType) {
		this.shopType = shopType;
	}

	public AreaParent getAreaParent() {
		return areaParent;
	}

	public void setAreaParent(AreaParent areaParent) {
		this.areaParent = areaParent;
	}

	public AgencyStatus getAgencyStatus() {
		return agencyStatus;
	}

	public void setAgencyStatus(AgencyStatus agencyStatus) {
		this.agencyStatus = agencyStatus;
	}

	public AgencyType getAgencyType() {
		return agencyType;
	}

	public void setAgencyType(AgencyType agencyType) {
		this.agencyType = agencyType;
	}

	public AgencyBank getAgencyBank() {
		return agencyBank;
	}

	public void setAgencyBank(AgencyBank agencyBank) {
		this.agencyBank = agencyBank;
	}

	public String getBankAccount() {
		return bankAccount;
	}

	public void setBankAccount(String bankAccount) {
		this.bankAccount = bankAccount;
	}

	public Long getBankId() {
		return bankId;
	}

	public void setBankId(Long bankId) {
		this.bankId = bankId;
	}

	public String getAgencyPhone() {
		return agencyPhone;
	}

	public void setAgencyPhone(String agencyPhone) {
		this.agencyPhone = agencyPhone;
	}

	public String getAgencyManager() {
		return agencyManager;
	}

	public void setAgencyManager(String agencyManager) {
		this.agencyManager = agencyManager;
	}

	public String getAgencyAddress() {
		return agencyAddress;
	}

	public void setAgencyAddress(String agencyAddress) {
		this.agencyAddress = agencyAddress;
	}

	public String getAuditResult() {
		return auditResult;
	}

	public void setAuditResult(String auditResult) {
		this.auditResult = auditResult;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getAgencyKey() {
		return agencyKey;
	}

	public void setAgencyKey(String agencyKey) {
		this.agencyKey = agencyKey;
	}

	public List<GameAuth> getValidGames() {
		return validGames;
	}

	public void setValidGames(List<GameAuth> validGames) {
		this.validGames = validGames;
	}

	public String getAgencyCode() {
		return agencyCode;
	}

	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}

	public String getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}

	public Long getAreaType() {
		return areaType;
	}

	public void setAreaType(Long areaType) {
		this.areaType = areaType;
	}

	public String getAgencyCodeToChar() {
		return agencyCodeToChar;
	}

	public void setAgencyCodeToChar(String agencyCodeToChar) {
		this.agencyCodeToChar = agencyCodeToChar;
	}

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
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

	public Long getFrozenBalance() {
		return frozenBalance;
	}

	public void setFrozenBalance(Long frozenBalance) {
		this.frozenBalance = frozenBalance;
	}
}
