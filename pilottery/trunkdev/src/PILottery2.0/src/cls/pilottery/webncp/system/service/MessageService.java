package cls.pilottery.webncp.system.service;

import cls.pilottery.webncp.common.model.BaseResponse;

/**
 * 
 * @author huangchy
 * 信息公布相关接口，包括4001，4002，4003，4004，4005
 *
 */
public interface MessageService {

	/*
	 * 0x4001开奖公告
	 */
	public BaseResponse getDrawAnnouncement(String reqJson) throws Exception;
	
	/*
	 * 0x4002中奖信息
	 */
	public BaseResponse getWinningInfo(String reqJson) throws Exception;
	
	/*
	 * 0x4003通知列表
	 */
	public BaseResponse getNoticeList(String reqJson) throws Exception;
	
	/*
	 * 0x4004通知详情
	 */
	public BaseResponse getNoticeDetails(String reqJson) throws Exception;
	
	/*
	 * 0x4005开奖号码查询
	 */
	public BaseResponse getDrawResult(String reqJson) throws Exception;
}
