package cls.pilottery.web.checkTickets.form;

import java.io.Serializable;

import cls.pilottery.common.model.BaseEntity;

public class CheckInquiryForm extends BaseEntity implements Serializable {

	public CheckInquiryForm() {

	}

	private static final long serialVersionUID = 1L;

	private String paidDate;

	private String orgCode;


	
	public String getPaidDate() {
	
		return paidDate;
	}

	
	public void setPaidDate(String paidDate) {
	
		this.paidDate = paidDate;
	}

	public String getOrgCode() {

		return orgCode;
	}

	public void setOrgCode(String orgCode) {

		this.orgCode = orgCode;
	}
}
