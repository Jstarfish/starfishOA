package cls.pilottery.web.marketManager.entity;


public class ReturnDeliveryDetail implements java.io.Serializable {
	private static final long serialVersionUID = 4333841040050438215L;

	private long sequenceNo;

    private String returnNo;

    private String planCode;

    private String planName;
    
    private int tickets;

    private int packages;

    private long amount;

	public long getSequenceNo() {
		return sequenceNo;
	}

	public void setSequenceNo(long sequenceNo) {
		this.sequenceNo = sequenceNo;
	}

	public String getReturnNo() {
		return returnNo;
	}

	public void setReturnNo(String returnNo) {
		this.returnNo = returnNo;
	}

	public String getPlanCode() {
		return planCode;
	}

	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}

	public int getTickets() {
		return tickets;
	}

	public void setTickets(int tickets) {
		this.tickets = tickets;
	}

	public int getPackages() {
		return packages;
	}

	public void setPackages(int packages) {
		this.packages = packages;
	}

	public long getAmount() {
		return amount;
	}

	public void setAmount(long amount) {
		this.amount = amount;
	}

	public String getPlanName() {
		return planName;
	}

	public void setPlanName(String planName) {
		this.planName = planName;
	} 
}