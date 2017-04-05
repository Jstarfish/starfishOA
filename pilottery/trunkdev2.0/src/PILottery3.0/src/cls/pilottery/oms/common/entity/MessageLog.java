package cls.pilottery.oms.common.entity;

public class MessageLog {

	private long   seq;   // log_id
	private String time;  //LOG_TIME  -- not used when write
	private String body;  // log_info
	private short  status; // log_status  -- not used when write
	public long getSeq() {
		return seq;
	}
	public void setSeq(long seq) {
		this.seq = seq;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getBody() {
		return body;
	}
	public void setBody(String body) {
		this.body = body;
	}
	public short getStatus() {
		return status;
	}
	public void setStatus(short status) {
		this.status = status;
	}
	public MessageLog() {
	}
	public MessageLog(String body, short status) {
		this.body = body;
		this.status = status;
	}
	public MessageLog(long seq, String body) {
		this.seq = seq;
		this.body = body;
	}
}
