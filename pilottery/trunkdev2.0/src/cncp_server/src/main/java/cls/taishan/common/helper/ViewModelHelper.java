package cls.taishan.common.helper;

import cls.taishan.common.model.BaseMessage;
import cls.taishan.common.model.BaseResponse;

/**
 * 返回客户端实体帮助类
 * 
 * @author huangchy
 *
 * @2016年8月31日
 *
 */
public class ViewModelHelper {

	public static BaseMessage<BaseResponse> successResponse() {
		BaseResponse res = new BaseResponse();
		return new BaseMessage<BaseResponse>(res);	
	}
	
	public static BaseMessage<BaseResponse> errorResponse() {
		BaseResponse res = new BaseResponse(500);
		return new BaseMessage<BaseResponse>(res);	
	}
	
	public static <T> BaseMessage<T> toResult(T result) {
		return new BaseMessage<T>(result);
	}

}
