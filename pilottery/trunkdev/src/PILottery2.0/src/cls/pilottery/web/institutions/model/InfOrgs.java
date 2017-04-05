package cls.pilottery.web.institutions.model;

import java.io.Serializable;

/**
 * 
 * @ClassName: InfOrgs
 * @Description: 部门
 * @author dell
 * @date 2015年9月8日
 * 
 */
public class InfOrgs implements Serializable {

	/**
	 * @Fields serialVersionUID : TODO(用一句话描述这个变量表示什么)
	 */

	private static final long serialVersionUID = 1L;
	private String orgCode;// 部门编码（00代表总公司，01代表分公司） ORG_CODE
	private String orgName;// 部门名称 ORG_NAME
	private int orgType;// 部门类别1-公司,2-代理 ORG_TYPE
	private String superOrg;// 所属上级 SUPER_ORG
	private String phone;// 部门联系电话 PHONE
	private String directorAdmin;// 负责人 DIRECTOR_ADMIN
	private Long persons;// 部门人数 PERSONS
	private String address;// 地址 ADDRESS
	private Integer orgStatus;// 部门状态
	private String areaCode;//

	// 调用sp返回的错误参数
	private Integer c_errcode;
	private String c_errmsg;
	private String oldorgCode;// 机构原编码
	private String superOrgName;// 上级部门

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

	public int getOrgType() {
		return orgType;
	}

	public void setOrgType(int orgType) {
		this.orgType = orgType;
	}

	public String getSuperOrg() {
		return superOrg;
	}

	public void setSuperOrg(String superOrg) {
		this.superOrg = superOrg;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getDirectorAdmin() {
		return directorAdmin;
	}

	public void setDirectorAdmin(String directorAdmin) {
		this.directorAdmin = directorAdmin;
	}

	public Long getPersons() {
		return persons;
	}

	public void setPersons(Long persons) {
		this.persons = persons;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public Integer getOrgStatus() {
		return orgStatus;
	}

	public void setOrgStatus(Integer orgStatus) {
		this.orgStatus = orgStatus;
	}

	public String getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}

	public Integer getC_errcode() {
		return c_errcode;
	}

	public void setC_errcode(Integer c_errcode) {
		this.c_errcode = c_errcode;
	}

	public String getC_errmsg() {
		return c_errmsg;
	}

	public void setC_errmsg(String c_errmsg) {
		this.c_errmsg = c_errmsg;
	}

	public String getOldorgCode() {
		return oldorgCode;
	}

	public void setOldorgCode(String oldorgCode) {
		this.oldorgCode = oldorgCode;
	}

	public String getSuperOrgName() {
		return superOrgName;
	}

	public void setSuperOrgName(String superOrgName) {
		this.superOrgName = superOrgName;
	}

}
