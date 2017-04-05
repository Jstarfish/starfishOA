package cls.pilottery.web.logistics.form;

import java.io.Serializable;

public class LogisticsForm implements Serializable {
	private static final long serialVersionUID = -6188097053536945505L;
	private String queryType;
	private String planCode;
	private String batchCode;
	private String logisticsCode;
	private String specification;
	private String packUnitCode;
	private String tagCode;
	private String ticketNo;
	public String getQueryType() {
		return queryType;
	}
	public void setQueryType(String queryType) {
		this.queryType = queryType;
	}
	public String getPlanCode() {
		return planCode;
	}
	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}
	public String getBatchCode() {
		return batchCode;
	}
	public void setBatchCode(String batchCode) {
		this.batchCode = batchCode;
	}
	public String getLogisticsCode() {
		return logisticsCode;
	}
	public void setLogisticsCode(String logisticsCode) {
		this.logisticsCode = logisticsCode;
	}
	public String getTagCode() {
		return tagCode;
	}
	public void setTagCode(String tagCode) {
		this.tagCode = tagCode;
	}
	public String getTicketNo() {
		return ticketNo;
	}
	public void setTicketNo(String ticketNo) {
		this.ticketNo = ticketNo;
	}
	public String getSpecification() {
		return specification;
	}
	public void setSpecification(String specification) {
		this.specification = specification;
	}
	public String getPackUnitCode() {
		return packUnitCode;
	}
	public void setPackUnitCode(String packUnitCode) {
		this.packUnitCode = packUnitCode;
	}
	@Override
	public String toString() {
		return "LogisticsForm [batchCode=" + batchCode  + ", planCode=" + planCode + ", specification=" 
				+ specification + ", packUnitCode="	+ packUnitCode + ", ticketNo=" + ticketNo + ", logisticsCode="
				+ logisticsCode+ "]";
	}
}
