package cls.pilottery.web.teller.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.oms.business.form.AgencyForm;
import cls.pilottery.web.teller.form.TellerForm;
import cls.pilottery.web.teller.model.Teller;

public interface TellerDao {

	List<Teller> selectTellerList();

	Integer countTellerList(TellerForm tellerForm);

	List<Teller> queryTellerList(TellerForm tellerForm);

	Teller selectTellerByCode(Long code);

	// 新增销售员
	void insertTeller(Teller teller);

	// 删除销售员
	void deleteTeller(Teller teller);

	// 修改销售员
	void updateTeller(Teller teller);

	// 修改销售员状态
	void updateStatus(Teller teller);

	// 重置密码
	void resetPassword(Teller teller);

	Integer isRepeatTellerNo(Map<String, String> map);

	Integer countTellerByAgencyCode(AgencyForm agencyForm);

	List<Teller> queryTellerListByAgencyCode(AgencyForm agencyForm);

	public String getRecomandNum();
}
