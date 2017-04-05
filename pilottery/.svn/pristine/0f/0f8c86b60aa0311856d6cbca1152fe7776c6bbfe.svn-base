package cls.pilottery.web.payout.dao;

import java.util.List;

import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.payout.model.PayoutRecord;
import cls.pilottery.web.payout.model.WinInfo;
import cls.pilottery.web.plans.form.PlanForm;

public interface PayoutDao {

	Integer getPayoutCount(PayoutRecord payout);

	List<PayoutRecord> getPayoutList(PayoutRecord payout);

	Integer isValided(WinInfo wininfo);

	PayoutRecord getNum(PayoutRecord safeCode);
	
	void payout(PayoutRecord record);
	
	void payoutQuery(WinInfo win);
	
	InfOrgs getOrgByUser(long userId);
	
	String getPayFlow1(String code);
	
	String getAmount(PayoutRecord form);

	PayoutRecord getPayoutDetail(String recordNo);

	String getUsername(long userid);

	PayoutRecord getPrintRecord(String recordNo);

	String getPlanName(String planCode);

	int isCompleted(PlanForm form);
}
