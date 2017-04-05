package cls.pilottery.web.sales.form;

import cls.pilottery.common.model.BaseEntity;

public class TransferForm extends BaseEntity {
	private static final long serialVersionUID = 1135856840143068072L;
	
	private String stockTransferNo;
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
	public String getStockTransferNo() {
		return stockTransferNo;
	}
	public void setStockTransferNo(String stockTransferNo) {
		this.stockTransferNo = stockTransferNo;
	}
	public String getApplyDate() {
		return applyDate;
	}
	public void setApplyDate(String applyDate) {
		this.applyDate = applyDate;
	}

}
