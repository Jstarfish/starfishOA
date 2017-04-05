package cls.pilottery.oms.business.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.business.dao.TerminalDao;
import cls.pilottery.oms.business.form.TerminalForm;
import cls.pilottery.oms.business.model.Terminal;
import cls.pilottery.oms.business.model.TerminalType;
import cls.pilottery.oms.business.service.TerminalService;

@Service
public class TerminalServiceImpl implements TerminalService{

	@Autowired
	private TerminalDao terminalDao;

	@Override
	public String recomandNum(String agencyCode) {
		return terminalDao.recomandNum(agencyCode);
	}
	@Override
	public boolean verifyTerminalLimitInCity(String agencyCode) {
		Integer limit = terminalDao.selectTerminalLimitInCity(agencyCode);
		Integer curCount = terminalDao.selectTerminalCountInCity(agencyCode);
		return limit > curCount;
	}
	@Override
	public void addTerminal(Terminal terminal) {
		terminalDao.insertTerminal(terminal);
	}
	@Override
	public Integer selectSameMacCount(String macAddress) {
		return terminalDao.selectSameMacCount(macAddress); 
	}
	@Override
	public Integer countTerminalList(TerminalForm terminalForm) {
		return terminalDao.countTerminalList(terminalForm);
	}
	@Override
	public List<Terminal> queryTerminalList(TerminalForm terminalForm) {
		return terminalDao.queryTerminalList(terminalForm);
	}
	@Override
	public void updateStatus(Terminal terminal) {
		terminalDao.updateStatus(terminal);
	}
	@Override
	public Terminal getTerminalByCode(Long code) {
		return terminalDao.selectTerminalByCode(code);
	}
	@Override
	public List<TerminalType> selectTerminalTypes() {
		return terminalDao.selectTerminalTypes();
	}
	@Override
	public void updateTerminal(Terminal terminal) {
		terminalDao.updateTerminal(terminal);
	}

	@Override
	public boolean verifyTellerLimitInOrgs(String agencyCode) {
		Integer limit = terminalDao.selectTellerLimitInOrg(agencyCode);
		Integer curCount = terminalDao.selectTellerCountInOrg(agencyCode);
		return limit > curCount;
	}

}
