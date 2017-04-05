package cls.pilottery.pos.system.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.pos.system.model.BalanceInfo;
import cls.pilottery.pos.system.model.OutletDaliyReportRequest;
import cls.pilottery.pos.system.model.OutletSalesReocrd;
import cls.pilottery.pos.system.model.PayTicketResponse;
import cls.pilottery.pos.system.model.WithDrawRecordResponse;
import cls.pilottery.web.capital.form.CashWithdrawnForm;

public interface OutletsManageDao {

	public List<WithDrawRecordResponse> getCashWithdrawnList(Map<String, Object> map) ;

	public BalanceInfo getOutletsBalance(String outletCode);

	public List<OutletSalesReocrd> getOutletDailyList(OutletDaliyReportRequest req);

	public void spAgencyCashWithdrawn(CashWithdrawnForm cashWithdrawnForm);

	public PayTicketResponse getPayoutResult(String paySqlNo);

}
