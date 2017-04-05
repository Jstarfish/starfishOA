package cls.pilottery.oms.common.msg;

import java.io.Serializable;
import java.util.Date;

public class RefundRes4005Result implements Serializable {
	private static final long serialVersionUID = 8829885366596130571L;
	private String rspfn_ticket;// char[25] 彩票TSN
	private String reqfn_ticket;// char[25] 销售请求流水号
	private long unique_tsn;
	private String rspfn_ticket_cancel;// char[25] 退票响应交易流水号
	private String reqfn_ticket_cancel;// 退票请求交易流水号
	private long unique_tsn_cancel;
	private String areaCode_cancel;
	private int gameCode;// uint8 游戏编码
	private long startIssueNumber;// uint64 销售期号
	private long saleTime;// uint32 销售时间
	private String saleAgencyCode;
	private long cancelAmount;// money_t(int64) 取消金额
	private long transTimeStamp;// uint32 交易时间
	private long commissionCommision;
	
    private Date saleDate;
	private Date transDateStamp;
	public String getRspfn_ticket() {
		return rspfn_ticket;
	}
	public void setRspfn_ticket(String rspfnTicket) {
		rspfn_ticket = rspfnTicket;
	}
	public String getReqfn_ticket() {
		return reqfn_ticket;
	}
	public void setReqfn_ticket(String reqfnTicket) {
		reqfn_ticket = reqfnTicket;
	}
	public long getUnique_tsn() {
		return unique_tsn;
	}
	public void setUnique_tsn(long uniqueTsn) {
		unique_tsn = uniqueTsn;
	}
	public String getRspfn_ticket_cancel() {
		return rspfn_ticket_cancel;
	}
	public void setRspfn_ticket_cancel(String rspfnTicketCancel) {
		rspfn_ticket_cancel = rspfnTicketCancel;
	}
	public String getReqfn_ticket_cancel() {
		return reqfn_ticket_cancel;
	}
	public void setReqfn_ticket_cancel(String reqfnTicketCancel) {
		reqfn_ticket_cancel = reqfnTicketCancel;
	}
	public long getUnique_tsn_cancel() {
		return unique_tsn_cancel;
	}
	public void setUnique_tsn_cancel(long uniqueTsnCancel) {
		unique_tsn_cancel = uniqueTsnCancel;
	}
	public String getAreaCode_cancel() {
		return areaCode_cancel;
	}
	public void setAreaCode_cancel(String areaCodeCancel) {
		areaCode_cancel = areaCodeCancel;
	}
	public int getGameCode() {
		return gameCode;
	}
	public void setGameCode(int gameCode) {
		this.gameCode = gameCode;
	}
	public long getStartIssueNumber() {
		return startIssueNumber;
	}
	public void setStartIssueNumber(long startIssueNumber) {
		this.startIssueNumber = startIssueNumber;
	}
	public long getSaleTime() {
		return saleTime;
	}
	public void setSaleTime(long saleTime) {
		this.saleTime = saleTime;
	}
	public String getSaleAgencyCode() {
		return saleAgencyCode;
	}
	public void setSaleAgencyCode(String saleAgencyCode) {
		this.saleAgencyCode = saleAgencyCode;
	}
	public long getCancelAmount() {
		return cancelAmount;
	}
	public void setCancelAmount(long cancelAmount) {
		this.cancelAmount = cancelAmount;
	}
	public long getTransTimeStamp() {
		return transTimeStamp;
	}
	public void setTransTimeStamp(long transTimeStamp) {
		this.transTimeStamp = transTimeStamp;
	}
	public long getCommissionCommision() {
		return commissionCommision;
	}
	public void setCommissionCommision(long commissionCommision) {
		this.commissionCommision = commissionCommision;
	}
	public Date getSaleDate() {
		return saleDate;
	}
	public void setSaleDate(Date saleDate) {
		this.saleDate = saleDate;
	}
	public Date getTransDateStamp() {
		return transDateStamp;
	}
	public void setTransDateStamp(Date transDateStamp) {
		this.transDateStamp = transDateStamp;
	}
	@Override
	public String toString() {
		return "Refund4005Result [areaCode_cancel=" + areaCode_cancel + ", cancelAmount=" + cancelAmount + ", commissionCommision=" + commissionCommision + ", gameCode=" + gameCode + ", reqfn_ticket=" + reqfn_ticket + ", reqfn_ticket_cancel=" + reqfn_ticket_cancel + ", rspfn_ticket="
				+ rspfn_ticket + ", rspfn_ticket_cancel=" + rspfn_ticket_cancel + ", saleAgencyCode=" + saleAgencyCode + ", saleDate=" + saleDate + ", saleTime=" + saleTime + ", startIssueNumber=" + startIssueNumber + ", transDateStamp=" + transDateStamp + ", transTimeStamp=" + transTimeStamp
				+ ", unique_tsn=" + unique_tsn + ", unique_tsn_cancel=" + unique_tsn_cancel + "]";
	}

}
