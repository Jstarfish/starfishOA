package cls.pilottery.web.sales.service;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.sales.entity.PurchaseOrder;
import cls.pilottery.web.sales.form.OrderForm;
import cls.pilottery.web.sales.model.PlanModel;

public interface OrderService {

	int getOrderCount(OrderForm form);

	List<PurchaseOrder> getOrderList(OrderForm form);

	int modifyOrderStatus(String purchaseOrderNo, int status);

	List<PlanModel> getPlanList();

	void savePurchaseOrder(PurchaseOrder order);

	PurchaseOrder getPurchaseDetail(String purchaseOrderNo);

	void updatePurchaseOrder(PurchaseOrder order);

	List<PurchaseOrder> getOrderListByUser(Map<String,Object> map);

	List<PlanModel> getOrderPlanList(Map<String,Object> map);

	int getOrderCountForInquery(OrderForm form);

	List<PurchaseOrder> getOrderListForInquery(OrderForm form);

	int getOutletCountByUser(Map<String, Object> map);

	List<PlanModel> getPlanListByOrg(String insCode);
}
