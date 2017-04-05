package cls.pilottery.web.sales.form;

import cls.pilottery.common.model.BaseEntity;

public class OrderForm extends BaseEntity {
	private static final long serialVersionUID = -7898185973122503614L;

	private String purchaseOrderNo;
	private String applyDate;
	private int currentUserId;
	private String cuserOrg;	//当前用户所属部门
	public String getCuserOrg() {
		return cuserOrg;
	}
	public void setCuserOrg(String cuserOrg) {
		this.cuserOrg = cuserOrg;
	}
	public int getCurrentUserId() {
		return currentUserId;
	}
	public void setCurrentUserId(int currentUserId) {
		this.currentUserId = currentUserId;
	}
	public String getPurchaseOrderNo() {
		return purchaseOrderNo;
	}
	public void setPurchaseOrderNo(String purchaseOrderNo) {
		this.purchaseOrderNo = purchaseOrderNo;
	}
	public String getApplyDate() {
		return applyDate;
	}
	public void setApplyDate(String applyDate) {
		this.applyDate = applyDate;
	}
}
