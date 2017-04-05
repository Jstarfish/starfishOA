package cls.pilottery.oms.business.service;

import java.util.List;
import java.util.Map;

import cls.pilottery.oms.business.model.tmversionmodel.SimpleSoftPack;
import cls.pilottery.oms.business.model.tmversionmodel.SoftwarePackage;

public interface SoftwarePackageService {

	List<SoftwarePackage> getSoftwarePackages(SoftwarePackage softwarePackage);

	void insertPackage(SoftwarePackage softPackage);

	void updatePackageValid(SoftwarePackage softPackage);

	void updatePackageVersions(SoftwarePackage softPackage);

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
