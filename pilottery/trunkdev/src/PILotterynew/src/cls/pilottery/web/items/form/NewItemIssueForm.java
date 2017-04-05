package cls.pilottery.web.items.form;

import java.io.Serializable;
import java.util.List;

import cls.pilottery.common.model.BaseEntity;
import cls.pilottery.web.items.model.ItemIssueDetail;

public class NewItemIssueForm extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 7434238780868060127L;

	private String issueCode;
	private String warehouseCode;
	private String warehouseManager;
	private String receivingUnit;
	private List<ItemIssueDetail> itemDetails;
	private String remark;
	
	public String getIssueCode() {
		return issueCode;
	}
	public void setIssueCode(String issueCode) {
		this.issueCode = issueCode == null ? null : issueCode.trim();
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
	
	public String getReceivingUnit() {
		return receivingUnit;
	}
	public void setReceivingUnit(String receivingUnit) {
		this.receivingUnit = receivingUnit == null ? null : receivingUnit.trim();
	}
	
	public List<ItemIssueDetail> getItemDetails() {
		return itemDetails;
	}
	public void setItemDetails(List<ItemIssueDetail> itemDetails) {
		this.itemDetails = itemDetails;
	}
	
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark == null ? null : remark.trim();
	}
}
