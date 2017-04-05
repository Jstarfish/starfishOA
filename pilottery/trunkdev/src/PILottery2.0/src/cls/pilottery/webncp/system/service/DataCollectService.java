package cls.pilottery.webncp.system.service;

import cls.pilottery.webncp.common.model.BaseResponse;

/**
 * 
 * @author huangchy
 * 数据采集相关接口，包括9001，9002
 *
 */
public interface DataCollectService {

	/**
	 * 
	 * 	@Title:采集查询 (0x9001)
		@Description: 终端机通过调用该接口，查询是否需要有提供日志的需求
	 */
	public BaseResponse getLogByTermCode(String reqJson) throws Exception;
	
	/**
	 * 
	 * 	@Title: 完成通知 (0x9002)
		@Description: 当webncp接收到该请求后，更新对应请求记录状态为已完成
	 */
	public BaseResponse updateLogStatus(String reqJson) throws Exception;
	
}
