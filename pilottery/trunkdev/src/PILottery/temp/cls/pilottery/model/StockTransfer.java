package cls.pilottery.model;

import java.util.Date;

public class StockTransfer {
    private String stbNo;

    private Short applyAdmin;

    private Date applyDate;

    private Short approveAdmin;

    private Date approveDate;

    private String receiveOrg;

    private String receiveWh;

    private Short receiveManager;

    private Date receiveDate;

    private Short status;

    private Short isMatch;

    public String getStbNo() {
        return stbNo;
    }

    public void setStbNo(String stbNo) {
        this.stbNo = stbNo == null ? null : stbNo.trim();
    }

    public Short getApplyAdmin() {
        return applyAdmin;
    }

    public void setApplyAdmin(Short applyAdmin) {
        this.applyAdmin = applyAdmin;
    }

    public Date getApplyDate() {
        return applyDate;
    }

    public void setApplyDate(Date applyDate) {
        this.applyDate = applyDate;
    }

    public Short getApproveAdmin() {
        return approveAdmin;
    }

    public void setApproveAdmin(Short approveAdmin) {
        this.approveAdmin = approveAdmin;
    }

    public Date getApproveDate() {
        return approveDate;
    }

    public void setApproveDate(Date approveDate) {
        this.approveDate = approveDate;
    }

    public String getReceiveOrg() {
        return receiveOrg;
    }

    public void setReceiveOrg(String receiveOrg) {
        this.receiveOrg = receiveOrg == null ? null : receiveOrg.trim();
    }

    public String getReceiveWh() {
        return receiveWh;
    }

    public void setReceiveWh(String receiveWh) {
        this.receiveWh = receiveWh == null ? null : receiveWh.trim();
    }

    public Short getReceiveManager() {
        return receiveManager;
    }

    public void setReceiveManager(Short receiveManager) {
        this.receiveManager = receiveManager;
    }

    public Date getReceiveDate() {
        return receiveDate;
    }

    public void setReceiveDate(Date receiveDate) {
        this.receiveDate = receiveDate;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    public Short getIsMatch() {
        return isMatch;
    }

    public void setIsMatch(Short isMatch) {
        this.isMatch = isMatch;
    }
}