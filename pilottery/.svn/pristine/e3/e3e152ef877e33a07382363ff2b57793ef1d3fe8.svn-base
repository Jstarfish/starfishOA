package cls.taishan.common.constant;

import java.util.HashMap;
import java.util.Map;

/**
 * 错误码常量定义
 * 
 * @author huangchy
 *
 * @2016年9月7日
 *
 */
public class ErrorCodeConstant {
	
	public static final Map<Integer,String> errorMap = new HashMap<Integer,String>();
	
	public static String getMsg(Integer errorCode){
		return errorMap.get(errorCode);
	}
	
	static{
		errorMap.put(0, "成功");
		errorMap.put(1, "处理失败");
		errorMap.put(15, "游戏不可销售（投注消息）");
		errorMap.put(20, "投注字符串格式错误（投注消息）");
		errorMap.put(21, "彩票销售超过最大行数(场次)限制");
		errorMap.put(22, "投注倍数超出限制（投注消息）");
		errorMap.put(24, "彩票销售金额错误（投注消息）");
		errorMap.put(25, "账户余额不足（投注消息）");
		errorMap.put(41, "当前没有奖期或投注期次错误");
		errorMap.put(101, "签名校验失败");
		errorMap.put(102, "代理商账户不可用");
		errorMap.put(105, "查询订单不存在（彩票查询消息）");
		errorMap.put(106, "期次未完成兑奖（返奖查询消息）");
		errorMap.put(107, "订单重复");
		errorMap.put(500, "服务器错误");
		errorMap.put(501, "请求参数错误");
		
	}

}
