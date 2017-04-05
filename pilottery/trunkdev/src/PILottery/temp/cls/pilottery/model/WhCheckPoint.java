package cls.pilottery.model;

import java.math.BigDecimal;
import java.util.Date;

public class WhCheckPoint {
    private String cpNo;

    private String warehouseCode;

    private String cpName;

    private Short status;

    private Short result;

    private Long nomatchTickets;

    private BigDecimal nomatchAmount;

    private Short cpAdmin;

    private Date cpDate;

    private String remark;

    public String getCpNo() {
        return cpNo;
    }

    public void setCpNo(String cpNo) {
        this.cpNo = cpNo == null ? null : cpNo.trim();
    }

    public String getWarehouseCode() {
        return warehouseCode;
    }

    public void setWarehouseCode(String warehouseCode) {
        this.warehouseCode = warehouseCode == null ? null : warehouseCode.trim();
    }

    public String getCpName() {
        return cpName;
    }

    public void setCpName(String cpName) {
        this.cpName = cpName == null ? null : cpName.trim();
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

    public Long getNomatchTickets() {
        return nomatchTickets;
    }

    public void setNomatchTickets(Long nomatchTickets) {
        this.nomatchTickets = nomatchTickets;
    }

    public BigDecimal getNomatchAmount() {
        return nomatchAmount;
    }

    public void setNomatchAmount(BigDecimal nomatchAmount) {
        this.nomatchAmount = nomatchAmount;
    }

    public Short getCpAdmin() {
        return cpAdmin;
    }

    public void setCpAdmin(Short cpAdmin) {
        this.cpAdmin = cpAdmin;
    }

    public Date getCpDate() {
        return cpDate;
    }

    public void setCpDate(Date cpDate) {
        this.cpDate = cpDate;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark == null ? null : remark.trim();
    }
}