package cls.pilottery.web.outlet.form;

import java.io.Serializable;

public class AgencyDealRecordForm implements Serializable {

	private static final long serialVersionUID = 1L;

	private String beginTime;// 开始时间

	private String endTime;// 结束时间

	private String realTime;// 交易时间

	private int dealType;// 类型

	private String dealEnType;// 表示类型
	
	private String insCode;//所属部门
	
	private String agencyCode;//站点编号
	
	
	public String getAgencyCode() {
	
		return agencyCode;
	}


	
	public void setAgencyCode(String agencyCode) {
	
		this.agencyCode = agencyCode;
	}


	public String getInsCode() {
	
		return insCode;
	}

	
	public void setInsCode(String insCode) {
	
		this.insCode = insCode;
	}

	public String getDealEnType() {

		return dealEnType;
	}

	public void setDealEnType(String dealEnType) {

		this.dealEnType = dealEnType;
	}

	private long amount;// 金额

	private String outletCode;// 站点编号

	private int beginNum;

	private int endNum;

	public int getBeginNum() {

		return beginNum;
	}

	public void setBeginNum(int beginNum) {

		this.beginNum = beginNum;
	}

	public int getEndNum() {

		return endNum;
	}

	public void setEndNum(int endNum) {

		this.endNum = endNum;
	}

	public int getDealType() {

		return dealType;
	}

	public void setDealType(int dealType) {

		this.dealType = dealType;
	}

	public String getBeginTime() {

		return beginTime;
	}

	public void setBeginTime(String beginTime) {

		this.beginTime = beginTime;
	}

	public String getEndTime() {

		return endTime;
	}

	public void setEndTime(String endTime) {

		this.endTime = endTime;
	}

	public String getRealTime() {

		return realTime;
	}

	public void setRealTime(String realTime) {

		this.realTime = realTime;
	}

	public long getAmount() {

		return amount;
	}

	public void setAmount(long amount) {

		this.amount = amount;
	}

	public String getOutletCode() {

		return outletCode;
	}

	public void setOutletCode(String outletCode) {

		this.outletCode = outletCode;
	}
}
