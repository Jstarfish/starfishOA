package cls.pilottery.web.outlet.service;

import java.util.List;
import java.util.Map;

import cls.pilottery.web.area.model.GameAuth;
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

/**
 * 
 * @describe 站点管理service
 * 
 */
public interface OutletService {

	/**
	 * 获取所有组织
	 * 
	 * @param insCode
	 * 
	 * @return
	 */
	List<Orgs> getInstitution(String insCode);

	/**
	 * 获取市场管理员by机构
	 * 
	 * @return
	 */
	List<MarketAdmin> getMaketAdminByInscode(String insCode);

	/**
	 * 获取所有银行
	 * 
	 * @return
	 */
	List<Bank> getAllBank();

	/**
	 * 获取所有商店类型
	 * 
	 * @return
	 */
	List<StoreType> getAllStoreType();

	/**
	 * 通过组织id获取组织下的区域列表
	 * 
	 * @param code
	 * @return
	 */
	List<Area> getAreaOfIns(String code);

	/**
	 * 添加站点
	 * 
	 * @param outlet
	 * @return
	 */
	void addOutlet(AddOutlet outlet);

	/*
	 * POS机上查询站点流水
	 */
	List<FlowAgency> selectAgencyFlowForPOS(FlowAgency flow);

	/*
	 * 通过编号查询站点账户信息
	 */
	FlowAgency selectAgencyAccForPOS(String code);

	// 站点缴款
	void forOutletPopup(FlowAgency flow);

	// 提现申请
	void forOutletWithdrawApp(FlowAgency flow);

	// 提现确认
	void forOutletWithdrawCon(FlowAgency flow);

	List<ListOutletForm> listOutlet(String institutionCode);

	List<ListOutletForm> selectByCodeInsti(ListOutletForm code);

	DetailsForm getByCode(String code);

	DetailsForm getByCodeAndMM(String code, long userId);

	void modifyOutlet(AddOutlet outlet);

	int deleteupdeSatus(String outletCode);

	Integer getAgencyCount(AgencyDealRecordForm dealRecordForm);

	Integer getOutletCount(ListOutletForm form);

	List<AgencyDealRecordForm> getAgencyDealList(AgencyDealRecordForm dealRecordForm);

	Integer getFundDailyCount(AgencyDealRecordForm agencyForm);

	List<FundDailyRecord> getFundDailyList(AgencyDealRecordForm agencyForm);

	long selectBalance(String outletCode);

	int enable(String outletCode);

	int disable(String outletCode);

	int resetPass(ResetPassowrd reset);

	public String getAgencysCodeByname(AddOutlet outlet);

	List<Integer> getFlowTypeList();

	int getOutletFlowCount(String outletCode);
}
