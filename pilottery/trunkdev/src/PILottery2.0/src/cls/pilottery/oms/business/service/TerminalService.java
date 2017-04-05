package cls.pilottery.oms.business.service;

import java.util.List;

import cls.pilottery.common.service.BaseService;
import cls.pilottery.oms.business.form.TerminalForm;
import cls.pilottery.oms.business.model.Terminal;
import cls.pilottery.oms.business.model.TerminalType;

public interface TerminalService extends BaseService {

	String recomandNum(String agencyCode);

	boolean verifyTerminalLimitInCity(String agencyCode);

	void addTerminal(Terminal terminal);

	Integer selectSameMacCount(String macAddress);

	Integer countTerminalList(TerminalForm terminalForm);

	List<Terminal> queryTerminalList(TerminalForm terminalForm);

	void updateStatus(Terminal terminal);

	Terminal getTerminalByCode(Long code);

	List<TerminalType> selectTerminalTypes();

	void updateTerminal(Terminal terminal);
	
	boolean verifyTellerLimitInOrgs(String agencyCode);
}