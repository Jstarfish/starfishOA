package cls.pilottery.oms.common.msg;

import cls.pilottery.oms.lottery.model.LotteryResModel;



public class LotteryRes4003 implements java.io.Serializable {  
	private static final long serialVersionUID = -2592280070915759929L;
	private String version = "1.0.0";
	private int type;
	private int func;
	private long token;
	private int msn;
	private long when;
	private int rc;		//返回消息错误码
	private LotteryResModel result;
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public int getFunc() {
		return func;
	}
	public void setFunc(int func) {
		this.func = func;
	}
	public long getToken() {
		return token;
	}
	public void setToken(long token) {
		this.token = token;
	}
	public int getMsn() {
		return msn;
	}
	public void setMsn(int msn) {
		this.msn = msn;
	}
	public long getWhen() {
		return when;
	}
	public void setWhen(long when) {
		this.when = when;
	}
	public int getRc() {
		return rc;
	}
	public void setRc(int rc) {
		this.rc = rc;
	}
	public LotteryResModel getResult() {
		return result;
	}
	public void setResult(LotteryResModel result) {
		this.result = result;
	}
	
}
