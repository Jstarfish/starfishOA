package cls.pilottery.web.outlet.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.capital.form.CashWithdrawnForm;
import cls.pilottery.web.capital.model.OutletAccount;
import cls.pilottery.web.outlet.dao.OutletTopUpsDao;
import cls.pilottery.web.outlet.form.OutletTopUpsForm;
import cls.pilottery.web.outlet.model.Agencys;
import cls.pilottery.web.outlet.model.OutletTopUps;
import cls.pilottery.web.outlet.service.OutletTopUpsService;

@Service
public class OutletTopUpsServiceImpl implements OutletTopUpsService{

	@Autowired
	private OutletTopUpsDao outletTopUpsDao;
	@Override
	public Integer getOutletTopUpsCount(OutletTopUpsForm outletTopUpsForm) {
		return outletTopUpsDao.getOutletTopUpsCount(outletTopUpsForm);
	}

	@Override
	public List<OutletTopUps> getOutletTopUpsList(
			OutletTopUpsForm outletTopUpsForm) {
		return outletTopUpsDao.getOutletTopUpsList(outletTopUpsForm);
	}

	@Override
	public void forOutletTopup(OutletTopUpsForm outletTopUpsForm) {
		outletTopUpsDao.forOutletTopup(outletTopUpsForm);
	}

	@Override
	public List<OutletTopUps> getOutletListByUser(short userId) {
		return outletTopUpsDao.getOutletListByUser(userId);
	}

	@Override
	public OutletTopUps getOutletTopUpsByPk(String fundNo) {
		return outletTopUpsDao.getOutletTopUpsByPk(fundNo);
	}

	@Override
	public List<OutletTopUps> getOutletTopUpsById(String agencyCode) {
		return outletTopUpsDao.getOutletTopUpsById(agencyCode);
	}
	
	@Override
	public Agencys getAgencyName(String agencyCode) {
		return outletTopUpsDao.getAgencyName(agencyCode);
	}

	@Override
	public OutletTopUpsForm getOutletInfo(String agencyCode) {
		return outletTopUpsDao.getOutletInfo(agencyCode);
	}

	@Override
	public OutletAccount getAgencyBalance(String agencyCode) {
		return outletTopUpsDao.getAgencyBalance(agencyCode);
	}

	@Override
	public void forOutletCashWithdrawn(CashWithdrawnForm cashWithdrawnForm) {
		
		outletTopUpsDao.forOutletCashWithdrawn(cashWithdrawnForm);
		
	}



}
