package cls.taishan.common.model;

import lombok.Getter;

import lombok.Setter;

@Setter
@Getter
public class HostMessageBaseRes implements java.io.Serializable {
	private static final long serialVersionUID = 6785422116448348954L;
	protected String version = "1.0.0";
	protected int type;
	protected int func;
	protected long token;
	protected int msn;
	protected long when;
	protected int rc;		//返回消息错误码
	private Object result;
}
