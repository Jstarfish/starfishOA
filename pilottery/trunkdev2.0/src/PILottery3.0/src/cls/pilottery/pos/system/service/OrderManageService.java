package cls.pilottery.pos.system.service;

import cls.pilottery.pos.common.model.BaseResponse;

public interface OrderManageService {
	
	public BaseResponse getDeliveryOrderList(Object reqParam) throws Exception;
	
	public BaseResponse getDeliveryOrderDetail(Object reqParam) throws Exception;
	
	public BaseResponse addDeliveryOrder(Object reqParam) throws Exception;
	
	public BaseResponse getFundFlow(Object reqParam) throws Exception;
	
	public BaseResponse getInventoryList(Object reqParam) throws Exception;

	public BaseResponse getPurchaseOrderList(Object reqParam) throws Exception;
	
	public BaseResponse applyReturnDelivery(Object reqParam) throws Exception;
	
	public BaseResponse getMMInventoryDaliyList(Object reqParam) throws Exception;
	
	public BaseResponse getMMCapitalDaliyList(Object reqParam) throws Exception;
	
	public BaseResponse getMMTransRecordSummary(Object reqParam) throws Exception;
	
	public BaseResponse getMMSalesRecordDetail(Object reqParam) throws Exception;
	
	public BaseResponse getMMPayoutRecordDetail(Object reqParam) throws Exception;
	
	public BaseResponse getMMReturnRecordDetail(Object reqParam) throws Exception;
	
	public BaseResponse getLogisticsInfo(Object reqParam) throws Exception;
	
	public BaseResponse getMMInventoryCheck(Object reqParam) throws Exception;
	
	//public BaseResponse getPurchaseOrderDetail(Object reqParam) throws Exception;
	
}
