package cls.pilottery.web.items.entity;

import java.io.Serializable;

//2.1.10.5
//与数据库表字段一一对应，不在系统中使用
public class ItemIssue implements Serializable {

	private static final long serialVersionUID = -6527171638026054363L;

	private String iiNo;            //出库单编号（II12345678）//II_NO//CHAR(10)//非空
	private Integer operAdmin;      //操作人//OPER_ADMIN//NUMBER(4)//非空
	private String issueDate;       //出库时间//ISSUE_DATE//DATE
	private String receiveOrg;      //收货单位//RECEIVE_ORG//CHAR(2)
	private String sendOrg;         //发货单位//SEND_ORG//CHAR(2)
	private String sendWh;          //发货仓库//SEND_WH//CHAR(4)
	
	public String getIiNo() {
		return iiNo;
	}
	public void setIiNo(String iiNo) {
		this.iiNo = iiNo == null ? null : iiNo.trim();
	}
	
	public Integer getOperAdmin() {
		return operAdmin;
	}
	public void setOperAdmin(Integer operAdmin) {
		this.operAdmin = operAdmin;
	}
	
	public String getIssueDate() {
		return issueDate;
	}
	public void setIssueDate(String issueDate) {
		this.issueDate = issueDate == null ? null : issueDate.trim();
	}
	
	public String getReceiveOrg() {
		return receiveOrg;
	}
	public void setReceiveOrg(String receiveOrg) {
		this.receiveOrg = receiveOrg == null ? null : receiveOrg.trim();
	}
	
	public String getSendOrg() {
		return sendOrg;
	}
	public void setSendOrg(String sendOrg) {
		this.sendOrg = sendOrg == null ? null : sendOrg.trim();
	}
	
	public String getSendWh() {
		return sendWh;
	}
	public void setSendWh(String sendWh) {
		this.sendWh = sendWh == null ? null : sendWh.trim();
	}
}
