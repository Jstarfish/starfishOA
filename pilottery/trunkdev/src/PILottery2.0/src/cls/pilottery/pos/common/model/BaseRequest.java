package cls.pilottery.pos.common.model;

import java.io.Serializable;

public class BaseRequest implements Serializable {
	private static final long serialVersionUID = 3624797174363894452L;
	private String token;
	private String method;
	private long when;
	private long msn;
	private Object param;
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}
	public String getMethod() {
		return method;
	}
	public void setMethod(String method) {
		this.method = method;
	}
	public long getWhen() {
		return when;
	}
	public void setWhen(long when) {
		this.when = when;
	}
	public long getMsn() {
		return msn;
	}
	public void setMsn(long msn) {
		this.msn = msn;
	}
	public Object getParam() {
		return param;
	}
	public void setParam(Object param) {
		this.param = param;
	}
}
