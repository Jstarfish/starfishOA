package cls.pilottery.web.capital.form;

import cls.pilottery.common.model.BaseEntity;

public class NewRepaymentForm extends BaseEntity {

	private static final long serialVersionUID = 2507516126563645514L;

	private Integer marketManagerCode;
	private Integer operatorCode;
	private Long    repaymentAmount;
	private String remark;
	
	private String  repaymentFlowNumber;
	private Long    balanceBeforeRepayment;
	private Long    balanceAfterRepayment;
	
	public Integer getMarketManagerCode() {
		return marketManagerCode;
	}
	public void setMarketManagerCode(Integer marketManagerCode) {
		this.marketManagerCode = marketManagerCode;
	}
	
	public Integer getOperatorCode() {
		return operatorCode;
	}
	public void setOperatorCode(Integer operatorCode) {
		this.operatorCode = operatorCode;
	}
	
	public Long getRepaymentAmount() {
		return repaymentAmount;
	}
	public void setRepaymentAmount(Long repaymentAmount) {
		this.repaymentAmount = repaymentAmount;
	}
	
	public String getRepaymentFlowNumber() {
		return repaymentFlowNumber;
	}
	public void setRepaymentFlowNumber(String repaymentFlowNumber) {
		this.repaymentFlowNumber = repaymentFlowNumber == null ? null : repaymentFlowNumber.trim();
	}
	
	public Long getBalanceBeforeRepayment() {
		return balanceBeforeRepayment;
	}
	public void setBalanceBeforeRepayment(Long balanceBeforeRepayment) {
		this.balanceBeforeRepayment = balanceBeforeRepayment;
	}
	
	public Long getBalanceAfterRepayment() {
		return balanceAfterRepayment;
	}
	public void setBalanceAfterRepayment(Long balanceAfterRepayment) {
		this.balanceAfterRepayment = balanceAfterRepayment;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
}
