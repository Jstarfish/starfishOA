package cls.pilottery.web.system.form;

import cls.pilottery.common.model.BaseEntity;

public class SysParameterForm extends BaseEntity {
	private static final long serialVersionUID = -6029229281327045161L;
	private String id;
	private String desc;
	private String value;
	private int currentUserId;

	public int getCurrentUserId() {
		return currentUserId;
	}

	public void setCurrentUserId(int currentUserId) {
		this.currentUserId = currentUserId;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

}
