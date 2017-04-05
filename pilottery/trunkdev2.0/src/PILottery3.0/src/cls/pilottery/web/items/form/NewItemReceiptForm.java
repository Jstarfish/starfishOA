package cls.pilottery.web.items.form;

import java.io.Serializable;
import java.util.List;

import cls.pilottery.common.model.BaseEntity;
import cls.pilottery.web.items.model.ItemReceiptDetail;

public class NewItemReceiptForm extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 7744522619056052416L;

	private String receiptCode;
	private String warehouseCode;
	private String warehouseManager;
	private List<ItemReceiptDetail> itemDetails;
	private String remark;
	
	public String getReceiptCode() {
		return receiptCode;
	}
	public void setReceiptCode(String receiptCode) {
		this.receiptCode = receiptCode == null ? null : receiptCode.trim();
	}
	
	public String getWarehouseCode() {
		return warehouseCode;
	}
	public void setWarehouseCode(String warehouseCode) {
		this.warehouseCode = warehouseCode == null ? null : warehouseCode.trim();
	}
	
	public String getWarehouseManager() {
		return warehouseManager;
	}
	public void setWarehouseManager(String warehouseManager) {
		this.warehouseManager = warehouseManager == null ? null : warehouseManager.trim();
	}
	
	public List<ItemReceiptDetail> getItemDetails() {
		return itemDetails;
	}
	public void setItemDetails(List<ItemReceiptDetail> itemDetails) {
		this.itemDetails = itemDetails;
	}
	
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark == null ? null : remark.trim();
	}
}
