package cls.pilottery.web.outlet.service;

import java.util.List;

import cls.pilottery.web.capital.model.withdrawnmodel.CashWithdrawn;
import cls.pilottery.web.outlet.form.OutletCashWithdrawnForm;

public interface OutletCashWithdrawnService {

	public Integer getCashWithdrawnCount(OutletCashWithdrawnForm outletCashWithdrawnForm);

	public List<OutletCashWithdrawnForm> getCashWithdrawnList(
			OutletCashWithdrawnForm outletCashWithdrawnForm);
	
	public List<CashWithdrawn> getWithdrawnByUser(short userId);
}
