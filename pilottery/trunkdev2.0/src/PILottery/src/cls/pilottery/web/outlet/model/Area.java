package cls.pilottery.web.outlet.model;

import java.io.Serializable;
/**
 * 区域类
 * @describe 用于区域下拉框
 *
 */
public class Area implements Serializable{
	private static final long serialVersionUID = 1L;

	private String areaCode;

	private String areaName;

	public String getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}

	public String getAreaName() {
		return areaName;
	}

	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}

	public Area() {
	}

	@Override
	public String toString() {
		return "Area [areaCode=" + areaCode + ", areaName=" + areaName + "]";
	}
}
