package cls.pilottery.oms.business.service;

import java.util.List;
import java.util.Map;

import cls.pilottery.oms.business.form.AgencyForm;
import cls.pilottery.oms.business.form.OutletClearInfo;
import cls.pilottery.oms.business.model.Agency;
import cls.pilottery.oms.business.model.AgencyBank;
import cls.pilottery.oms.business.model.AgencyRefunVo;
import cls.pilottery.oms.business.model.OrgInfo;
import cls.pilottery.oms.business.model.Terminal;
import cls.pilottery.web.area.model.Areas;
import cls.pilottery.web.area.model.GameAuth;
import cls.pilottery.web.teller.model.Teller;

public interface AgencyService {

	List<AgencyBank> getBanks();

	String getAgencyName(String agencyCode);

	Integer countAgencyList(AgencyForm agencyForm);

	List<Agency> queryAgencyList(AgencyForm agencyForm);

	void updateStatus(Agency agency);

	public Integer getSalerTellerByAgencode(String agencyCode);

	public Integer getSalerTermByAgenCode(String agencyCode);

	public List<GameAuth> selectGameFromAgencymap(Map<String, Object> map);

	String batchInsertGameAuth(Agency agency);

	Agency getAgencyByCode(String code);

	List<GameAuth> getGameFromAgency(String code);

	public AgencyRefunVo getRefunInfoByagencycode(String code);

	Integer ifAgencyCodeExist(String agencyCode);

	public Areas getAreaCodeByInstionCode(String orgCode);

	List<GameAuth> getGameFromArea(String code);

	List<OrgInfo> getOrgListByOrgCode(String orgCode);

	List<Terminal> getTerminalByAgencyCode(String agencycode);

	List<Teller> getTellerByAgencyCode(String agencycode);

	void clearOutlet(OutletClearInfo info);
}
