package cls.pilottery.model;

import java.util.Date;

public class ItemReceipt {
    private String irNo;

    private Short createAdmin;

    private Date createDate;

    private String sendOrg;

    private String sendWh;

    private Short sendManager;

    private Date sendDate;

    private Short status;

    public String getIrNo() {
        return irNo;
    }

    public void setIrNo(String irNo) {
        this.irNo = irNo == null ? null : irNo.trim();
    }

    public Short getCreateAdmin() {
        return createAdmin;
    }

    public void setCreateAdmin(Short createAdmin) {
        this.createAdmin = createAdmin;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getSendOrg() {
        return sendOrg;
    }

    public void setSendOrg(String sendOrg) {
        this.sendOrg = sendOrg == null ? null : sendOrg.trim();
    }

    public String getSendWh() {
        return sendWh;
    }

    public void setSendWh(String sendWh) {
        this.sendWh = sendWh == null ? null : sendWh.trim();
    }

    public Short getSendManager() {
        return sendManager;
    }

    public void setSendManager(Short sendManager) {
        this.sendManager = sendManager;
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