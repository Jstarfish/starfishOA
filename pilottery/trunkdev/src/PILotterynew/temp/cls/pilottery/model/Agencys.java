package cls.pilottery.model;

import java.util.Date;

public class Agencys {
    private String agencyCode;

    private String agencyName;

    private Short storetypeId;

    private Short status;

    private Short agencyType;

    private Short bankId;

    private String bankAccount;

    private String telephone;

    private String contactPerson;

    private String address;

    private Date agencyAddTime;

    private Date quitTime;

    private String orgCode;

    private String areaCode;

    private String loginPass;

    private String tradePass;

    private Short marketManagerId;

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

    public String getLoginPass() {
        return loginPass;
    }

    public void setLoginPass(String loginPass) {
        this.loginPass = loginPass == null ? null : loginPass.trim();
    }

    public String getTradePass() {
        return tradePass;
    }

    public void setTradePass(String tradePass) {
        this.tradePass = tradePass == null ? null : tradePass.trim();
    }

    public Short getMarketManagerId() {
        return marketManagerId;
    }

    public void setMarketManagerId(Short marketManagerId) {
        this.marketManagerId = marketManagerId;
    }
}