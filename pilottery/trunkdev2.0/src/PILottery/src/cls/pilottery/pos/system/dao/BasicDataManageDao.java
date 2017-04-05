package cls.pilottery.pos.system.dao;

import java.util.List;

import cls.pilottery.pos.system.model.BatchInfo;
import cls.pilottery.pos.system.model.OutletInfoResponse;
import cls.pilottery.pos.system.model.WareHouseInfo;


public interface BasicDataManageDao {

	List<OutletInfoResponse> getOutletsInfoList(Long id);

	WareHouseInfo getWareHouseInfo(String whManager);

	List<BatchInfo> getBatchByPlan(String planCode);

}
