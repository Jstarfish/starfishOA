package cls.pilottery.web.outlet.model;

import java.io.Serializable;
/**
 * 部门类
 * @describe 用于部门下拉列表
 *
 */
public class Orgs implements Serializable{
	private static final long serialVersionUID = 1L;

	private String orgCode;// 部门编码（00代表总公司，01代表分公司） ORG_CODE

	private String orgName;// 部门名称 ORG_NAME

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

	public Orgs() {
	}

	@Override
	public String toString() {
		return "Orgs [orgCode=" + orgCode + ", orgName=" + orgName + "]";
	}
}
