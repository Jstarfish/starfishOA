package cls.pilottery.web.sales.entity;

public class StockTransferDetail implements java.io.Serializable {
	private static final long serialVersionUID = 8224865116712843594L;

	private String stbNo;

    private Long sequenceNo;
    
    private String planCode;
    
    private String planName;

    private int packages;
    
    private int detailTickets;
    private Long tickets;
    private Long amount;
    private String sendOrg;
    private String receiveOrg;
    private String deliveringUnit;
    private String receivingUnit;
    private Long detailAmount = 0L;

    private String remark;

	public String getStbNo() {
		return stbNo;
	}

	public void setStbNo(String stbNo) {
		this.stbNo = stbNo;
	}

	public Long getSequenceNo() {
		return sequenceNo;
	}

	public void setSequenceNo(Long sequenceNo) {
		this.sequenceNo = sequenceNo;
	}

	public String getPlanCode() {
		return planCode;
	}

	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}

	public int getPackages() {
		return packages;
	}

	public void setPackages(int packages) {
		this.packages = packages;
	}

	public int getDetailTickets() {
		return detailTickets;
	}

	public void setDetailTickets(int detailTickets) {
		this.detailTickets = detailTickets;
	}

	public Long getDetailAmount() {
		return detailAmount;
	}

	public void setDetailAmount(Long detailAmount) {
		this.detailAmount = detailAmount;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getPlanName() {
		return planName;
	}

	public void setPlanName(String planName) {
		this.planName = planName;
	}

	public Long getTickets() {
		return tickets;
	}

	public void setTickets(Long tickets) {
		this.tickets = tickets;
	}

	public Long getAmount() {
		return amount;
	}

	public void setAmount(Long amount) {
		this.amount = amount;
	}

	public String getSendOrg() {
		return sendOrg;
	}

	public void setSendOrg(String sendOrg) {
		this.sendOrg = sendOrg;
	}

	public String getReceiveOrg() {
		return receiveOrg;
	}

	public void setReceiveOrg(String receiveOrg) {
		this.receiveOrg = receiveOrg;
	}

	public String getDeliveringUnit() {
		return deliveringUnit;
	}

	public void setDeliveringUnit(String deliveringUnit) {
		this.deliveringUnit = deliveringUnit;
	}

	public String getReceivingUnit() {
		return receivingUnit;
	}

	public void setReceivingUnit(String receivingUnit) {
		this.receivingUnit = receivingUnit;
	}
	
	
}