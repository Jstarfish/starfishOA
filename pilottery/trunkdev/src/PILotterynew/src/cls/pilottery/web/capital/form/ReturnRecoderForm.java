package cls.pilottery.web.capital.form;

import cls.pilottery.common.model.BaseEntity;

public class ReturnRecoderForm extends BaseEntity {
	private static final long serialVersionUID = 1456612954873884985L;

	private String returnNo; // 还货id

	private Long receiveManager; // 仓库管理员

	private Long marketAdmin; // 市场管理员

	private String applyDate; // 收票日期 还货日期

	private Long applyTickets; // 实际退货票数

	private Long amount; // 实际退货金额

	private String realName;

	private Long id; // 用户id

	private Integer status;
	
	private String adminOrg;  //所属部门ADMIN_ORG

	
	public String getAdminOrg() {
		return adminOrg;
	}

	public void setAdminOrg(String adminOrg) {
		this.adminOrg = adminOrg;
	}

	public Long getAmount() {
		return amount;
	}

	public String getApplyDate() {
		return applyDate;
	}

	public void setApplyDate(String applyDate) {
		this.applyDate = applyDate;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Long getApplyTickets() {
		return applyTickets;
	}

	public Long getId() {
		return id;
	}

	public Long getMarketAdmin() {
		return marketAdmin;
	}

	public String getRealName() {
		return realName;
	}

	public Long getReceiveManager() {
		return receiveManager;
	}

	public String getReturnNo() {
		return returnNo;
	}

	public Integer getStatus() {
		return status;
	}

	public void setAmount(Long amount) {
		this.amount = amount;
	}

	public void setApplyTickets(Long applyTickets) {
		this.applyTickets = applyTickets;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setMarketAdmin(Long marketAdmin) {
		this.marketAdmin = marketAdmin;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

	public void setReceiveManager(Long receiveManager) {
		this.receiveManager = receiveManager;
	}

	public void setReturnNo(String returnNo) {
		this.returnNo = returnNo;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

}
