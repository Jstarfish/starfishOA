package cls.facebook.ncpimpl;

import com.alibaba.fastjson.annotation.JSONField;

public class BaseRequest implements java.io.Serializable{
	private static final long serialVersionUID = -3237183972001611423L;
	
	private int CMD;	//方法编码
	@JSONField(name="CMD")
	public int getCMD() {
		return CMD;
	}
	@JSONField(name="CMD")
	public void setCMD(int cmd) {
		CMD = cmd;
	}

}
