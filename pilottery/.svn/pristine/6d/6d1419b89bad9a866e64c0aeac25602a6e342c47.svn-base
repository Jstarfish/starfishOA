package cls.taishan.app.model.generic;

import lombok.Getter;
import lombok.Setter;

/*
 * 图片上传请求消息
 */
@Getter
@Setter
public class Req9002Msg implements java.io.Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 4440296280756684806L;

	/*
	 * 图片字节码编码结果
	 */
	private String picBytes;
	
	/*
	 * 图片所属分类，主要为了分布式存储减少相关存储读写压力。
	 * 其中：1 头像 2 产品类别标志 3 产品图片 4 用户分享 5 即开票 6电脑票 9其他
	 */
	private int picType;
}
