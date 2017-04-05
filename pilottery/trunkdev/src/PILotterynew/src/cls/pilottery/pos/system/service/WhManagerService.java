package cls.pilottery.pos.system.service;

import cls.pilottery.pos.common.model.BaseResponse;

public interface WhManagerService {
	/*
	 * 入库记录查询
	 */
	public BaseResponse getInstorRecordList(Object reqParam) throws Exception;
	
	/*
	 * 获取批次信息
	 */
	public BaseResponse getBatchList(Object reqParam) throws Exception;
	
	/*
	 * 批次入库提交
	 */
	public BaseResponse submitBatchInstore(Object reqParam) throws Exception;
	
	/*
	 * 获取调拨单列表
	 */
	public BaseResponse getTransferList(Object reqParam) throws Exception;
	
	/*
	 * 调拨单入库提交
	 */
	public BaseResponse submitTransferInstore(Object reqParam) throws Exception;
	
	/*
	 * 获取可入库还货单列表
	 */
	public BaseResponse getReturnList(Object reqParam) throws Exception;
	
	/*
	 * 还货单入库提交
	 */
	public BaseResponse submitReturnInstore(Object reqParam) throws Exception;
	
	/*
	 * 出库记录查询
	 */
	public BaseResponse getOutStoreList(Object reqParam) throws Exception;
	
	/*
	 * 调拨单出库提交
	 */
	public BaseResponse submitTransferOutStore(Object reqParam) throws Exception;
	
	/*
	 *  获取出货单列表
	 */
	public BaseResponse getDeliveryList(Object reqParam) throws Exception;
	
	/*
	 * 出货单出库提交
	 */
	public BaseResponse submitDeliveryOutStore(Object reqParam) throws Exception;
	
	/*
	 *  获取盘点记录列表
	 */
	public BaseResponse getCheckRecordList(Object reqParam) throws Exception;
	
	/*
	 * 提交盘点
	 */
	public BaseResponse submitCheckRecord(Object reqParam) throws Exception;
	
	
}
