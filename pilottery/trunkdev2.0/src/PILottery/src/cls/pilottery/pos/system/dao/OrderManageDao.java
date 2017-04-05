package cls.pilottery.pos.system.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.pos.system.model.MktFundFlowDetail;
import cls.pilottery.pos.system.model.MktFundFlowResponse;
import cls.pilottery.pos.system.model.MktInventoryDetail;
import cls.pilottery.pos.system.model.PosDeliveryOrder;
import cls.pilottery.pos.system.model.PurchaseOrderDetail;
import cls.pilottery.pos.system.model.PurchaseOrderResponse;
import cls.pilottery.pos.system.model.mm.MMCapitalDaliy020508Res;
import cls.pilottery.pos.system.model.mm.MMDealRecordSmry020502Res;
import cls.pilottery.pos.system.model.mm.MMInventoryDaliy020501Req;
import cls.pilottery.pos.system.model.mm.MMInventoryDaliy020501Res;
import cls.pilottery.pos.system.model.mm.MMPayoutDetail020504Res;
import cls.pilottery.pos.system.model.mm.MMReturnDetail020505Res;
import cls.pilottery.pos.system.model.mm.MMSalesDetail020503Res;
import cls.pilottery.pos.system.model.mm.PlanList020503Res;
import cls.pilottery.pos.system.model.mm.PlanList020505Res;
import cls.pilottery.pos.system.model.mm.PrizeLevelList020504Res;
import cls.pilottery.pos.system.model.mm.TagList020503Res;
import cls.pilottery.pos.system.model.mm.TagList020504Res;
import cls.pilottery.pos.system.model.mm.TagList020505Res;
import cls.pilottery.web.sales.entity.DeliveryOrder;

public interface OrderManageDao {

	List<PosDeliveryOrder> getPosDeliveryList(Map<String, Object> map);

	List<MktFundFlowDetail> getMktFundFlow(Map<String, Object> map);

	List<MktInventoryDetail> getInventoryList(Long userId);

	List<PurchaseOrderResponse> getPosPurchaseOrderList(Map<String, Object> map);

	MktFundFlowResponse getMktFundBalance(int userId);

	DeliveryOrder getPosDeliveryDetail(String doNo);

	List<MMInventoryDaliy020501Res> getMMInventoryDaliyList(Map<String, Object> map);

	List<MMCapitalDaliy020508Res> getMMCapitalDaliyList(Map<String, Object> map);

	List<MMDealRecordSmry020502Res> getMMTransRecordSummary(Map<String, Object> map);

	MMSalesDetail020503Res getMMSaleDetailFund(String dealNo);

	List<PlanList020503Res> getMMSaleDetailPlanList(String dealNo);

	List<TagList020503Res> getMMSaleDetailRecordList(String dealNo);

	MMPayoutDetail020504Res getMMPayoutDetailFund(String dealNo);

	List<PrizeLevelList020504Res> getMMPayoutDetailPlanList(String dealNo);

	List<TagList020504Res> getMMPayoutDetailRecordList(String dealNo);

	MMReturnDetail020505Res getMMReturnDetailFund(String dealNo);

	List<PlanList020505Res> getMMReturnDetailPlanList(String dealNo);

	List<TagList020505Res> getMMReturnDetailRecordList(String dealNo);

	//List<PurchaseOrderDetail> getPurchaseOrderDetails(String orderNo);
	
}
