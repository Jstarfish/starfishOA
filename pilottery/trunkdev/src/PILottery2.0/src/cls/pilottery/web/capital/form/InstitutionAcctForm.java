package cls.pilottery.web.capital.form;

import cls.pilottery.common.model.BaseEntity;

/*
 * ACC_ORG_ACCOUNT
 */
public class InstitutionAcctForm extends BaseEntity {
	private static final long serialVersionUID = -8283741863507936127L;

	private String orgCode; // 代理商编号

	private String orgName; // 代理商名称 will modify

	private Long creditLimit; // 信用额度

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public Long getCreditLimit() {
		return creditLimit;
	}

	public void setCreditLimit(Long creditLimit) {
		this.creditLimit = creditLimit;
	}

}
