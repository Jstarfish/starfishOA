package cls.pilottery.oms.business.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.business.dao.SoftwareVersionDao;
import cls.pilottery.oms.business.model.tmversionmodel.Software;
import cls.pilottery.oms.business.model.tmversionmodel.SoftwareVersion;
import cls.pilottery.oms.business.service.SoftwareService;

@Service
public class SoftwareServiceImpl implements SoftwareService {

	@Autowired
	private SoftwareVersionDao softVersionDao;

	@Override
	public List<Software> getSoftwares() {

		if (softVersionDao != null)
			return softVersionDao.getSoftwares();
		return null;
	}

	@Override
	public Software getSoftware(int id) {
		if (softVersionDao != null)
			return softVersionDao.getSoftware(id);
		return null;
	}

	@Override
	public List<SoftwareVersion> getSoftVersions(int id) {
		if (softVersionDao != null)
			return softVersionDao.getSoftVersions(id);
		return null;
	}

	@Override
	public SoftwareVersion getSoftVersion(int id, String version) {
		if (softVersionDao != null)
			return softVersionDao.getSoftVersion(id, version);
		return null;
	}

	@Override
	public void intsertSoftVer(SoftwareVersion ver) {
		if (softVersionDao != null)
			softVersionDao.intsertSoftVer(ver);
	}

	@Override
	public void updateSoftVer(SoftwareVersion ver) {
		if (softVersionDao != null)
			softVersionDao.updateSoftVer(ver);
	}

	@Override
	public boolean deleteSoftVer(SoftwareVersion ver) {

		try {
			softVersionDao.deleteSoftVer(ver);

		} catch (Exception ex) {

			return false;
		}
		return true;

	}

	@Override
	public List<SoftwareVersion> getSoftVersForTermType(SoftwareVersion softVer) {
		// TODO Auto-generated method stub
		return softVersionDao.getSoftVersForTermType(softVer);
	}

}
