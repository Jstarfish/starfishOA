package cls.pilottery.oms.common.entity;


/**
 * 与oms通信消息的请求消息头定义
 * @author huangchy
 *
 */
public class BaseMessageReq  implements java.io.Serializable{
	private static final long serialVersionUID = -2248837686919987591L;
	protected int type;
	protected int func;
	protected long token;
	protected long msn;
	protected long when;
	protected String version = "1.0.0";
	protected Object params;
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
	public long getMsn() {
		return msn;
	}
	public void setMsn(long msn) {
		this.msn = msn;
	}
	public long getWhen() {
		return when;
	}
	public void setWhen(long when) {
		this.when = System.currentTimeMillis()/1000;
	}
	public Object getParams() {
		return params;
	}
	public void setParams(Object params) {
		this.params = params;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public BaseMessageReq() {
	}
	public BaseMessageReq(int func, int type) {
		super();
		this.when = System.currentTimeMillis()/1000;
		this.type = type;
		this.func = func;
	}

}
