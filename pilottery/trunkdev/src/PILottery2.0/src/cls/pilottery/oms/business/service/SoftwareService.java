package cls.pilottery.oms.business.service;

import java.util.List;

import cls.pilottery.oms.business.model.tmversionmodel.Software;
import cls.pilottery.oms.business.model.tmversionmodel.SoftwareVersion;

public interface SoftwareService {

	List<Software> getSoftwares();

	Software getSoftware(int id);

	List<SoftwareVersion> getSoftVersions(int id);

	SoftwareVersion getSoftVersion(int id, String version);

	void intsertSoftVer(SoftwareVersion ver);

	void updateSoftVer(SoftwareVersion ver);

	boolean deleteSoftVer(SoftwareVersion ver);

	List<SoftwareVersion> getSoftVersForTermType(SoftwareVersion softVer);
}
