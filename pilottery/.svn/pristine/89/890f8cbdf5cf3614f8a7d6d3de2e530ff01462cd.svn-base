package cls.pilottery.web.logistics.service;

import java.sql.SQLException;

import cls.pilottery.web.logistics.form.PayoutForm;
import cls.pilottery.web.logistics.model.LogisticsList;

public interface LogisticsService {

	//通过物流码获取物流信息
	LogisticsList getLogistics(String logisticsCode) throws SQLException;

	//通过仓库编码获取仓库名称
	String getWarehousename(String warehouseCode);
	
	//通过用户id获取用户名称
	String getUserName(String userCode);

	PayoutForm getPayout(String logisticsCode);
}
