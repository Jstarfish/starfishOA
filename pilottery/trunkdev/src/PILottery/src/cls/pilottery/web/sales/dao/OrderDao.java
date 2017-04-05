package cls.pilottery.web.sales.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.sales.entity.PurchaseOrder;
import cls.pilottery.web.sales.entity.PurchaseOrderDetail;
import cls.pilottery.web.sales.form.OrderForm;
import cls.pilottery.web.sales.model.PlanModel;


public interface OrderDao {

	int getOrderCount(OrderForm form);

	List<PurchaseOrder> getOrderList(OrderForm form);

	int modifyOrderStatus(Map<String, Object> paraMap);

	List<PlanModel> getPlanList();
	
	String getOrderSeq();

	void savePurchaseOrder(PurchaseOrder order);

	void saveOrderDetail(PurchaseOrderDetail detail);

	PurchaseOrder getPurchaseDetail(String purchaseOrderNo);

	void deleteOrderDetails(String orderSeq);

	void updatePurchaseOrder(PurchaseOrder order);

	List<PurchaseOrder> getOrderListByUser(Map<String,Object> map);

	List<PlanModel> getOrderPlanList(Map<String,Object> map);

	int getOrderCountForInquery(OrderForm form);

	List<PurchaseOrder> getOrderListForInquery(OrderForm form);

	int getOutletCountByUser(Map<String, Object> map);

	List<PlanModel> getPlanListByOrg(String insCode);

}
