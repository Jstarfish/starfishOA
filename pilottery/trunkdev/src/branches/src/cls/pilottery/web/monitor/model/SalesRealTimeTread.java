package cls.pilottery.web.monitor.model;

import java.io.Serializable;

/**
 * 销量按时间段监控 实体类
 */
public class SalesRealTimeTread implements Serializable {

	private static final long serialVersionUID = -252011031408714074L;
	public String calcDate; // 统计日期
	public String calcTime; // 统计时间
	public String planCode;
	public String planName;
	public String orgCode;
	public Long saleAmount;
	public Long cancelAmount; // 兑奖金额
	public Long payAmount; // 退票金额

	public String getPlanName() {
		return planName;
	}

	public void setPlanName(String planName) {
		this.planName = planName;
	}

	public String getCalcDate() {
		return calcDate;
	}

	public void setCalcDate(String calcDate) {
		this.calcDate = calcDate;
	}

	public String getCalcTime() {
		return calcTime;
	}

	public void setCalcTime(String calcTime) {
		this.calcTime = calcTime;
	}

	public String getPlanCode() {
		return planCode;
	}

	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public Long getSaleAmount() {
		return saleAmount;
	}

	public void setSaleAmount(Long saleAmount) {
		this.saleAmount = saleAmount;
	}

	public Long getCancelAmount() {
		return cancelAmount;
	}

	public void setCancelAmount(Long cancelAmount) {
		this.cancelAmount = cancelAmount;
	}

	public Long getPayAmount() {
		return payAmount;
	}

	public void setPayAmount(Long payAmount) {
		this.payAmount = payAmount;
	}

}
