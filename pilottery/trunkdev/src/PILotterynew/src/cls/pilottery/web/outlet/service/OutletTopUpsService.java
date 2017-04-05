package cls.pilottery.web.outlet.service;

import java.util.List;

import cls.pilottery.web.capital.form.CashWithdrawnForm;
import cls.pilottery.web.capital.model.OutletAccount;
import cls.pilottery.web.outlet.form.OutletTopUpsForm;
import cls.pilottery.web.outlet.model.Agencys;
import cls.pilottery.web.outlet.model.OutletTopUps;

public interface OutletTopUpsService {

		// 总记录数
		public Integer getOutletTopUpsCount(OutletTopUpsForm outletTopUpsForm);

		// 每页显示的List
		public List<OutletTopUps> getOutletTopUpsList(OutletTopUpsForm outletTopUpsForm);
		
		public void forOutletTopup(OutletTopUpsForm outletTopUpsForm);
		
		//根据当前用户id获取列表
		List<OutletTopUps> getOutletListByUser(short userId);
		
		OutletTopUps getOutletTopUpsByPk(String fundNo);
		
		List<OutletTopUps> getOutletTopUpsById(String agencyCode);
		
		//联动。。will modify
		public Agencys getAgencyName(String agencyCode);
		
		public OutletAccount getAgencyBalance(String agencyCode);
		
		public OutletTopUpsForm getOutletInfo(String agencyCode);
		
		public void forOutletCashWithdrawn(CashWithdrawnForm cashWithdrawnForm);
}
