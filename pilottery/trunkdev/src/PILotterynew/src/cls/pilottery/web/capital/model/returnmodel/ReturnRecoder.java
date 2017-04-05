package cls.pilottery.web.capital.model.returnmodel;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;

public class ReturnRecoder extends BaseEntity {

	/**
	 * 还货实体类 SALE_RETURN_RECODER
	 */
	private static final long serialVersionUID = 1456612954873884985L;

	private String returnNo; // 还货id

	private Long receiveManager; // 仓库管理员

	private Long marketAdmin; // 市场管理员

	private Date applyDate; // 收票日期 还货日期

	private Long applyTickets; // 实际退货票数

	private Long amount; // 实际退货金额

	private String realName;

	private Long id; // 用户id

	private Integer status;

	private Integer isDirectAudited; // 是否直接审批通过

	private Integer financeAdmin; // 审批人 FINANCE_ADMIN\

	private Integer approveStatus; // 审批状态 1 成功 2 失败
	
	private Date approveDate; //审批日期
	
	private String adminOrg;
	

	public String getAdminOrg() {
		return adminOrg;
	}

	public void setAdminOrg(String adminOrg) {
		this.adminOrg = adminOrg;
	}

	public Date getApproveDate() {
		return approveDate;
	}

	public void setApproveDate(Date approveDate) {
		this.approveDate = approveDate;
	}

	public Integer getApproveStatus() {
		return approveStatus;
	}

	public void setApproveStatus(Integer approveStatus) {
		this.approveStatus = approveStatus;
	}

	public Integer getFinanceAdmin() {
		return financeAdmin;
	}

	public void setFinanceAdmin(Integer financeAdmin) {
		this.financeAdmin = financeAdmin;
	}

	public Integer getIsDirectAudited() {
		return isDirectAudited;
	}

	public void setIsDirectAudited(Integer isDirectAudited) {
		this.isDirectAudited = isDirectAudited;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Long getAmount() {
		return amount;
	}

	public Date getApplyDate() {
		return applyDate;
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

	public void setApplyDate(Date applyDate) {
		this.applyDate = applyDate;
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
