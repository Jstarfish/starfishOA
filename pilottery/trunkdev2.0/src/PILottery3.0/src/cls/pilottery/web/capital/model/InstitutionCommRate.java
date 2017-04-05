package cls.pilottery.web.capital.model;

import java.io.Serializable;

public class InstitutionCommRate implements Serializable {

	/**
	 * 组织机构方案佣金实体类
	 */
	private static final long serialVersionUID = -6424725125732786486L;

	private String orgCode;

	private String planCode;

	private Long saleComm;

	private Long payComm;

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public String getPlanCode() {
		return planCode;
	}

	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}

	public Long getSaleComm() {
		return saleComm;
	}

	public void setSaleComm(Long saleComm) {
		this.saleComm = saleComm;
	}

	public Long getPayComm() {
		return payComm;
	}

	public void setPayComm(Long payComm) {
		this.payComm = payComm;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
