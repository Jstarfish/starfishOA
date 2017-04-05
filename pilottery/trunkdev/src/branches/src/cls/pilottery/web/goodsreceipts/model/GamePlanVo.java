package cls.pilottery.web.goodsreceipts.model;

import java.io.Serializable;

public class GamePlanVo implements Serializable {
  
	    /**
	    * @Fields serialVersionUID : TODO(用一句话描述这个变量表示什么)
	    */
	    
  private static final long serialVersionUID = -6452874161927224379L;
  private String planCode;
  private String planName;
  private Long   amount;
  private String batchNo;
  private Long ticketsEveryGroup;
public String getPlanCode() {
	return planCode;
}
public void setPlanCode(String planCode) {
	this.planCode = planCode;
}
public String getPlanName() {
	return planName;
}
public void setPlanName(String planName) {
	this.planName = planName;
}
public Long getAmount() {
	return amount;
}
public void setAmount(Long amount) {
	this.amount = amount;
}
public String getBatchNo() {
	return batchNo;
}
public void setBatchNo(String batchNo) {
	this.batchNo = batchNo;
}
public Long getTicketsEveryGroup() {
	return ticketsEveryGroup;
}
public void setTicketsEveryGroup(Long ticketsEveryGroup) {
	this.ticketsEveryGroup = ticketsEveryGroup;
}
  
}
