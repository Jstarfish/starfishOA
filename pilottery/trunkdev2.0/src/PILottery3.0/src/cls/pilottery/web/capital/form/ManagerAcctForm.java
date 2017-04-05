package cls.pilottery.web.capital.form;

import cls.pilottery.common.model.BaseEntity;

public class ManagerAcctForm extends BaseEntity {
	private static final long serialVersionUID = -677951887117710367L;

	/**
	 * 市场管理员Form
	 */

	private Long marketAdmin; // 市场管理员编号

	private String realName;

	private Long creditLimit; // 信用额度

	private String transPass; // 交易密码

	private String adminOrg; // 所属部门 ADMIN_ORG
	private int currentUserId;
	private String cuserOrg;

	public String getAdminOrg() {
		return adminOrg;
	}

	public void setAdminOrg(String adminOrg) {
		this.adminOrg = adminOrg;
	}

	public Long getMarketAdmin() {
		return marketAdmin;
	}

	public void setMarketAdmin(Long marketAdmin) {
		this.marketAdmin = marketAdmin;
	}

	public String getRealName() {
		return realName;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

	public Long getCreditLimit() {
		return creditLimit;
	}

	public void setCreditLimit(Long creditLimit) {
		this.creditLimit = creditLimit;
	}

	public String getTransPass() {
		return transPass;
	}

	public void setTransPass(String transPass) {
		this.transPass = transPass;
	}

	public int getCurrentUserId() {
		return currentUserId;
	}

	public void setCurrentUserId(int currentUserId) {
		this.currentUserId = currentUserId;
	}

	public String getCuserOrg() {
		return cuserOrg;
	}

	public void setCuserOrg(String cuserOrg) {
		this.cuserOrg = cuserOrg;
	}

}
