package cls.taishan.common.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class HostMessageBaseReq implements java.io.Serializable{
	private static final long serialVersionUID = 3243143661564914653L;
	protected int type;
	protected int func;
	protected long token;
	protected long msn;
	protected long when;
	protected String version = "1.0.0";
	protected Object params;
}
