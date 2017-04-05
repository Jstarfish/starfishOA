package cls.pilottery.oms.business.model.tmversionmodel;

import java.util.Date;
import java.util.List;

import cls.pilottery.common.model.BaseEntity;
import cls.pilottery.oms.business.model.TerminalType;

public class SoftwarePackage extends BaseEntity {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1300753325962840970L;
	private String packageVersion;
	private int terminalType;
	private TerminalType terminalTypes;
	private String packageDescription;
	private Date releaseDate;
	private String releaseDateToChar;
	private int isValid = 1;
	private List<PackageContext> softwareVersionList;

	public String getPackageVersion() {
		return packageVersion;
	}

	public void setPackageVersion(String packageVersion) {
		this.packageVersion = packageVersion;
	}

	public int getTerminalType() {
		return terminalType;
	}

	public void setTerminalType(int terminalType) {
		this.terminalType = terminalType;
	}

	public String getPackageDescription() {
		return packageDescription;
	}

	public void setPackageDescription(String packageDescription) {
		this.packageDescription = packageDescription;
	}

	public Date getReleaseDate() {
		return releaseDate;
	}

	public void setReleaseDate(Date releaseDate) {
		this.releaseDate = releaseDate;
	}

	public int getIsValid() {
		return isValid;
	}

	public void setIsValid(int isValid) {
		this.isValid = isValid;
	}

	public List<PackageContext> getSoftwareVersionList() {
		return softwareVersionList;
	}

	public void setSoftwareVersionList(List<PackageContext> softwareVersionList) {
		this.softwareVersionList = softwareVersionList;
	}

	public String getVersionsString() {
		if (softwareVersionList == null || softwareVersionList.size() <= 0)
			return "";
		StringBuilder sb = new StringBuilder();
		for (PackageContext pc : softwareVersionList) {
			sb.append(pc.getSoftId());
			sb.append(":");
			sb.append(pc.getSoftVersion());
			sb.append(";");
		}
		return sb.toString();
	}

	public String getReleaseDateToChar() {
		return releaseDateToChar;
	}

	public void setReleaseDateToChar(String releaseDateToChar) {
		this.releaseDateToChar = releaseDateToChar;
	}

	public TerminalType getTerminalTypes() {
		return terminalTypes;
	}

	public void setTerminalTypes(TerminalType terminalTypes) {
		this.terminalTypes = terminalTypes;
	}

}
