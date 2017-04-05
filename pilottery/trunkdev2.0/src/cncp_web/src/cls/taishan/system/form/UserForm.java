package cls.taishan.system.form;

import cls.taishan.common.entity.BaseForm;

/**
 * 用户信息Form类
 */
public class UserForm extends BaseForm {
	private static final long serialVersionUID = 3575568940677627795L;
	private Long userId;
	private String loginId;
	private Integer status;
	private String orgCode;
	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public String getOrgCode() {
		return orgCode;
	}
	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}
	public Long getUserId() {
		return userId;
	}
	public void setUserId(Long userId) {
		this.userId = userId;
	}
}
