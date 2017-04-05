package cls.pilottery.web.payout.service.imp;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.packinfo.PackInfo;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.payout.dao.PayoutDao;
import cls.pilottery.web.payout.model.PayoutRecord;
import cls.pilottery.web.payout.model.WinInfo;
import cls.pilottery.web.payout.service.PayoutService;
import cls.pilottery.web.plans.form.PlanForm;

@Service
public class PayoutServiceImpl implements PayoutService {

	@Autowired
	private PayoutDao dao;

	public PayoutDao getDao() {

		return dao;
	}

	public void setDao(PayoutDao dao) {

		this.dao = dao;
	}

	@Override
	public Integer getPayoutCount(PayoutRecord payout) {

		return dao.getPayoutCount(payout);
	}

	@Override
	public List<PayoutRecord> getPayoutList(PayoutRecord payout) {

		return dao.getPayoutList(payout);
	}

	@Override
	public WinInfo isValided(PackInfo info) {

		WinInfo wininfo = new WinInfo();
		wininfo.setPlanCode(info.getPlanCode());
		wininfo.setBatchNo(info.getBatchCode());
		wininfo.setPackageCode(info.getFirstPkgCode());
		String safeCode = info.getSafetyCode() + info.getPaySign();// 16+5
		wininfo.setSecurityString(safeCode);
		wininfo.setPayLevel(info.getPayLevel());
		dao.payoutQuery(wininfo);
		return wininfo;
	}

	@Override
	public String getNum(String safeCode) {

		String planCode = safeCode.substring(0, 5);
		String batchCode = safeCode.substring(5, 10);
		String packa = safeCode.substring(10, 17);
		PayoutRecord num = new PayoutRecord();
		num.setPlanCode(planCode);
		num.setBatchCode(batchCode);
		num.setPackages(packa);
		PayoutRecord num2 = dao.getNum(num);
		String s = null;
		if(num2 != null && StringUtils.isNotBlank(num2.getTrunk())){
			s = "Trunk:" + num2.getTrunk() + "  Box:" + num2.getBox() + "  Package:" + packa;
		}else{
			s = "PlanCode:"+planCode+" BatchCode:"+batchCode+" TicketNo:"+safeCode.substring(10, 20);
		}
		return s;
	}

	@Override
	public void payout(PayoutRecord record) {

		dao.payout(record);
	}

	@Override
	public InfOrgs getOrgByUser(long userId) {

		return dao.getOrgByUser(userId);
	}

	@Override
	public String getPayFlow1(String code) {

		return dao.getPayFlow1(code);
	}

	@Override
	public void payoutQuery(WinInfo win) {

		dao.payoutQuery(win);
	}

	@Override
	public String getAmount(PayoutRecord form) {

		return dao.getAmount(form);
	}

	@Override
	public PayoutRecord getPayoutDetail(String recordNo) {

		return dao.getPayoutDetail(recordNo);
	}

	@Override
	public String getUsername(long userid) {

		return dao.getUsername(userid);
	}

	@Override
	public PayoutRecord getPrintRecord(String recordNo) {

		return dao.getPrintRecord(recordNo);
	}

	@Override
	public String getPlanName(Map<String,String> map) {

		return dao.getPlanName(map);
	}

	@Override
	public int isCompleted(String planCode , String batchNo) {
		PlanForm form=new PlanForm();
		form.setPlanCodeQuery(planCode);
		form.setBatchNoQuery(batchNo);
		return dao.isCompleted(form);
	}

	@Override
	public void updateGuiPayRemark(PayoutRecord record) {
		dao.updateGuiPayRemark(record);
	}
}
