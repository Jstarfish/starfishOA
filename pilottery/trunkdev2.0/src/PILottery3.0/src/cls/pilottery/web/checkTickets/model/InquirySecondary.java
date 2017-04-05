package cls.pilottery.web.checkTickets.model;

import java.io.Serializable;
import java.util.Date;

public class InquirySecondary implements Serializable {

	private static final long serialVersionUID = 1L;

	private String payFlow;// 旧票兑奖序号

	private String oldSeq;// 旧票明细序号

	private String planCode;// 方案编码

	private String ticketsNo;// 票号

	private int scanTicket;// 扫描数量

	private int winNum;// 中奖数量

	private long wimAmount;// 中奖金额

	private int isNew;// 是否为新票

	private Date paidTime;// 兑奖时间

	private int paid_admin;// 兑奖人

	private String paid_org;// 兑奖机构

	private int paidStatus;// 兑奖状态

	private String paidStatusEn;// 兑奖状态表示

	public String getPaidStatusEn() {

		return paidStatusEn;
	}

	public void setPaidStatusEn(String paidStatusEn) {

		this.paidStatusEn = paidStatusEn;
	}

	public InquirySecondary() {

	}

	public int getIsNew() {

		return isNew;
	}

	public String getOldSeq() {

		return oldSeq;
	}

	public int getPaid_admin() {

		return paid_admin;
	}

	public String getPaid_org() {

		return paid_org;
	}

	public int getPaidStatus() {

		return paidStatus;
	}

	public Date getPaidTime() {

		return paidTime;
	}

	public String getPayFlow() {

		return payFlow;
	}

	public String getPlanCode() {

		return planCode;
	}

	public int getScanTicket() {

		return scanTicket;
	}

	public String getTicketsNo() {

		return ticketsNo;
	}

	public long getWimAmount() {

		return wimAmount;
	}

	public int getWinNum() {

		return winNum;
	}

	public void setIsNew(int isNew) {

		this.isNew = isNew;
	}

	public void setOldSeq(String oldSeq) {

		this.oldSeq = oldSeq;
	}

	public void setPaid_admin(int paid_admin) {

		this.paid_admin = paid_admin;
	}

	public void setPaid_org(String paid_org) {

		this.paid_org = paid_org;
	}

	public void setPaidStatus(int paidStatus) {

		this.paidStatus = paidStatus;
	}

	public void setPaidTime(Date paidTime) {

		this.paidTime = paidTime;
	}

	public void setPayFlow(String payFlow) {

		this.payFlow = payFlow;
	}

	public void setPlanCode(String planCode) {

		this.planCode = planCode;
	}

	public void setScanTicket(int scanTicket) {

		this.scanTicket = scanTicket;
	}

	public void setTicketsNo(String ticketsNo) {

		this.ticketsNo = ticketsNo;
	}

	public void setWimAmount(long wimAmount) {

		this.wimAmount = wimAmount;
	}

	public void setWinNum(int winNum) {

		this.winNum = winNum;
	}

	@Override
	public String toString() {

		return "InquirySecondary [payFlow=" + payFlow + ", oldSeq=" + oldSeq + ", planCode=" + planCode
				+ ", ticketsNo=" + ticketsNo + ", scanTicket=" + scanTicket + ", winNum=" + winNum + ", wimAmount="
				+ wimAmount + ", isNew=" + isNew + ", paidTime=" + paidTime + ", paid_admin=" + paid_admin
				+ ", paid_org=" + paid_org + ", paidStatus=" + paidStatus + "]";
	}
}
