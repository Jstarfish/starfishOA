package cls.pilottery.web.outlet.dao;

import java.util.List;

import cls.pilottery.web.capital.model.withdrawnmodel.CashWithdrawn;
import cls.pilottery.web.outlet.form.OutletCashWithdrawnForm;

public interface OutletCashWithdrawnDao {

	public Integer getCashWithdrawnCount(OutletCashWithdrawnForm outletCashWithdrawnForm);
	
	public List<OutletCashWithdrawnForm> getCashWithdrawnList(OutletCashWithdrawnForm outletCashWithdrawnForm);

	public List<CashWithdrawn> getWithdrawnByUser(short userId);
	
	
}
