package cls.pilottery.web.items.form;

import java.io.Serializable;
import java.util.List;

import cls.pilottery.common.model.BaseEntity;
import cls.pilottery.web.items.model.ItemCheckDetail;

public class ProcItemCheckForm extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 3233129693324652424L;

	private String checkAdmin;  
	private String checkNo;
	private String checkWarehouse;
	private String checkOp;
	private List<ItemCheckDetail> itemDetails;
	private String remark;
	
	public String getCheckAdmin() {
		return checkAdmin;
	}
	public void setCheckAdmin(String checkAdmin) {
		this.checkAdmin = checkAdmin == null ? null : checkAdmin.trim();
	}
	
	public String getCheckNo() {
		return checkNo;
	}
	public void setCheckNo(String checkNo) {
		this.checkNo = checkNo == null ? null : checkNo.trim();
	}
	
	public String getCheckWarehouse() {
		return checkWarehouse;
	}
	public void setCheckWarehouse(String checkWarehouse) {
		this.checkWarehouse = checkWarehouse == null ? null : checkWarehouse.trim();
	}
	
	public String getCheckOp() {
		return checkOp;
	}
	public void setCheckOp(String checkOp) {
		this.checkOp = checkOp == null ? null : checkOp.trim();
	}
	
	public List<ItemCheckDetail> getItemDetails() {
		return itemDetails;
	}
	public void setItemDetails(List<ItemCheckDetail> itemDetails) {
		this.itemDetails = itemDetails;
	}
	
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark == null ? null : remark.trim();
	}
}
