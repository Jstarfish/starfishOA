package cls.pilottery.web.teller.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.business.form.AgencyForm;
import cls.pilottery.web.teller.dao.TellerDao;
import cls.pilottery.web.teller.form.TellerForm;
import cls.pilottery.web.teller.model.Teller;
import cls.pilottery.web.teller.service.TellerService;

@Service
public class TellerServiceImpl implements TellerService{

	@Autowired
	private TellerDao tellerDao;

	@Override
	public List<Teller> getTellerList() {
		// TODO Auto-generated method stub
		return tellerDao.selectTellerList();
	}

	@Override
	public void addTeller(Teller teller) {
		// TODO Auto-generated method stub
		tellerDao.insertTeller(teller);
	}

	@Override
	public void deleteTeller(Teller teller) {
		// TODO Auto-generated method stub
		tellerDao.deleteTeller(teller);
	}

	@Override
	public Teller getTellerByCode(Long code) {
		// TODO Auto-generated method stub
		return tellerDao.selectTellerByCode(code);
	}

	@Override
	public void updateTeller(Teller teller) {
		// TODO Auto-generated method stub
		tellerDao.updateTeller(teller);
	}

	@Override
	public void updateStatus(Teller teller) {
		// TODO Auto-generated method stub
		tellerDao.updateStatus(teller);
	}

	@Override
	public void resetPassword(Teller teller) {
		// TODO Auto-generated method stub
		tellerDao.resetPassword(teller);
	}

	@Override
	public Integer countTellerList(TellerForm tellerForm) {
		// TODO Auto-generated method stub
		return tellerDao.countTellerList(tellerForm);
	}

	@Override
	public List<Teller> queryTellerList(TellerForm tellerForm) {
		// TODO Auto-generated method stub
		return tellerDao.queryTellerList(tellerForm);
	}
	
	@Override
	public Integer isRepeatTellerNo(Map<String, String> map) {
		return tellerDao.isRepeatTellerNo(map);
	}

	@Override
	public Integer countTellerByAgencyCode(AgencyForm agencyForm) {
		// TODO Auto-generated method stub
		return this.tellerDao.countTellerByAgencyCode(agencyForm);
	}

	@Override
	public List<Teller> queryTellerListByAgencyCode(AgencyForm agencyForm) {
		// TODO Auto-generated method stub
		return this.tellerDao.queryTellerListByAgencyCode(agencyForm);
	}

	@Override
	public String getRecomandNum() {
		// TODO Auto-generated method stub
		return this.tellerDao.getRecomandNum();
	}
}
