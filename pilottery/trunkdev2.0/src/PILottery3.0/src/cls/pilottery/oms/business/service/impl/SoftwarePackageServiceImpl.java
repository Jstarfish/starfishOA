package cls.pilottery.oms.business.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cls.pilottery.oms.business.dao.SoftwarePackageDao;
import cls.pilottery.oms.business.model.tmversionmodel.PackageContext;
import cls.pilottery.oms.business.model.tmversionmodel.SimpleSoftPack;
import cls.pilottery.oms.business.model.tmversionmodel.SoftwarePackage;
import cls.pilottery.oms.business.service.SoftwarePackageService;

@Service
public class SoftwarePackageServiceImpl  implements SoftwarePackageService {

	@Autowired
	private SoftwarePackageDao packDao;
	
	@Override
	public List<SoftwarePackage> getSoftwarePackages(SoftwarePackage softwarePackage) {
		
		if(packDao != null)
			return packDao.getSoftwarePackages(softwarePackage);
		return null;
	}

	@Override
	public void insertPackage(SoftwarePackage softPackage) {
		// TODO Auto-generated method stub
		if(packDao != null)
		{
			packDao.insertPackage(softPackage);
//			List<PackageContext> pcs = softPackage.getSoftwareVersionList();
//			
//			for(PackageContext pc: pcs)
//			{
//				packDao.insertPackageContext(pc);
//			}
		}
	}



	@Override
	public void updatePackageValid(SoftwarePackage softPackage) {
		// TODO Auto-generated method stub
		if(packDao != null)
			packDao.updatePackageValid(softPackage);
	}

	@Override
	public void updatePackageVersions(SoftwarePackage softPackage) {
		// TODO Auto-generated method stub
		if(packDao != null)
		{
			packDao.deletePackageContext(softPackage);
			List<PackageContext> pcs = softPackage.getSoftwareVersionList();
			for(PackageContext pc: pcs)
			{
				packDao.insertPackageContext(pc);
			}
		}
	}

	@Override
	public List<SimpleSoftPack> getPackVersForTermType(int termType) {
		// TODO Auto-generated method stub
		return packDao.getPackVersForTermType(termType);
	}

	@Override
	public int getCount() {
		
		return packDao.getCount();
	}

	@Override
	public Integer ifExistSoftWarePackageNo(Map<String, String> map) {
		return packDao.ifExistSoftWarePackageNo(map);
	}

	@Override
	public Integer ifBiggerThanOther(Map<String, String> map) {
		return packDao.ifBiggerThanOther(map);
	}

	@Override
	public String maxSoftwarePackNo(Map<String, String> map) {
		return packDao.maxSoftwarePackNo(map);
	}

	@Override
	public String getPlanName(Integer planId) {
		return packDao.getPlanName(planId);
	}

	@Override
	public List<Map<String, String>> validSoftVersionNo() {
		return packDao.validSoftVersionNo();
	}

	@Override
	public Integer isFullNum(String terminalType) {
		return packDao.isFullNum(terminalType);
	}

	@Override
	public String getUpdateTime(Integer planId) {
		return packDao.getUpdateTime(planId);
	}

}
