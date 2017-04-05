package cls.pilottery.web.outlet.model;

import java.util.Date;

public class SaleAgencyReceiptVo {
private String  arNo;//编号
private String agencyName;//销售站名称
private String  arAgency;//站点编号
private Long      tickets;//张数
private Long      amount;//退货金额
private Date     arDate;//退货时间
public String getArNo() {
	return arNo;
}
public void setArNo(String arNo) {
	this.arNo = arNo;
}
public String getAgencyName() {
	return agencyName;
}
public void setAgencyName(String agencyName) {
	this.agencyName = agencyName;
}
public String getArAgency() {
	return arAgency;
}
public void setArAgency(String arAgency) {
	this.arAgency = arAgency;
}
public Long getTickets() {
	return tickets;
}
public void setTickets(Long tickets) {
	this.tickets = tickets;
}
public Long getAmount() {
	return amount;
}
public void setAmount(Long amount) {
	this.amount = amount;
}
public Date getArDate() {
	return arDate;
}
public void setArDate(Date arDate) {
	this.arDate = arDate;
}

}
