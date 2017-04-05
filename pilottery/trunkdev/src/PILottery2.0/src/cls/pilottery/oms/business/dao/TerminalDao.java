package cls.pilottery.oms.business.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import cls.pilottery.oms.business.form.AgencyForm;
import cls.pilottery.oms.business.form.TerminalForm;
import cls.pilottery.oms.business.model.Terminal;
import cls.pilottery.oms.business.model.TerminalType;

public interface TerminalDao {

	String recomandNum(String agencyCode);

	Integer selectTerminalLimitInCity(String agencyCode);

	Integer selectTerminalCountInCity(String agencyCode);

	// 新增销售终端
	void insertTerminal(Terminal terminal);

	Integer selectSameMacCount(@Param(value = "macAddress") String macAddress);

	Integer countTerminalList(TerminalForm terminalForm);

	List<Terminal> queryTerminalList(TerminalForm terminalForm);

	// 修改销售终端状态
	void updateStatus(Terminal terminal);

	Terminal selectTerminalByCode(Long code);

	List<TerminalType> selectTerminalTypes();

	void updateTerminal(Terminal terminal);

	Integer selectTellerLimitInOrg(String agencyCode);

	Integer selectTellerCountInOrg(String agencyCode);
}
