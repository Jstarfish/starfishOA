package cls.pilottery.web.marketManager.service;

import java.util.List;

import cls.pilottery.web.marketManager.entity.ReturnDeliveryOrder;
import cls.pilottery.web.marketManager.form.ReturnDeliveryForm;

public interface ReturnDeliveryService {

	int getReturnDeliveryCount(ReturnDeliveryForm form);

	List<ReturnDeliveryOrder> getReturnDeliveryList(ReturnDeliveryForm form);

	String saveReturnDelivery(ReturnDeliveryOrder order);

	int modifyReturnDeliveryStatus(String stbNo, int i);

	ReturnDeliveryOrder getReturnDeliveryDetail(String stbNo);

	void updateReturnDelivery(ReturnDeliveryOrder order);

	void updateReturnDeliveryAproval(ReturnDeliveryOrder order);

}
