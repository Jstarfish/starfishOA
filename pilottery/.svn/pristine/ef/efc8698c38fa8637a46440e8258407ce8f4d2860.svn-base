package cls.pilottery.webncp.system.service;

import cls.pilottery.webncp.common.model.BaseResponse;

/**
 * 
 * @author huangchy
 * 数据报表相关接口，包括3001，3002，3003，3005
 *
 */
public interface DataReportService {
	
	/*
	 * 0x3001时段报表
	 * 按照游戏统计某个时间段内的站点销售信息
	 */
	public BaseResponse getSaleReportByDate(String reqJson) throws Exception;
	/*
	 * 0x3002期次报表
	 */
	public BaseResponse getSaleReport(String reqJson) throws Exception;
	/*
	 * 0x3003日结算报表
	 */
	public BaseResponse getDailyBalanceReport(String reqJson) throws Exception;
	/*
	 * 0x3005新月结算报表
	 */
	public BaseResponse getNewMonthBalanceReport(String reqJson) throws Exception;
	
	public BaseResponse getAgencyFlow(String reqjson) throws Exception;
	
	/*
	 * 0x3007 实时报表查询
	 */
	public BaseResponse getRealTimeReport(String reqjson) throws Exception;
	
	/*
	 * 0x3008 日结报表
	 */
	public BaseResponse getDaliyReport(String reqjson) throws Exception;
	
	/*
	 * 0x3009 月结报表
	 */
	public BaseResponse getMonthReport(String reqjson) throws Exception;
	
	/*
	 * 0x3010站点账户余额查询
	 */
	public BaseResponse getAccountBalance(String reqjson) throws Exception;
	
	/*
	 * 0x3011站点销售汇总报表
	 */
	public BaseResponse getOutletStatistcs(String reqjson) throws Exception;

}
