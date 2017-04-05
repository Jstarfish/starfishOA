package cls.pilottery.oms.business.model;

import java.util.Date;

public class AgencyRefunVo {
	private String address;
	private String person;
	private Long id;
	private String agencyCode;
	private Date refunddate;
	private String agencyName;
	private Long fundamount;
	private Integer operAdmin;
	private Long credit;

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPerson() {
		return person;
	}

	public void setPerson(String person) {
		this.person = person;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getAgencyCode() {
		return agencyCode;
	}

	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}

	public Date getRefunddate() {
		return refunddate;
	}

	public void setRefunddate(Date refunddate) {
		this.refunddate = refunddate;
	}

	public String getAgencyName() {
		return agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public Long getFundamount() {
		return fundamount;
	}

	public void setFundamount(Long fundamount) {
		this.fundamount = fundamount;
	}

	public Integer getOperAdmin() {
		return operAdmin;
	}

	public void setOperAdmin(Integer operAdmin) {
		this.operAdmin = operAdmin;
	}

	public Long getCredit() {
		return credit;
	}

	public void setCredit(Long credit) {
		this.credit = credit;
	}

}
