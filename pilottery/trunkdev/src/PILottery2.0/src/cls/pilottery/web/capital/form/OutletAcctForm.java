package cls.pilottery.web.capital.form;

import cls.pilottery.common.model.BaseEntity;

public class OutletAcctForm extends BaseEntity {
	private static final long serialVersionUID = -3694212972153953821L;

	private String agencyCode; // 站点编号

	private String accName; // 站点名称

	private Long creditLimit; // 信用额度
	
	private String orgCode;   //所属部门编码

	private String agencyName;
	

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public String getAgencyName() {
		return agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public String getAgencyCode() {
		return agencyCode;
	}

	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}

	public String getAccName() {
		return accName;
	}

	public void setAccName(String accName) {
		this.accName = accName;
	}

	public Long getCreditLimit() {
		return creditLimit;
	}

	public void setCreditLimit(Long creditLimit) {
		this.creditLimit = creditLimit;
	}

}
