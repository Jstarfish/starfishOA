package cls.pilottery.web.outlet.msg;

import java.io.Serializable;
import java.util.List;

import cls.pilottery.web.area.model.GameAuth;

public class AddAgency6001 implements Serializable {
	private static final long serialVersionUID = 2473061688134440012L;
    private String agencyCode;
    private String areaCode;
    private int agencyType;
    private int status;
    private int businessBeginTime;
    private int businessEndTime;
    private long marginalCreditLimit;
    private long tempMarginalCreditLimit;
    private long availableCredit;
    private String agencyName;
    private String contactName;
    private String contactAddress;
    private String contactPhone;
    private int bankID;
    private String bankCode;
    private int gameCount;
    private List<GameAuth> ctrls;
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
	public int getAgencyType() {
		return agencyType;
	}
	public void setAgencyType(int agencyType) {
		this.agencyType = agencyType;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public int getBusinessBeginTime() {
		return businessBeginTime;
	}
	public void setBusinessBeginTime(int businessBeginTime) {
		this.businessBeginTime = businessBeginTime;
	}
	public int getBusinessEndTime() {
		return businessEndTime;
	}
	public void setBusinessEndTime(int businessEndTime) {
		this.businessEndTime = businessEndTime;
	}
	public long getMarginalCreditLimit() {
		return marginalCreditLimit;
	}
	public void setMarginalCreditLimit(long marginalCreditLimit) {
		this.marginalCreditLimit = marginalCreditLimit;
	}
	public long getTempMarginalCreditLimit() {
		return tempMarginalCreditLimit;
	}
	public void setTempMarginalCreditLimit(long tempMarginalCreditLimit) {
		this.tempMarginalCreditLimit = tempMarginalCreditLimit;
	}
	public long getAvailableCredit() {
		return availableCredit;
	}
	public void setAvailableCredit(long availableCredit) {
		this.availableCredit = availableCredit;
	}
	public String getAgencyName() {
		return agencyName;
	}
	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}
	public String getContactName() {
		return contactName;
	}
	public void setContactName(String contactName) {
		this.contactName = contactName;
	}
	public String getContactAddress() {
		return contactAddress;
	}
	public void setContactAddress(String contactAddress) {
		this.contactAddress = contactAddress;
	}
	public String getContactPhone() {
		return contactPhone;
	}
	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}
	public int getBankID() {
		return bankID;
	}
	public void setBankID(int bankID) {
		this.bankID = bankID;
	}
	public String getBankCode() {
		return bankCode;
	}
	public void setBankCode(String bankCode) {
		this.bankCode = bankCode;
	}
	public int getGameCount() {
		return gameCount;
	}
	public void setGameCount(int gameCount) {
		this.gameCount = gameCount;
	}
	public List<GameAuth> getCtrls() {
		return ctrls;
	}
	public void setCtrls(List<GameAuth> ctrls) {
		this.ctrls = ctrls;
	}
	@Override
	public String toString() {
		return "AddAgency6001 [agencyCode=" + agencyCode + ", areaCode=" + areaCode + ", agencyType=" + agencyType
				+ ", status=" + status + ", businessBeginTime=" + businessBeginTime + ", businessEndTime="
				+ businessEndTime + ", marginalCreditLimit=" + marginalCreditLimit + ", tempMarginalCreditLimit="
				+ tempMarginalCreditLimit + ", availableCredit=" + availableCredit + ", agencyName=" + agencyName
				+ ", contactName=" + contactName + ", contactAddress=" + contactAddress + ", contactPhone="
				+ contactPhone + ", bankID=" + bankID + ", bankCode=" + bankCode + ", gameCount=" + gameCount
				+ ", ctrls=" + ctrls + "]";
	}
    
}
