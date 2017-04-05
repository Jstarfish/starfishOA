package cls.pilottery.oms.common.entity;

import com.alibaba.fastjson.JSONObject;

/**
 * 与oms通信消息的响应消息头定义
 * @author huangchy
 *
 */
public class BaseMessageRes implements java.io.Serializable{
	private static final long serialVersionUID = 5044461489068323811L;
	protected String version = "1.0.0";
	protected int type;
	protected int func;
	protected long token;
	protected int msn;
	protected long when;
	protected int rc;		//返回消息错误码
	private Object result;
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
	public Object getResult() {
		return result;
	}
	public void setResult(Object result) {
		this.result = result;
	}
	@Override
	public String toString() {
		return "BaseMessageRes [func=" + func + ", msn=" + msn + ", rc=" + rc + ", result=" + result + ", token=" + token + ", type=" + type + ", version=" + version + ", when=" + when + "]";
	}
}
