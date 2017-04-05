package cls.pilottery.web.marketManager.form;

import cls.pilottery.common.model.BaseEntity;

public class ReturnDeliveryForm extends BaseEntity  {
	private static final long serialVersionUID = 3953209000793957674L;
	private String queryNo;
	private String queryDate;
	private int currentUserId;
	private String cuserOrg;	//当前用户所属部门
	public String getQueryNo() {
		return queryNo;
	}
	public void setQueryNo(String queryNo) {
		this.queryNo = queryNo;
	}
	public String getQueryDate() {
		return queryDate;
	}
	public void setQueryDate(String queryDate) {
		this.queryDate = queryDate;
	}
	public int getCurrentUserId() {
		return currentUserId;
	}
	public void setCurrentUserId(int currentUserId) {
		this.currentUserId = currentUserId;
	}
	public String getCuserOrg() {
		return cuserOrg;
	}
	public void setCuserOrg(String cuserOrg) {
		this.cuserOrg = cuserOrg;
	}
}
