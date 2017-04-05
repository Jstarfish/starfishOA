package cls.pilottery.model;

import java.util.Date;

public class ItemCheck {
    private String checkNo;

    private String checkName;

    private Date checkDate;

    private Short checkAdmin;

    private String checkWarehouse;

    private Short status;

    private Short result;

    public String getCheckNo() {
        return checkNo;
    }

    public void setCheckNo(String checkNo) {
        this.checkNo = checkNo == null ? null : checkNo.trim();
    }

    public String getCheckName() {
        return checkName;
    }

    public void setCheckName(String checkName) {
        this.checkName = checkName == null ? null : checkName.trim();
    }

    public Date getCheckDate() {
        return checkDate;
    }

    public void setCheckDate(Date checkDate) {
        this.checkDate = checkDate;
    }

    public Short getCheckAdmin() {
        return checkAdmin;
    }

    public void setCheckAdmin(Short checkAdmin) {
        this.checkAdmin = checkAdmin;
    }

    public String getCheckWarehouse() {
        return checkWarehouse;
    }

    public void setCheckWarehouse(String checkWarehouse) {
        this.checkWarehouse = checkWarehouse == null ? null : checkWarehouse.trim();
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    public Short getResult() {
        return result;
    }

    public void setResult(Short result) {
        this.result = result;
    }
}