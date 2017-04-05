package cls.pilottery.web.marketManager.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.marketManager.entity.ReturnDeliveryDetail;
import cls.pilottery.web.marketManager.entity.ReturnDeliveryOrder;
import cls.pilottery.web.marketManager.form.ReturnDeliveryForm;

public interface ReturnDeliveryDao {

	int getReturnDeliveryCount(ReturnDeliveryForm form);

	ReturnDeliveryOrder getReturnDeliveryDetail(String returnNo);

	List<ReturnDeliveryOrder> getReturnDeliveryList(ReturnDeliveryForm form);

	int modifyReturnDeliveryStatus(Map<String, Object> map);

	void saveReturnDelivery(ReturnDeliveryOrder order);

	void updateReturnDelivery(ReturnDeliveryOrder order);

	void updateReturnDeliveryAproval(ReturnDeliveryOrder order);

	String getReturnDeliverySeq();

	void saveReturnDeliveryDetail(ReturnDeliveryDetail detail);

	long getDirectAmount();

	void saveReturnDeliveryDirect(ReturnDeliveryOrder order);

	void deleteReturnDeliveryDetails(String returnNo);

	void updateReturnDeliveryDirect(ReturnDeliveryOrder order);

}
