package cls.pilottery.pos.system.service;

import cls.pilottery.pos.common.model.BaseResponse;

public interface OutletsManageService {

	public BaseResponse getOutletInfo(Object reqParam) throws Exception;
	
	public BaseResponse getOutletFundFlow(Object reqParam) throws Exception;
	
	public BaseResponse getOutletDailyList(Object reqParam) throws Exception;
	
	public BaseResponse getOutletTopup(Object reqParam) throws Exception;
	
	public BaseResponse getCashWithdrawnList(Object reqParam) throws Exception;
	
	public BaseResponse addCashWithdrawn(Object reqParam) throws Exception;
	
	public BaseResponse confirmCashWithdrawn(Object reqParam) throws Exception;
	
	public BaseResponse addOutletGoodsReceipts(Object reqParam) throws Exception;
	
	public BaseResponse addPurchaseOrder(Object reqParam) throws Exception;
	
	public BaseResponse returnGoods(Object reqParam) throws Exception;
	
	public BaseResponse payout(Object reqParam) throws Exception;
	
	public BaseResponse payoutQuery(Object req) throws Exception;
	
}
