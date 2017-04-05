package cls.pilottery.oms.lottery.form;

import cls.pilottery.common.model.BaseEntity;


public class SaleGamepayinfoForm extends BaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String  payer;//兑奖操作人
	private String  startpayTime;//兑奖时间段的开始时间
	private String  endpayTime;//兑奖时间段的结束时间
	private String areaCode;
	public String getPayer() {
		return payer;
	}
	public void setPayer(String payer) {
		this.payer = payer;
	}
	public String getStartpayTime() {
		return startpayTime;
	}
	public void setStartpayTime(String startpayTime) {
		if(startpayTime!=null && startpayTime!=""){
		this.startpayTime = startpayTime+ " 00:00:00";
		}
	}
	public String getEndpayTime() {
		return endpayTime;
	}
	public void setEndpayTime(String endpayTime) {
		if(endpayTime!=null && endpayTime!=""){
		this.endpayTime = endpayTime+" 23:59:59";
		}
	}
	public String getAreaCode() {
		return areaCode;
	}
	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}
	
	
}
