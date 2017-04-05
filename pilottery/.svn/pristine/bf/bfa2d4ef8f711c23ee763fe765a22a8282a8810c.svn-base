package cls.pilottery.oms.business.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.business.dao.TerminalSoftwareDao;
import cls.pilottery.oms.business.form.tmversionform.TerminalSoftWareForm;
import cls.pilottery.oms.business.model.tmversionmodel.Software;
import cls.pilottery.oms.business.model.tmversionmodel.SoftwareVersion;
import cls.pilottery.oms.business.model.tmversionmodel.TerminalSoftWare;
import cls.pilottery.oms.business.service.TerminalSoftwareService;

@Service
public class TerminalSoftwareServiceImpl implements TerminalSoftwareService {

	@Autowired
	private TerminalSoftwareDao terminalSoftwareDao;

	@Override
	public List<Software> getSoftwares() {

		if (terminalSoftwareDao != null)
			return terminalSoftwareDao.getSoftwares();
		return null;
	}

	@Override
	public List<SoftwareVersion> getSoftVersions(int id) {
		if (terminalSoftwareDao != null)
			return terminalSoftwareDao.getSoftVersions(id);
		return null;
	}

	@Override
	public SoftwareVersion getSoftVersion(int id, String version) {
		if (terminalSoftwareDao != null)
			return terminalSoftwareDao.getSoftVersion(id, version);
		return null;
	}

	@Override
	public Software getSoftware(int id) {
		if (terminalSoftwareDao != null)
			return terminalSoftwareDao.getSoftware(id);
		return null;
	}

	@Override
	public void intsertSoftVer(SoftwareVersion ver) {
		if (terminalSoftwareDao != null)
			terminalSoftwareDao.intsertSoftVer(ver);
	}

	@Override
	public void updateSoftVer(SoftwareVersion ver) {
		if (terminalSoftwareDao != null)
			terminalSoftwareDao.updateSoftVer(ver);
	}

	@Override
	public void deleteSoftVer(SoftwareVersion ver) {
		if (terminalSoftwareDao != null)
			terminalSoftwareDao.deleteSoftVer(ver);
	}

	@Override
	public Integer countTerminalSoftware(
			TerminalSoftWareForm terminalSoftWareForm) {
		return terminalSoftwareDao.countTerminalSoftware(terminalSoftWareForm);
	}

	@Override
	public List<TerminalSoftWare> getTerminalSoftWareQuery(
			TerminalSoftWareForm terminalSoftWareForm) {
		return terminalSoftwareDao
				.getTerminalSoftWareQuery(terminalSoftWareForm);
	}

}
