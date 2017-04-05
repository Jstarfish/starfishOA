package cls.pilottery.web.institutions.form;
/**
 * 
    * @ClassName: InstitutionsForm
    * @Description: 查询form
    * @author dell
    * @date 2015年9月8日
    *
 */
public class InstitutionsForm {
	private String  orgCode;//部门编码
	private String  orgName;//部门名称
	private int  orgType;//部门类型

	private String opertCode;
	//分页参数
	private Integer beginNum;
	private Integer endNum;
	/**
	    * @Title: getOrgCode
	    * @Description: 返回部门编码
	    * @param @return    参数
	    * @return String    返回类型
	    * @throws
	 */
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
	public Integer getBeginNum() {
		return beginNum;
	}
	public void setBeginNum(Integer beginNum) {
		this.beginNum = beginNum;
	}
	public Integer getEndNum() {
		return endNum;
	}
	public void setEndNum(Integer endNum) {
		this.endNum = endNum;
	}
	
	public String getOpertCode() {
		return opertCode;
	}
	public void setOpertCode(String opertCode) {
		this.opertCode = opertCode;
	}

}
