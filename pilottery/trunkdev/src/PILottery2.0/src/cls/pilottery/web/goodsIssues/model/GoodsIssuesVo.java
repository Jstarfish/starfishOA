package cls.pilottery.web.goodsIssues.model;

import java.io.Serializable;
import java.util.Date;

public class GoodsIssuesVo implements Serializable{
	 
	    /**
	    * @Fields serialVersionUID : TODO(用一句话描述这个变量表示什么)
	    */
	    
	private static final long serialVersionUID = 5127144622595359004L;
	private String sgiNo;//出库单编号
	 private Date sendDate;//出库时间
	 private String orgName;//出货单位
	 private String sendManger;// 出库人
	 private Long amount;//实现出库总金额
	 private Long tickets;//实际出库的总票数
	 private Integer issueType;//出库类型
	 private Integer status;//出库单状态
	 private Long actAmount;//实际金额
	 private Long actTickets;//实际票数
	 private String remark;
	 private String refNo;
	public Long getActAmount() {
		return actAmount;
	}
	public void setActAmount(Long actAmount) {
		this.actAmount = actAmount;
	}
	public Long getActTickets() {
		return actTickets;
	}
	public void setActTickets(Long actTickets) {
		this.actTickets = actTickets;
	}
	public String getSgiNo() {
		return sgiNo;
	}
	public void setSgiNo(String sgiNo) {
		this.sgiNo = sgiNo;
	}
	public Date getSendDate() {
		return sendDate;
	}
	public void setSendDate(Date sendDate) {
		this.sendDate = sendDate;
	}
	public String getOrgName() {
		return orgName;
	}
	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}
	public String getSendManger() {
		return sendManger;
	}
	public void setSendManger(String sendManger) {
		this.sendManger = sendManger;
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
	public Integer getIssueType() {
		return issueType;
	}
	public void setIssueType(Integer issueType) {
		this.issueType = issueType;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getRefNo() {
		return refNo;
	}
	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}

	 
}
