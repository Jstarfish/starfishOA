package cls.pilottery.web.marketManager.entity;

import java.util.Date;
import java.util.List;

import cls.pilottery.common.EnumConfigEN;

public class ReturnDeliveryOrder implements java.io.Serializable {
	private static final long serialVersionUID = -5915026367069357863L;

	private String returnNo;

	private int marketManagerAdmin;

	private Date applyDate;

	private int applyTickets;

	private Long applyAmount;

	private int financeAdmin;

	private Date approveDate;

	private String approveRemark;

	private int actTickets;

	private Long actAmount;

	private int status;

	private int isDirectAudited;

	private long directAmount;

	private String receiveOrg;

	private String receiveWh;

	private int receiveManager;

	private Date receiveDate;

	private String marketAdminName;
	private String warehouseManager;
	private String financeAdminName;
	private String statusValue;
	
	List<ReturnDeliveryDetail> rdDetail ;

	public String getMarketAdminName() {
		return marketAdminName;
	}

	public void setMarketAdminName(String marketAdminName) {
		this.marketAdminName = marketAdminName;
	}

	public String getWarehouseManager() {
		return warehouseManager;
	}

	public void setWarehouseManager(String warehouseManager) {
		this.warehouseManager = warehouseManager;
	}

	public String getFinanceAdminName() {
		return financeAdminName;
	}

	public void setFinanceAdminName(String financeAdminName) {
		this.financeAdminName = financeAdminName;
	}

	public String getReturnNo() {
		return returnNo;
	}

	public int getMarketManagerAdmin() {
		return marketManagerAdmin;
	}

	public void setMarketManagerAdmin(int marketManagerAdmin) {
		this.marketManagerAdmin = marketManagerAdmin;
	}

	public Date getApplyDate() {
		return applyDate;
	}

	public void setApplyDate(Date applyDate) {
		this.applyDate = applyDate;
	}

	public int getApplyTickets() {
		return applyTickets;
	}

	public void setApplyTickets(int applyTickets) {
		this.applyTickets = applyTickets;
	}

	public Long getApplyAmount() {
		return applyAmount;
	}

	public void setApplyAmount(Long applyAmount) {
		this.applyAmount = applyAmount;
	}

	public int getFinanceAdmin() {
		return financeAdmin;
	}

	public void setFinanceAdmin(int financeAdmin) {
		this.financeAdmin = financeAdmin;
	}

	public Date getApproveDate() {
		return approveDate;
	}

	public void setApproveDate(Date approveDate) {
		this.approveDate = approveDate;
	}

	public String getApproveRemark() {
		return approveRemark;
	}

	public void setApproveRemark(String approveRemark) {
		this.approveRemark = approveRemark;
	}

	public int getActTickets() {
		return actTickets;
	}

	public void setActTickets(int actTickets) {
		this.actTickets = actTickets;
	}

	public Long getActAmount() {
		return actAmount;
	}

	public void setActAmount(Long actAmount) {
		this.actAmount = actAmount;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
		this.statusValue=EnumConfigEN.returnDeliveryStatus.get(status);
	}

	public int getIsDirectAudited() {
		return isDirectAudited;
	}

	public void setIsDirectAudited(int isDirectAudited) {
		this.isDirectAudited = isDirectAudited;
	}

	public long getDirectAmount() {
		return directAmount;
	}

	public void setDirectAmount(long directAmount) {
		this.directAmount = directAmount;
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

	public void setReturnNo(String returnNo) {
		this.returnNo = returnNo;
	}

	public List<ReturnDeliveryDetail> getRdDetail() {
		return rdDetail;
	}

	public void setRdDetail(List<ReturnDeliveryDetail> rdDetail) {
		this.rdDetail = rdDetail;
	}

	public String getStatusValue() {
		return statusValue;
	}

	public void setStatusValue(String statusValue) {
		this.statusValue = statusValue;
	}
}