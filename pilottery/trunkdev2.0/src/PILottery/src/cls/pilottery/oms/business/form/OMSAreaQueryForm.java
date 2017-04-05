package cls.pilottery.oms.business.form;

import cls.pilottery.common.entity.AbstractEntity;

public class OMSAreaQueryForm extends AbstractEntity {

	private static final long serialVersionUID = -7793816552330184899L;
	private String areaName;
	private String areaCode;
	
	public String getAreaName() {
		return areaName;
	}
	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}
	public String getAreaCode() {
		return areaCode;
	}
	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}
}
