package cls.pilottery.oms.business.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import cls.pilottery.oms.business.form.AgencyForm;
import cls.pilottery.oms.business.model.Agency;
import cls.pilottery.oms.business.model.AgencyBank;
import cls.pilottery.oms.business.model.AgencyRefunVo;
import cls.pilottery.oms.business.model.OrgInfo;
import cls.pilottery.oms.business.model.Terminal;
import cls.pilottery.web.area.model.Areas;
import cls.pilottery.web.area.model.GameAuth;
import cls.pilottery.web.teller.model.Teller;

public interface AgencyDao {

	String getAgencyName(String agencyCode);

	List<AgencyBank> getBanks();

	Integer countAgencyList(AgencyForm agencyForm);

	List<Agency> queryAgencyList(AgencyForm agencyForm);

	void updateStatus(Agency agency);

	public Integer getSalerTellerByAgencode(String agencyCode);

	public Integer getSalerTermByAgenCode(String agencyCode);

	public List<GameAuth> selectGameFromAgencymap(Map<String, Object> map);

	Agency selectAgencyByCode(String code);

	List<GameAuth> selectGameFromAgency(String code);

	public AgencyRefunVo getRefunInfoByagencycode(String code);

	Integer ifAgencyCodeExist(@Param(value = "agencyCode") String agencyCode);

	public List<Areas> getAreaCodeByInstionCode(String orgCode);

	List<GameAuth> getGameFromArea(String code);

	List<OrgInfo> getOrgListByOrgCode(String orgCode);

	List<Terminal> getTerminalByAgencyCode(String agencycode);

	List<Teller> getTellerByAgencyCode(String agencycode);
}
