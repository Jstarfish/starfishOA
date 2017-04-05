package cls.pilottery.web.inventory.model;

import java.util.Date;

public class MMCheckVO implements java.io.Serializable{
	private static final long serialVersionUID = -8088538515944113577L;
	private String cpNo;
	private int managerId;
	private String managerName;
	private int result;
	private int inventoryTickets;
	private int checkTickets;
	private int diffTickets;
	private Date cpDate;
	private String orgCode;
	private String orgName;
	public String getCpNo() {
		return cpNo;
	}
	public void setCpNo(String cpNo) {
		this.cpNo = cpNo;
	}
	public int getManagerId() {
		return managerId;
	}
	public void setManagerId(int managerId) {
		this.managerId = managerId;
	}
	public String getManagerName() {
		return managerName;
	}
	public void setManagerName(String managerName) {
		this.managerName = managerName;
	}
	public int getResult() {
		return result;
	}
	public void setResult(int result) {
		this.result = result;
	}
	public int getInventoryTickets() {
		return inventoryTickets;
	}
	public void setInventoryTickets(int inventoryTickets) {
		this.inventoryTickets = inventoryTickets;
	}
	public int getCheckTickets() {
		return checkTickets;
	}
	public void setCheckTickets(int checkTickets) {
		this.checkTickets = checkTickets;
	}
	public int getDiffTickets() {
		return diffTickets;
	}
	public void setDiffTickets(int diffTickets) {
		this.diffTickets = diffTickets;
	}
	public Date getCpDate() {
		return cpDate;
	}
	public void setCpDate(Date cpDate) {
		this.cpDate = cpDate;
	}
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
}
