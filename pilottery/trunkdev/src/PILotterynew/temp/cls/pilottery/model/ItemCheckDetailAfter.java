package cls.pilottery.model;

public class ItemCheckDetailAfter extends ItemCheckDetailAfterKey {
    private String itemCode;

    private Long quantity;

    private Long changeQuantity;

    private Short result;

    private String remark;

    public String getItemCode() {
        return itemCode;
    }

    public void setItemCode(String itemCode) {
        this.itemCode = itemCode == null ? null : itemCode.trim();
    }

    public Long getQuantity() {
        return quantity;
    }

    public void setQuantity(Long quantity) {
        this.quantity = quantity;
    }

    public Long getChangeQuantity() {
        return changeQuantity;
    }

    public void setChangeQuantity(Long changeQuantity) {
        this.changeQuantity = changeQuantity;
    }

    public Short getResult() {
        return result;
    }

    public void setResult(Short result) {
        this.result = result;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark == null ? null : remark.trim();
    }
}