package cls.taishan.app.model.generic;

import cls.taishan.common.model.BaseResponse;
import lombok.Getter;
import lombok.Setter;

/*
 * 图片上传响应消息
 */
@Setter
@Getter
public class Res9002Msg extends BaseResponse{
	
	private static final long serialVersionUID = -4319439473421215984L;
	/*
	 * 图片Url
	 */
	private String picUrl;
}
