package cls.pilottery.model;

import java.util.Date;

public class User {
    private Short adminId;

    private String adminRealname;

    private String adminLogin;

    private String adminPassword;

    private Short adminGender;

    private String adminEmail;

    private Date adminBirthday;

    private String adminTel;

    private String adminMobile;

    private String adminPhone;

    private String adminOrg;

    private String adminAddress;

    private String adminRemark;

    private Short adminStatus;

    private Date adminCreateTime;

    private Date adminUpdateTime;

    private Date adminLoginTime;

    private Long adminLoginCount;

    private String adminAgreeday;

    private String adminLoginBegin;

    private String adminLoginEnd;

    private Short createAdminId;

    private String adminIpLimit;

    private Short loginStatus;

    private Short isCollecter;

    private Short isWarehouseM;

    public Short getAdminId() {
        return adminId;
    }

    public void setAdminId(Short adminId) {
        this.adminId = adminId;
    }

    public String getAdminRealname() {
        return adminRealname;
    }

    public void setAdminRealname(String adminRealname) {
        this.adminRealname = adminRealname == null ? null : adminRealname.trim();
    }

    public String getAdminLogin() {
        return adminLogin;
    }

    public void setAdminLogin(String adminLogin) {
        this.adminLogin = adminLogin == null ? null : adminLogin.trim();
    }

    public String getAdminPassword() {
        return adminPassword;
    }

    public void setAdminPassword(String adminPassword) {
        this.adminPassword = adminPassword == null ? null : adminPassword.trim();
    }

    public Short getAdminGender() {
        return adminGender;
    }

    public void setAdminGender(Short adminGender) {
        this.adminGender = adminGender;
    }

    public String getAdminEmail() {
        return adminEmail;
    }

    public void setAdminEmail(String adminEmail) {
        this.adminEmail = adminEmail == null ? null : adminEmail.trim();
    }

    public Date getAdminBirthday() {
        return adminBirthday;
    }

    public void setAdminBirthday(Date adminBirthday) {
        this.adminBirthday = adminBirthday;
    }

    public String getAdminTel() {
        return adminTel;
    }

    public void setAdminTel(String adminTel) {
        this.adminTel = adminTel == null ? null : adminTel.trim();
    }

    public String getAdminMobile() {
        return adminMobile;
    }

    public void setAdminMobile(String adminMobile) {
        this.adminMobile = adminMobile == null ? null : adminMobile.trim();
    }

    public String getAdminPhone() {
        return adminPhone;
    }

    public void setAdminPhone(String adminPhone) {
        this.adminPhone = adminPhone == null ? null : adminPhone.trim();
    }

    public String getAdminOrg() {
        return adminOrg;
    }

    public void setAdminOrg(String adminOrg) {
        this.adminOrg = adminOrg == null ? null : adminOrg.trim();
    }

    public String getAdminAddress() {
        return adminAddress;
    }

    public void setAdminAddress(String adminAddress) {
        this.adminAddress = adminAddress == null ? null : adminAddress.trim();
    }

    public String getAdminRemark() {
        return adminRemark;
    }

    public void setAdminRemark(String adminRemark) {
        this.adminRemark = adminRemark == null ? null : adminRemark.trim();
    }

    public Short getAdminStatus() {
        return adminStatus;
    }

    public void setAdminStatus(Short adminStatus) {
        this.adminStatus = adminStatus;
    }

    public Date getAdminCreateTime() {
        return adminCreateTime;
    }

    public void setAdminCreateTime(Date adminCreateTime) {
        this.adminCreateTime = adminCreateTime;
    }

    public Date getAdminUpdateTime() {
        return adminUpdateTime;
    }

    public void setAdminUpdateTime(Date adminUpdateTime) {
        this.adminUpdateTime = adminUpdateTime;
    }

    public Date getAdminLoginTime() {
        return adminLoginTime;
    }

    public void setAdminLoginTime(Date adminLoginTime) {
        this.adminLoginTime = adminLoginTime;
    }

    public Long getAdminLoginCount() {
        return adminLoginCount;
    }

    public void setAdminLoginCount(Long adminLoginCount) {
        this.adminLoginCount = adminLoginCount;
    }

    public String getAdminAgreeday() {
        return adminAgreeday;
    }

    public void setAdminAgreeday(String adminAgreeday) {
        this.adminAgreeday = adminAgreeday == null ? null : adminAgreeday.trim();
    }

    public String getAdminLoginBegin() {
        return adminLoginBegin;
    }

    public void setAdminLoginBegin(String adminLoginBegin) {
        this.adminLoginBegin = adminLoginBegin == null ? null : adminLoginBegin.trim();
    }

    public String getAdminLoginEnd() {
        return adminLoginEnd;
    }

    public void setAdminLoginEnd(String adminLoginEnd) {
        this.adminLoginEnd = adminLoginEnd == null ? null : adminLoginEnd.trim();
    }

    public Short getCreateAdminId() {
        return createAdminId;
    }

    public void setCreateAdminId(Short createAdminId) {
        this.createAdminId = createAdminId;
    }

    public String getAdminIpLimit() {
        return adminIpLimit;
    }

    public void setAdminIpLimit(String adminIpLimit) {
        this.adminIpLimit = adminIpLimit == null ? null : adminIpLimit.trim();
    }

    public Short getLoginStatus() {
        return loginStatus;
    }

    public void setLoginStatus(Short loginStatus) {
        this.loginStatus = loginStatus;
    }

    public Short getIsCollecter() {
        return isCollecter;
    }

    public void setIsCollecter(Short isCollecter) {
        this.isCollecter = isCollecter;
    }

    public Short getIsWarehouseM() {
        return isWarehouseM;
    }

    public void setIsWarehouseM(Short isWarehouseM) {
        this.isWarehouseM = isWarehouseM;
    }
}