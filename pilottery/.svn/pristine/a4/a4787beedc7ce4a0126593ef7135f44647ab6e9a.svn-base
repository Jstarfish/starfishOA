package cls.pilottery.pos.system.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.pos.system.model.MktFundFlowDetail;
import cls.pilottery.pos.system.model.MktFundFlowResponse;
import cls.pilottery.pos.system.model.MktInventoryDetail;
import cls.pilottery.pos.system.model.PosDeliveryOrder;
import cls.pilottery.pos.system.model.PurchaseOrderDetail;
import cls.pilottery.pos.system.model.PurchaseOrderResponse;
import cls.pilottery.web.sales.entity.DeliveryOrder;

public interface OrderManageDao {

	List<PosDeliveryOrder> getPosDeliveryList(Map<String, Object> map);

	List<MktFundFlowDetail> getMktFundFlow(Map<String, Object> map);

	List<MktInventoryDetail> getInventoryList(Long userId);

	List<PurchaseOrderResponse> getPosPurchaseOrderList(Map<String, Object> map);

	MktFundFlowResponse getMktFundBalance(int userId);

	DeliveryOrder getPosDeliveryDetail(String doNo);

	//List<PurchaseOrderDetail> getPurchaseOrderDetails(String orderNo);
	
}
