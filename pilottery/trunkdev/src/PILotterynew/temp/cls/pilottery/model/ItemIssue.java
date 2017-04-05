package cls.pilottery.model;

import java.util.Date;

public class ItemIssue {
    private String iiNo;

    private Short operAdmin;

    private Date issueDate;

    private String receiveOrg;

    private Short receiveManager;

    private Date receiveDate;

    private String sendOrg;

    private Date sendDate;

    private Short status;

    public String getIiNo() {
        return iiNo;
    }

    public void setIiNo(String iiNo) {
        this.iiNo = iiNo == null ? null : iiNo.trim();
    }

    public Short getOperAdmin() {
        return operAdmin;
    }

    public void setOperAdmin(Short operAdmin) {
        this.operAdmin = operAdmin;
    }

    public Date getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(Date issueDate) {
        this.issueDate = issueDate;
    }

    public String getReceiveOrg() {
        return receiveOrg;
    }

    public void setReceiveOrg(String receiveOrg) {
        this.receiveOrg = receiveOrg == null ? null : receiveOrg.trim();
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

    public String getSendOrg() {
        return sendOrg;
    }

    public void setSendOrg(String sendOrg) {
        this.sendOrg = sendOrg == null ? null : sendOrg.trim();
    }

    public Date getSendDate() {
        return sendDate;
    }

    public void setSendDate(Date sendDate) {
        this.sendDate = sendDate;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }
}