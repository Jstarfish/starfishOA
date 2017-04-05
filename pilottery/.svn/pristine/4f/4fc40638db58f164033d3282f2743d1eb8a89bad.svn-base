package cls.pilottery.web.outlet.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.capital.model.withdrawnmodel.CashWithdrawn;
import cls.pilottery.web.outlet.dao.OutletCashWithdrawnDao;
import cls.pilottery.web.outlet.form.OutletCashWithdrawnForm;
import cls.pilottery.web.outlet.service.OutletCashWithdrawnService;

@Service
public class OutletCashWithdrawnServiceImpl implements OutletCashWithdrawnService{

	@Autowired
	private OutletCashWithdrawnDao outletCashWithdrawnDao;


	@Override
	public Integer getCashWithdrawnCount(
			OutletCashWithdrawnForm outletCashWithdrawnForm) {
		return outletCashWithdrawnDao.getCashWithdrawnCount(outletCashWithdrawnForm);
	}

	@Override
	public List<OutletCashWithdrawnForm> getCashWithdrawnList(
			OutletCashWithdrawnForm outletCashWithdrawnForm) {
		return outletCashWithdrawnDao.getCashWithdrawnList(outletCashWithdrawnForm);
	}

	@Override
	public List<CashWithdrawn> getWithdrawnByUser(short userId) {
		return outletCashWithdrawnDao.getWithdrawnByUser(userId);
	}

}
