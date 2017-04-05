package cls.pilottery.pos.common.model;

import java.io.Serializable;

import cls.pilottery.pos.common.constants.ErrorMessage;

public class BaseResponse implements Serializable {
	private static final long serialVersionUID = -2914448111602295893L;
	private String token;
	private String method;
	private long when;
	private long msn;
	private int errcode;
	private String errmesg;
	private Object result;
	
	
	public BaseResponse() {
		this.errcode = 0;
		this.errmesg = ErrorMessage.getMsg(0);
	}
	public BaseResponse(int errcode) {
		this.errcode = errcode;
		this.errmesg = ErrorMessage.getMsg(errcode);
	}
	public BaseResponse(String token, String method, long when, long msn, int errcode, String errmesg, Object result) {
		super();
		this.token = token;
		this.method = method;
		this.when = when;
		this.msn = msn;
		this.errcode = errcode;
		this.errmesg = errmesg;
		this.result = result;
	}
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
	public int getErrcode() {
		return errcode;
	}
	public void setErrcode(int errcode) {
		this.errcode = errcode;
		this.errmesg = ErrorMessage.getMsg(errcode);
	}
	public String getErrmesg() {
		return errmesg;
	}
	public void setErrmesg(String errmesg) {
		this.errmesg = errmesg;
	}
	public Object getResult() {
		return result;
	}
	public void setResult(Object result) {
		this.result = result;
	}
	@Override
	public String toString() {
		return "BaseResponse [errcode=" + errcode + ", errmesg=" + errmesg + ", method=" + method + ", msn=" + msn + ", result=" + result + ", token=" + token + ", when=" + when + "]";
	}
}
