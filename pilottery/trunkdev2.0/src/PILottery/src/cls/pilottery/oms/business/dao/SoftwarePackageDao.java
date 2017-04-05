package cls.pilottery.oms.business.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.oms.business.model.tmversionmodel.PackageContext;
import cls.pilottery.oms.business.model.tmversionmodel.SimpleSoftPack;
import cls.pilottery.oms.business.model.tmversionmodel.SoftwarePackage;

public interface SoftwarePackageDao {

	List<SoftwarePackage> getSoftwarePackages(SoftwarePackage softwarePackage);

	void insertPackage(SoftwarePackage softPackage);

	void insertPackageContext(PackageContext packcontext);

	void updatePackageValid(SoftwarePackage softPackage);

	// for update versions in this package
	void deletePackageContext(SoftwarePackage softPackage);

	List<SimpleSoftPack> getPackVersForTermType(int termType);

	int getCount();

	Integer ifExistSoftWarePackageNo(Map<String, String> map);

	Integer ifBiggerThanOther(Map<String, String> map);

	String maxSoftwarePackNo(Map<String, String> map);

	String getPlanName(Integer planId);

	List<Map<String, String>> validSoftVersionNo();

	Integer isFullNum(String terminalType);

	String getUpdateTime(Integer planId);
}
