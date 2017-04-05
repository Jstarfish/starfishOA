package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class ConnectTestResponse implements Serializable {
	private static final long serialVersionUID = -523242010482037117L;
	private long termTxTime;	
	private long servRxTime;
	private long servTxTime;
	public long getTermTxTime() {
		return termTxTime;
	}
	public void setTermTxTime(long termTxTime) {
		this.termTxTime = termTxTime;
	}
	public long getServRxTime() {
		return servRxTime;
	}
	public void setServRxTime(long servRxTime) {
		this.servRxTime = servRxTime;
	}
	public long getServTxTime() {
		return servTxTime;
	}
	public void setServTxTime(long servTxTime) {
		this.servTxTime = servTxTime;
	}
}
