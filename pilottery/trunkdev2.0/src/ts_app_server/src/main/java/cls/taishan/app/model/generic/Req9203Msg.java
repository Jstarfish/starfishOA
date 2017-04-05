package cls.taishan.app.model.generic;

import lombok.Getter;
import lombok.Setter;

/*
 * 获取保密消息列表，用于第一次加载设置保密消息
 */
@Getter
@Setter
public class Req9203Msg implements java.io.Serializable{
	
	private static final long serialVersionUID = -1168625407695341799L;
	
	/*
	 * 请求问题数
	 */
	private int questionNumber;
}
