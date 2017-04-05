package cls.pilottery.web.outlet.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.web.outlet.dao.OutletDao;
import cls.pilottery.web.outlet.form.AddOutlet;
import cls.pilottery.web.outlet.form.AgencyDealRecordForm;
import cls.pilottery.web.outlet.form.DetailsForm;
import cls.pilottery.web.outlet.form.ListOutletForm;
import cls.pilottery.web.outlet.form.ResetPassowrd;
import cls.pilottery.web.outlet.model.Area;
import cls.pilottery.web.outlet.model.Bank;
import cls.pilottery.web.outlet.model.FlowAgency;
import cls.pilottery.web.outlet.model.FundDailyRecord;
import cls.pilottery.web.outlet.model.MarketAdmin;
import cls.pilottery.web.outlet.model.Orgs;
import cls.pilottery.web.outlet.model.StoreType;
import cls.pilottery.web.outlet.service.OutletService;

/**
 * 
 * @describe 站点管理Impl
 * 
 */
@Service
public class OutletServiceImpl implements OutletService {

	public static Logger logger = Logger.getLogger(OutletServiceImpl.class);

	@Autowired
	private OutletDao dao;

	public OutletDao getDao() {

		return dao;
	}

	public void setDao(OutletDao dao) {

		this.dao = dao;
	}

	@Override
	public List<Orgs> getInstitution(String insCode) {

		return dao.getInstitution(insCode);
	}




	@Override
	public List<Bank> getAllBank() {

		return dao.getBank();
	}

	@Override
	public List<StoreType> getAllStoreType() {

		return dao.getStore();
	}

	@Override
	public List<Area> getAreaOfIns(String code) {

		return dao.getInsOrg(code);
	}

	@Override
	public void addOutlet(AddOutlet outlet) {

		dao.addOutlet(outlet);
	}

	@Override
	public List<ListOutletForm> listOutlet(String institutionCode) {

		return dao.listOutlet(institutionCode);
	}

	@Override
	public List<ListOutletForm> selectByCodeInsti(ListOutletForm code) {

		return dao.selectByCodeInsti(code);
	}

	@Override
	public DetailsForm getByCode(String code) {

		return dao.getByCode(code);
	}

	@Override
	public void modifyOutlet(AddOutlet outlet) {

		dao.modifyOutlet(outlet);
	}

	@Override
	public int deleteupdeSatus(String outletCode) {

		int result = 0;
		try {
			this.dao.deleteupdeSatus(outletCode);
		} catch (Exception e) {
			result = 1;
		}
		return result;
	}

	@Override
	public List<FlowAgency> selectAgencyFlowForPOS(FlowAgency flow) {

		if (dao == null)
			return null;
		return dao.selectAgencyFlowForPOS(flow);
	}

	@Override
	public FlowAgency selectAgencyAccForPOS(String code) {

		if (dao == null)
			return null;
		return dao.selectAgencyAccForPOS(code);
	}

	@Override
	public void forOutletPopup(FlowAgency flow) {

		if (dao == null)
			return;
		dao.forOutletPopup(flow);
	}

	@Override
	public void forOutletWithdrawApp(FlowAgency flow) {

		if (dao == null)
			return;
		dao.forOutletWithdrawApp(flow);
	}

	@Override
	public void forOutletWithdrawCon(FlowAgency flow) {

		if (dao == null)
			return;
		dao.forOutletWithdrawCon(flow);
	}

	@Override
	public List<MarketAdmin> getMaketAdminByInscode(String insCode) {

		return dao.getMaketAdminByInscode(insCode);
	}

	@Override
	public Integer getAgencyCount(AgencyDealRecordForm dealRecordForm) {

		return dao.getAgencyCount(dealRecordForm);
	}

	@Override
	public List<AgencyDealRecordForm> getAgencyDealList(AgencyDealRecordForm dealRecordForm) {

		return dao.getAgencyDealList(dealRecordForm);
	}

	@Override
	public Integer getOutletCount(ListOutletForm form) {

		return dao.getOutletCount(form);
	}

	@Override
	public Integer getFundDailyCount(AgencyDealRecordForm agencyForm) {

		return dao.getFundDailyCount(agencyForm);
	}

	@Override
	public List<FundDailyRecord> getFundDailyList(AgencyDealRecordForm agencyForm) {

		return dao.getFundDailyList(agencyForm);
	}

	@Override
	public DetailsForm getByCodeAndMM(String code, long userId) {
		return dao.getByCodeAndMM(code, userId);
	}

	@Override
	public long selectBalance(String outletCode) {
		return dao.selectBalance(outletCode);
	}

	@Override
	public int enable(String outletCode) {

		return dao.enable(outletCode);
	}

	@Override
	public int disable(String outletCode) {

		return dao.disable(outletCode);
	}

	@Override
	public int resetPass(ResetPassowrd reset) {

		return dao.resetPass(reset);
	}

	@Override
	public String getAgencysCodeByname(AddOutlet outlet) {
		// TODO Auto-generated method stub
		return this.dao.getAgencysCodeByname(outlet);
	}

	@Override
	public List<Integer> getFlowTypeList() {
		List<Integer> flowList = dao.getFlowTypeList();	
		return flowList;
	}


}
