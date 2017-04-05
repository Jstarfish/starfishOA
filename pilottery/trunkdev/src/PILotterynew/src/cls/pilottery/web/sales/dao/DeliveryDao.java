package cls.pilottery.web.sales.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.sales.entity.DeliveryOrder;
import cls.pilottery.web.sales.entity.DeliveryOrderDetail;
import cls.pilottery.web.sales.entity.DeliveryOrderRelation;
import cls.pilottery.web.sales.form.DeliveryForm;

public interface DeliveryDao {

	List<DeliveryOrder> getDeliveryList(DeliveryForm form);

	int getDeliveryCount(DeliveryForm form);

	DeliveryOrder getDeliveryDetail(String deliveryOrderNo);

	String getDeliveryOrderSeq();

	void saveDeliveryOrderDetail(DeliveryOrderDetail detail);

	void saveDeliverOrderRelation(DeliveryOrderRelation relation);

	void saveDeliveryOrder(DeliveryOrder order);

	int modifyDeliveryOrderStatus(Map<String, Object> map);

	void deleteDeliveryDetails(String doNo);

	void updateDeliveryOrder(DeliveryOrder order);

	int getDeliveryCountForInquery(DeliveryForm form);

	List<DeliveryOrder> getDeliveryListForInquery(DeliveryForm form);

	Long getMktManagerBalance(Short userId);

	void modifyOrderStatus(String doNo);

	void deleteDeliveryOrders(String doNo);

}
