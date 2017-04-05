package cls.pilottery.pos.system.model;

/*
 * 站点资金流水
 */
public class OutletFundFlow {

	//交易时间
	private String time;
	
	//交易类型 
	private String type;
	
	//交易金额
	private long amount;

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public long getAmount() {
		return amount;
	}

	public void setAmount(long amount) {
		this.amount = amount;
	}
	
	

}
