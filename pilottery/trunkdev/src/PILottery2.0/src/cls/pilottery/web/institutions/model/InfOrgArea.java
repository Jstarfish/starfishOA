package cls.pilottery.web.institutions.model;

import java.io.Serializable;

/**
 * 
    * @ClassName: InfOrgArea
    * @Description: 组织机构管辖区域
    * @author dell
    * @date 2015年9月10日
    *
 */
public class InfOrgArea implements Serializable{
	
	    /**
	    * @Fields serialVersionUID : TODO(用一句话描述这个变量表示什么)
	    */
	    
	private static final long serialVersionUID = 1L;
	private String orgCode;//部门编码（00代表总公司，01代表分公司）	ORG_CODE
	private String  areaCode;//区域编码
	private String areaName; // 区域名称
	public String getOrgCode() {
		return orgCode;
	}
	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}
	public String getAreaCode() {
		return areaCode;
	}
	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}
	public String getAreaName() {
		return areaName;
	}
	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}
	
}
