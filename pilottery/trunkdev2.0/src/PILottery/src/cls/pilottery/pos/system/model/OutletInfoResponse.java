package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class OutletInfoResponse implements Serializable {
	private static final long serialVersionUID = -299893717495446865L;
	private String outletCode;
	private String outletName;
	private String contactPhone;
	private String contactPerson;
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}
	public String getOutletName() {
		return outletName;
	}
	public void setOutletName(String outletName) {
		this.outletName = outletName;
	}
	public String getContactPhone() {
		return contactPhone;
	}
	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}
	public String getContactPerson() {
		return contactPerson;
	}
	public void setContactPerson(String contactPerson) {
		this.contactPerson = contactPerson;
	}

}
