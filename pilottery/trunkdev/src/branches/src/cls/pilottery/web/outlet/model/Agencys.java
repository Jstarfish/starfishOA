package cls.pilottery.web.outlet.model;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;

public class Agencys extends BaseEntity {
    /**
	 * 
	 */
	private static final long serialVersionUID = -4560056954378961470L;

	private String agencyCode; //站点编码

    private String agencyName; //站点名称

    private Short storetypeId; //店面类型ID

    private Short status; //销售站状态（1=可用；2=已禁用；3=已清退）

    private Short agencyType; //销售站类型（1=传统终端(预付费)；2=受信终端(后付费)；3=无纸化；4=中心销售站）

    private Short bankId;//银行ID

    private String bankAccount;//银行账号

    private String telephone;//销售站电话

    private String contactPerson;//销售站联系人

    private String address;//销售站地址

    private Date agencyAddTime;//销售站添加时间

    private Date quitTime;//清退时间

    private String orgCode;//所属部门编码

    private String areaCode;//所属区域编码

    private String pass;//站点密码

    private Short marketManagerId;//市场管理员编码

    public String getAgencyCode() {
        return agencyCode;
    }

    public void setAgencyCode(String agencyCode) {
        this.agencyCode = agencyCode == null ? null : agencyCode.trim();
    }

    public String getAgencyName() {
        return agencyName;
    }

    public void setAgencyName(String agencyName) {
        this.agencyName = agencyName == null ? null : agencyName.trim();
    }

    public Short getStoretypeId() {
        return storetypeId;
    }

    public void setStoretypeId(Short storetypeId) {
        this.storetypeId = storetypeId;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    public Short getAgencyType() {
        return agencyType;
    }

    public void setAgencyType(Short agencyType) {
        this.agencyType = agencyType;
    }

    public Short getBankId() {
        return bankId;
    }

    public void setBankId(Short bankId) {
        this.bankId = bankId;
    }

    public String getBankAccount() {
        return bankAccount;
    }

    public void setBankAccount(String bankAccount) {
        this.bankAccount = bankAccount == null ? null : bankAccount.trim();
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone == null ? null : telephone.trim();
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson == null ? null : contactPerson.trim();
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address == null ? null : address.trim();
    }

    public Date getAgencyAddTime() {
        return agencyAddTime;
    }

    public void setAgencyAddTime(Date agencyAddTime) {
        this.agencyAddTime = agencyAddTime;
    }

    public Date getQuitTime() {
        return quitTime;
    }

    public void setQuitTime(Date quitTime) {
        this.quitTime = quitTime;
    }

    public String getOrgCode() {
        return orgCode;
    }

    public void setOrgCode(String orgCode) {
        this.orgCode = orgCode == null ? null : orgCode.trim();
    }

    public String getAreaCode() {
        return areaCode;
    }

    public void setAreaCode(String areaCode) {
        this.areaCode = areaCode == null ? null : areaCode.trim();
    }


    public String getPass() {
		return pass;
	}

	public void setPass(String pass) {
		this.pass = pass;
	}

	public Short getMarketManagerId() {
        return marketManagerId;
    }

    public void setMarketManagerId(Short marketManagerId) {
        this.marketManagerId = marketManagerId;
    }
}