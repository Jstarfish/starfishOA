package cls.pilottery.pos.system.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.pos.system.model.BalanceInfo;
import cls.pilottery.pos.system.model.OutletDaliyReportRequest;
import cls.pilottery.pos.system.model.OutletSalesReocrd;
import cls.pilottery.pos.system.model.WithDrawRecordResponse;

public interface OutletsManageDao {

	public List<WithDrawRecordResponse> getCashWithdrawnList(Map<String, Object> map) ;

	public BalanceInfo getOutletsBalance(String outletCode);

	public List<OutletSalesReocrd> getOutletDailyList(OutletDaliyReportRequest req);

}
