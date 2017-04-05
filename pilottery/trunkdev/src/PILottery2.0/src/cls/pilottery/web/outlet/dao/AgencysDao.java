package cls.pilottery.web.outlet.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import cls.pilottery.web.area.model.GameAuth;
import cls.pilottery.web.outlet.form.AddOutlet;
import cls.pilottery.web.outlet.form.AgencyDealRecordForm;
import cls.pilottery.web.outlet.form.DetailsForm;
import cls.pilottery.web.outlet.form.ListOutletForm;
import cls.pilottery.web.outlet.form.ResetPassowrd;
import cls.pilottery.web.outlet.model.Agencys;
import cls.pilottery.web.outlet.model.Area;
import cls.pilottery.web.outlet.model.Bank;
import cls.pilottery.web.outlet.model.FlowAgency;
import cls.pilottery.web.outlet.model.FundDailyRecord;
import cls.pilottery.web.outlet.model.MarketAdmin;
import cls.pilottery.web.outlet.model.Orgs;
import cls.pilottery.web.outlet.model.StoreType;

public interface AgencysDao {

	int deleteByPrimaryKey(String agencyCode);

	int insert(Agencys record);

	int insertSelective(Agencys record);

	Agencys selectByPrimaryKey(String agencyCode);

	int updateByPrimaryKeySelective(Agencys record);

	int updateByPrimaryKey(Agencys record);

	List<Orgs> getInstitution(String insCode);

	List<StoreType> getStore();

	List<Bank> getBank();

	void addOutlet(AddOutlet outlet);

	void modifyOutlet(AddOutlet outlet);

	List<MarketAdmin> getMaketAdminByInscode(String insCode);

	List<ListOutletForm> listOutlet(String institutionCode);

	// add by dzg 查询站点资金流水
	List<FlowAgency> selectAgencyFlowForPOS(FlowAgency flow);

	FlowAgency selectAgencyAccForPOS(String code);

	// 站点缴款
	void forOutletPopup(FlowAgency flow);

	// 提现申请
	void forOutletWithdrawApp(FlowAgency flow);

	// 提现确认
	void forOutletWithdrawCon(FlowAgency flow);

	List<ListOutletForm> selectByCodeInsti(ListOutletForm code);

	DetailsForm getByCode(String code);
	
	//add by dzg 用于手持终端，根据编码和市场管理人员查询站点
	DetailsForm getByCodeAndMM(@Param("code") String code,@Param("userid") long userId);

	void deleteupdeSatus(String outletCode);

	Integer getAgencyCount(AgencyDealRecordForm dealRecordForm);

	List<AgencyDealRecordForm> getAgencyDealList(AgencyDealRecordForm dealRecordForm);

	Integer getOutletCount(ListOutletForm form);

	Integer getFundDailyCount(AgencyDealRecordForm agencyForm);

	List<FundDailyRecord> getFundDailyList(AgencyDealRecordForm agencyForm);

	List<Area> getInsOrg(String code);

	long selectBalance(String outletCode);

	int enable(String outletCode);

	int disable(String outletCode);

	int resetPass(ResetPassowrd reset);
	public String getAgencysCodeByname(AddOutlet outlet);

}