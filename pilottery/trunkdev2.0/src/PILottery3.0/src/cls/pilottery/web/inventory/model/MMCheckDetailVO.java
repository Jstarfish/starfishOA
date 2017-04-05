package cls.pilottery.web.inventory.model;

public class MMCheckDetailVO implements java.io.Serializable {
	private static final long serialVersionUID = 6462318237259139856L;
	private String cpNo;
	private String cpDetailNo;
	private String planCode;
	private String planName;
	private String batchNo;
	private String tagNo;
	private int tickets;
	private int status;
	public String getCpNo() {
		return cpNo;
	}
	public void setCpNo(String cpNo) {
		this.cpNo = cpNo;
	}
	public String getCpDetailNo() {
		return cpDetailNo;
	}
	public void setCpDetailNo(String cpDetailNo) {
		this.cpDetailNo = cpDetailNo;
	}
	public String getPlanCode() {
		return planCode;
	}
	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}
	public String getBatchNo() {
		return batchNo;
	}
	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo;
	}
	public String getTagNo() {
		return tagNo;
	}
	public void setTagNo(String tagNo) {
		this.tagNo = tagNo;
	}
	public int getTickets() {
		return tickets;
	}
	public void setTickets(int tickets) {
		this.tickets = tickets;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public String getPlanName() {
		return planName;
	}
	public void setPlanName(String planName) {
		this.planName = planName;
	}
}
