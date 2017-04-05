package cls.pilottery.web.teller.service;

import java.util.List;
import java.util.Map;

import cls.pilottery.common.service.BaseService;
import cls.pilottery.oms.business.form.AgencyForm;
import cls.pilottery.web.teller.form.TellerForm;
import cls.pilottery.web.teller.model.Teller;

public interface TellerService extends BaseService {

	List<Teller> getTellerList();

	Integer countTellerList(TellerForm tellerForm);

	List<Teller> queryTellerList(TellerForm tellerForm);

	Teller getTellerByCode(Long code);

	void addTeller(Teller teller);

	void deleteTeller(Teller teller);

	void updateTeller(Teller teller);

	void updateStatus(Teller teller);

	void resetPassword(Teller teller);

	Integer isRepeatTellerNo(Map<String, String> map);

	Integer countTellerByAgencyCode(AgencyForm agencyForm);

	List<Teller> queryTellerListByAgencyCode(AgencyForm agencyForm);

	public String getRecomandNum();
}
