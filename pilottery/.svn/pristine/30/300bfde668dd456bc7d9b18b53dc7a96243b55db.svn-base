package cls.pilottery.oms.business.service;

import java.util.List;

import cls.pilottery.oms.business.form.tmversionform.TerminalSoftWareForm;
import cls.pilottery.oms.business.model.tmversionmodel.Software;
import cls.pilottery.oms.business.model.tmversionmodel.SoftwareVersion;
import cls.pilottery.oms.business.model.tmversionmodel.TerminalSoftWare;

public interface TerminalSoftwareService {

	List<Software> getSoftwares();

	Software getSoftware(int id);

	List<SoftwareVersion> getSoftVersions(int id);

	SoftwareVersion getSoftVersion(int id, String version);

	void intsertSoftVer(SoftwareVersion ver);

	void updateSoftVer(SoftwareVersion ver);

	void deleteSoftVer(SoftwareVersion ver);

	Integer countTerminalSoftware(TerminalSoftWareForm terminalSoftWareForm);

	List<TerminalSoftWare> getTerminalSoftWareQuery(
			TerminalSoftWareForm terminalSoftWareForm);
}
