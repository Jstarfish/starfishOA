package cls.pilottery.web.area.form;

import java.io.Serializable;

import cls.pilottery.common.model.BaseEntity;

public class AreaForm extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 3575568988484848L;

	private String areaCode; // 区域编号

	private String areaName; // 区域名称

	private String parentAreaName; // 父区域名称

	private Short status; // 区域状态

	private String statusShow;

	public String getStatusShow() {

		return statusShow;
	}

	public void setStatusShow(String statusShow) {

		this.statusShow = statusShow;
	}

	private Short type; // 区域类型

	private String typeShow;

	public String getTypeShow() {

		return typeShow;
	}

	public void setTypeShow(String typeShow) {

		this.typeShow = typeShow;
	}

	public String getAreaCode() {

		return areaCode;
	}

	public AreaForm() {

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

	public String getParentAreaName() {

		return parentAreaName;
	}

	public void setParentAreaName(String parentAreaName) {

		this.parentAreaName = parentAreaName;
	}

	public Short getStatus() {

		return status;
	}

	public void setStatus(Short status) {

		this.status = status;
	}

	public Short getType() {

		return type;
	}

	public void setType(Short type) {

		this.type = type;
	}
}
