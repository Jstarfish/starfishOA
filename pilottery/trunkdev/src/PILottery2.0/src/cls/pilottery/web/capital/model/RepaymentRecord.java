package cls.pilottery.web.capital.model;

import java.io.Serializable;

public class RepaymentRecord implements Serializable {

	private static final long serialVersionUID = -8354163223111669054L;

	private String   mcrNo;                    //上缴流水码
	private Integer  marketManagerCode;        //市场员编号
	private String   marketManagerName;        //市场员姓名
	private String   repaymentDate;            //还款日期
	private Long     balanceBeforeRepayment;   //还款前账户余额
	private Long     repaymentAmount;          //还款金额
	private Long     balanceAfterRepayment;    //还款后账户余额
	private String remark;
	
	public String getMcrNo() {
		return mcrNo;
	}
	public void setMcrNo(String mcrNo) {
		this.mcrNo = mcrNo == null ? null : mcrNo.trim();
	}
	
	public Integer getMarketManagerCode() {
		return marketManagerCode;
	}
	public void setMarketManagerCode(Integer marketManagerCode) {
		this.marketManagerCode = marketManagerCode;
	}
	
	public String getMarketManagerName() {
		return marketManagerName;
	}
	public void setMarketManagerName(String marketManagerName) {
		this.marketManagerName = marketManagerName == null ? null : marketManagerName.trim();
	}
	
	public String getRepaymentDate() {
		return repaymentDate;
	}
	public void setRepaymentDate(String repaymentDate) {
		this.repaymentDate = repaymentDate == null ? null : repaymentDate.trim();
	}
	
	public Long getBalanceBeforeRepayment() {
		return balanceBeforeRepayment;
	}
	public void setBalanceBeforeRepayment(Long balanceBeforeRepayment) {
		this.balanceBeforeRepayment = balanceBeforeRepayment;
	}
	
	public Long getRepaymentAmount() {
		return repaymentAmount;
	}
	public void setRepaymentAmount(Long repaymentAmount) {
		this.repaymentAmount = repaymentAmount;
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
