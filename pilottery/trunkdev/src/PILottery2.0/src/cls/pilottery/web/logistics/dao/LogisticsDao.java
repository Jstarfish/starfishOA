package cls.pilottery.web.logistics.dao;

import cls.pilottery.web.logistics.form.LogisticsForm;
import cls.pilottery.web.logistics.model.PayoutModel;

public interface LogisticsDao {

	String getWarehousename(String warehouseCode);
	
	String getUserName(String userCode);

	PayoutModel getPayout(LogisticsForm form);
	
}
