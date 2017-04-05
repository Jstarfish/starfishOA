package cls.pilottery.web.sales.form;

import cls.pilottery.common.model.BaseEntity;

public class DeliveryForm extends BaseEntity{
	private static final long serialVersionUID = -1027749641907632071L;
	
	private String deliveryOrderNo;
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
	public String getDeliveryOrderNo() {
		return deliveryOrderNo;
	}
	public void setDeliveryOrderNo(String deliveryOrderNo) {
		this.deliveryOrderNo = deliveryOrderNo;
	}
	public String getApplyDate() {
		return applyDate;
	}
	public void setApplyDate(String applyDate) {
		this.applyDate = applyDate;
	}
}
