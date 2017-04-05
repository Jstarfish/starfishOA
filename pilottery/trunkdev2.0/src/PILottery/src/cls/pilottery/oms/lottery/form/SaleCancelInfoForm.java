package cls.pilottery.oms.lottery.form;

import cls.pilottery.common.model.BaseEntity;


public class SaleCancelInfoForm extends BaseEntity{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String  canceler;//取消操作员
	private String   satrtcancelTime;//开始取消时间
	private String   endcancelTime;//结束取消时间
	private String areaCode;
	public String getCanceler() {
		return canceler;
	}
	public void setCanceler(String canceler) {
		this.canceler = canceler;
	}
	public String getSatrtcancelTime() {
		return satrtcancelTime;
	}
	public void setSatrtcancelTime(String satrtcancelTime) {
		this.satrtcancelTime = satrtcancelTime;
	}
	public String getEndcancelTime() {
		return endcancelTime;
	}
	public void setEndcancelTime(String endcancelTime) {
		this.endcancelTime = endcancelTime;
	}
	public String getAreaCode() {
		return areaCode;
	}
	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}
	
}
