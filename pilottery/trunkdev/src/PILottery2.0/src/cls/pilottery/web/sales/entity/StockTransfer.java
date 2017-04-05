package cls.pilottery.web.sales.entity;

import java.util.Date;
import java.util.List;

import cls.pilottery.common.EnumConfigEN;

public class StockTransfer implements java.io.Serializable {
	private static final long serialVersionUID = 4499295426092521446L;
	private String stbNo;
	private int applyAdmin;
	private Date applyDate;
	private int approveAdmin;
	private Date approveDate;
	private String receiveOrg;
	private String receiveWh;
	private int receiveManager;
	private Date receiveDate;
	private int status;
	private String statusValue;
	private Long tickets;
	private Long amount;
	private Long actTickets;
	private Long actAmount;
	private int isMatch;
	private String applyName;
	private String approveName;
	private String sendOrg;
	private String sendWh;
	private int sendManager;
	private Date sendDate;
	private String sendOrgName;
	private String receiveOrgName;
	private String sendManagerName;
	private String receiveManagerName;
	private String remark;
	private List<StockTransferDetail> transferDetail;

	public String getStbNo() {
		return stbNo;
	}

	public void setStbNo(String stbNo) {
		this.stbNo = stbNo;
	}

	public int getApplyAdmin() {
		return applyAdmin;
	}

	public void setApplyAdmin(int applyAdmin) {
		this.applyAdmin = applyAdmin;
	}

	public Date getApplyDate() {
		return applyDate;
	}

	public void setApplyDate(Date applyDate) {
		this.applyDate = applyDate;
	}

	public int getApproveAdmin() {
		return approveAdmin;
	}

	public void setApproveAdmin(int approveAdmin) {
		this.approveAdmin = approveAdmin;
	}

	public Date getApproveDate() {
		return approveDate;
	}

	public void setApproveDate(Date approveDate) {
		this.approveDate = approveDate;
	}

	public String getReceiveOrg() {
		return receiveOrg;
	}

	public void setReceiveOrg(String receiveOrg) {
		this.receiveOrg = receiveOrg;
	}

	public String getReceiveWh() {
		return receiveWh;
	}

	public void setReceiveWh(String receiveWh) {
		this.receiveWh = receiveWh;
	}

	public int getReceiveManager() {
		return receiveManager;
	}

	public void setReceiveManager(int receiveManager) {
		this.receiveManager = receiveManager;
	}

	public Date getReceiveDate() {
		return receiveDate;
	}

	public void setReceiveDate(Date receiveDate) {
		this.receiveDate = receiveDate;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
		this.statusValue = EnumConfigEN.stockTransferStatus.get(status);
	}

	public Long getAmount() {
		return amount;
	}

	public void setAmount(Long amount) {
		this.amount = amount;
	}

	public Long getTickets() {
		return tickets;
	}

	public void setTickets(Long tickets) {
		this.tickets = tickets;
	}

	public Long getActTickets() {
		return actTickets;
	}

	public void setActTickets(Long actTickets) {
		this.actTickets = actTickets;
	}

	public Long getActAmount() {
		return actAmount;
	}

	public void setActAmount(Long actAmount) {
		this.actAmount = actAmount;
	}

	public int getIsMatch() {
		return isMatch;
	}

	public void setIsMatch(int isMatch) {
		this.isMatch = isMatch;
	}

	public String getApplyName() {
		return applyName;
	}

	public void setApplyName(String applyName) {
		this.applyName = applyName;
	}

	public String getApproveName() {
		return approveName;
	}

	public void setApproveName(String approveName) {
		this.approveName = approveName;
	}

	public List<StockTransferDetail> getTransferDetail() {
		return transferDetail;
	}

	public void setTransferDetail(List<StockTransferDetail> transferDetail) {
		this.transferDetail = transferDetail;
	}

	public String getStatusValue() {
		return statusValue;
	}

	public void setStatusValue(String statusValue) {
		this.statusValue = statusValue;
	}

	public String getSendOrg() {
		return sendOrg;
	}

	public void setSendOrg(String sendOrg) {
		this.sendOrg = sendOrg;
	}

	public String getSendWh() {
		return sendWh;
	}

	public void setSendWh(String sendWh) {
		this.sendWh = sendWh;
	}

	public int getSendManager() {
		return sendManager;
	}

	public void setSendManager(int sendManager) {
		this.sendManager = sendManager;
	}

	public Date getSendDate() {
		return sendDate;
	}

	public void setSendDate(Date sendDate) {
		this.sendDate = sendDate;
	}

	public String getSendOrgName() {
		return sendOrgName;
	}

	public void setSendOrgName(String sendOrgName) {
		this.sendOrgName = sendOrgName;
	}

	public String getReceiveOrgName() {
		return receiveOrgName;
	}

	public void setReceiveOrgName(String receiveOrgName) {
		this.receiveOrgName = receiveOrgName;
	}

	public String getSendManagerName() {
		return sendManagerName;
	}

	public void setSendManagerName(String sendManagerName) {
		this.sendManagerName = sendManagerName;
	}

	public String getReceiveManagerName() {
		return receiveManagerName;
	}

	public void setReceiveManagerName(String receiveManagerName) {
		this.receiveManagerName = receiveManagerName;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
}