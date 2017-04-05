package cls.pilottery.web.area.form;

import java.io.Serializable;

public class AreaQueryForm implements Serializable {
	private static final long serialVersionUID = 454982405391627834L;

	private Long areaCode;

	private Long belongAreaCode;

	private String areaName;

	private int areaStatus;

	private String allCities;

	private Long curCityCode;

	private String curCityName;

	private String areaCodeForm;

	private String excelTitle;

	private boolean isCurCountry() {
		return curCityCode == 0;
	}

	private boolean isCurProvince() {
		return ((curCityCode > 0) && (curCityCode <= 99));
	}

	private boolean isCurCity() {
		return ((curCityCode > 100) && (curCityCode <= 9999));
	}

	public AreaQueryForm() {
	}

	public int getAreaStatus() {
		return areaStatus;
	}

	public void setAreaStatus(int areaStatus) {
		this.areaStatus = areaStatus;
	}

	public Long getMinAreaCode() {
		if (isCurCountry()) {
			return curCityCode;
		} else if (isCurProvince()) {
			return curCityCode * 100L;
		} else if (isCurCity()) {
			return curCityCode;
		} else
			return -1L;
	}

	public Long getMaxAreaCode() {
		if (isCurCountry()) {
			return curCityCode + 9999L;
		} else if (isCurProvince()) {
			return curCityCode * 100L + 99L;
		} else if (isCurCity()) {
			return curCityCode;
		} else
			return -1L;
	}

	public Long getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(Long areaCode) {
		this.areaCode = areaCode;
	}

	public String getAreaName() {
		return areaName;
	}

	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}

	public String getAllCities() {
		return allCities;
	}

	public void setAllCities(String allCities) {
		this.allCities = allCities;
	}

	public Long getCurCityCode() {
		return curCityCode;
	}

	public void setCurCityCode(Long curCityCode) {
		this.curCityCode = curCityCode;
	}

	public String getCurCityName() {
		return curCityName;
	}

	public void setCurCityName(String curCityName) {
		this.curCityName = curCityName;
	}

	public Long getBelongAreaCode() {
		return belongAreaCode;
	}

	public void setBelongAreaCode(Long belongAreaCode) {
		this.belongAreaCode = belongAreaCode;
	}

	public String getAreaCodeForm() {
		return areaCodeForm;
	}

	public void setAreaCodeForm(String areaCodeForm) {
		this.areaCodeForm = areaCodeForm;
	}

	public String getExcelTitle() {
		return excelTitle;
	}

	public void setExcelTitle(String excelTitle) {
		this.excelTitle = excelTitle;
	}
}
