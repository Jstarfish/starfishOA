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
	
	
	/*
	 * 0x4090获取当前游戏的最新开奖信息
	 */
	public BaseResponse getLastDrawAnnouncement(String reqJson) throws Exception;
	
	/*
	 * 0x4091获取当前游戏的最新50期的开奖信息
	 */
	public BaseResponse getDrawResultList(String reqJson) throws Exception;
	
	/*
	 * 0x4101获取站点交易流水
	 */
	public BaseResponse getOutletDealFlow(String reqJson) throws Exception;
	
	/*
	 * 0x4102获取站点交易流水明细
	 */
	public BaseResponse getOutletDealFlowDetail(String reqJson) throws Exception;
	
	/*
	 * 0x4103站点兑奖
	 */
	public BaseResponse payout(String reqJson) throws Exception;
	
	/*
	 * 0x4104当前期查询
	 */
	public BaseResponse getCurrentIssue(String reqJson) throws Exception;
}
