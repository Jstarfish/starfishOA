package cls.pilottery.web.report.model;

import java.io.Serializable;

public class HQItemIssueReportVo implements Serializable {

	private static final long serialVersionUID = -8414115628760312379L;
	private String issueCode;
	private String operatorName;
	private String issueDate;
	private String sendWhName;
	private String receiveOrgName;
	private String itemName;
	private Integer quantity;

	public String getIssueCode() {
		return issueCode;
	}
	public void setIssueCode(String issueCode) {
		this.issueCode = issueCode == null ? null : issueCode.trim();
	}
	
	public String getOperatorName() {
		return operatorName;
	}
	public void setOperatorName(String operatorName) {
		this.operatorName = operatorName == null ? null : operatorName.trim();
	}
	
	public String getIssueDate() {
		return issueDate;
	}
	public void setIssueDate(String issueDate) {
		this.issueDate = issueDate == null ? null : issueDate.trim();
	}
	
	public String getSendWhName() {
		return sendWhName;
	}
	public void setSendWhName(String sendWhName) {
		this.sendWhName = sendWhName == null ? null : sendWhName.trim();
	}
	
	public String getReceiveOrgName() {
		return receiveOrgName;
	}
	public void setReceiveOrgName(String receiveOrgName) {
		this.receiveOrgName = receiveOrgName == null ? null : receiveOrgName.trim();
	}
	
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName == null ? null : itemName.trim();
	}
	
	public Integer getQuantity() {
		return quantity;
	}
	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}
}
