package cls.pilottery.web.sales.service;

import java.util.List;

import cls.pilottery.web.sales.entity.DeliveryOrder;
import cls.pilottery.web.sales.form.DeliveryForm;

public interface DeliveryService {

	List<DeliveryOrder> getDeliveryList(DeliveryForm form);

	int getDeliveryCount(DeliveryForm form);

	DeliveryOrder getDeliveryDetail(String deliveryOrderNo);

	String getDeliveryOrderSeq();

	int saveDeliveryOrder(DeliveryOrder order);

	int modifyDeliveryOrderStatus(String deliveryOrderNo, int i);

	int modifyDeliveryOrder(DeliveryOrder order);

	int getDeliveryCountForInquery(DeliveryForm form);

	List<DeliveryOrder> getDeliveryListForInquery(DeliveryForm form);

	int cancelDeliveryOrder(String deliveryOrderNo);

}
