package cls.pilottery.oms.lottery.form;

import java.util.Date;

public class RefundForm {
	private String reqtsn;// char[25] 彩票TSN
	private String reqfnticketcancel;// char[25] 退票请求交易流水号
	private String cancelagencycode;// uint64 退票请求销售站编码
	private String rspfnticketcancel;// char[25] 退票响应交易流水号
	private String tsn;// char[25] 彩票TSN
	private String reqfnticket;// char[25] 销售请求流水号
	private String rescancelagencycode;// uint64 退票请求站点编码
	private int gamecode;// uint8 游戏编码
	private long issuenumber;// uint64 销售期号
	private Date saletime;// uint32 销售时间
	private String saleagencycode;// uint64 售票站点编码
	private long cancelamount;// money_t(int64) 取消金额
	private String canceler;// 取消人
	private String pid;// 主键
	private Date datetime;
	private long cancelcomm;//
	private Long cancelerAdmin;
	private String gameName;
	private String htmltext;
	private long cancelCommision;
	String saleAgencyCodeFormat;
	String cancelAgencyCodeFormat;

	public String getReqtsn() {
		return reqtsn;
	}

	public void setReqtsn(String reqtsn) {
		this.reqtsn = reqtsn;
	}

	public String getReqfnticketcancel() {
		return reqfnticketcancel;
	}

	public void setReqfnticketcancel(String reqfnticketcancel) {
		this.reqfnticketcancel = reqfnticketcancel;
	}

	public String getCancelagencycode() {
		return cancelagencycode;
	}

	public void setCancelagencycode(String cancelagencycode) {
		this.cancelagencycode = cancelagencycode;
	}

	public String getRspfnticketcancel() {
		return rspfnticketcancel;
	}

	public void setRspfnticketcancel(String rspfnticketcancel) {
		this.rspfnticketcancel = rspfnticketcancel;
	}

	public String getTsn() {
		return tsn;
	}

	public void setTsn(String tsn) {
		if (tsn != "" && tsn != null) {
			this.tsn = tsn.substring(0, 24);
		}
	}

	public String getReqfnticket() {
		return reqfnticket;
	}

	public void setReqfnticket(String reqfnticket) {
		if (reqfnticket != "" && reqfnticket != null) {
			this.reqfnticket = reqfnticket.substring(0, 24);
		}
	}

	public String getRescancelagencycode() {
		return rescancelagencycode;
	}

	public void setRescancelagencycode(String rescancelagencycode) {
		this.rescancelagencycode = rescancelagencycode;
	}

	public int getGamecode() {
		return gamecode;
	}

	public void setGamecode(int gamecode) {
		this.gamecode = gamecode;
	}

	public long getIssuenumber() {
		return issuenumber;
	}

	public void setIssuenumber(long issuenumber) {
		this.issuenumber = issuenumber;
	}

	public Date getSaletime() {
		return saletime;
	}

	public void setSaletime(Date saletime) {
		this.saletime = saletime;
	}

	public String getSaleagencycode() {
		return saleagencycode;
	}

	public void setSaleagencycode(String saleagencycode) {
		this.saleagencycode = saleagencycode;
	}

	public long getCancelamount() {
		return cancelamount;
	}

	public void setCancelamount(long cancelamount) {
		this.cancelamount = cancelamount;
	}

	public String getCanceler() {
		return canceler;
	}

	public void setCanceler(String canceler) {
		this.canceler = canceler;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public Date getDatetime() {
		return datetime;
	}

	public void setDatetime(Date datetime) {
		this.datetime = datetime;
	}

	public long getCancelcomm() {
		return cancelcomm;
	}

	public void setCancelcomm(long cancelcomm) {
		this.cancelcomm = cancelcomm;
	}

	public Long getCancelerAdmin() {
		return cancelerAdmin;
	}

	public void setCancelerAdmin(Long cancelerAdmin) {
		this.cancelerAdmin = cancelerAdmin;
	}

	public String getGameName() {
		return gameName;
	}

	public void setGameName(String gameName) {
		this.gameName = gameName;
	}

	public String getHtmltext() {
		return htmltext;
	}

	public void setHtmltext(String htmltext) {
		this.htmltext = htmltext;
	}

	public long getCancelCommision() {
		return cancelCommision;
	}

	public void setCancelCommision(long cancelCommision) {
		this.cancelCommision = cancelCommision;
	}

	public String getSaleAgencyCodeFormat() {
		return saleAgencyCodeFormat;
	}

	public void setSaleAgencyCodeFormat(String saleAgencyCodeFormat) {
		this.saleAgencyCodeFormat = saleAgencyCodeFormat;
	}

	public String getCancelAgencyCodeFormat() {
		return cancelAgencyCodeFormat;
	}

	public void setCancelAgencyCodeFormat(String cancelAgencyCodeFormat) {
		this.cancelAgencyCodeFormat = cancelAgencyCodeFormat;
	}

	@Override
	public String toString() {
		return "RefundForm [cancelAgencyCodeFormat=" + cancelAgencyCodeFormat + ", cancelCommision=" + cancelCommision + ", cancelagencycode=" + cancelagencycode + ", cancelamount=" + cancelamount + ", cancelcomm=" + cancelcomm + ", canceler=" + canceler + ", cancelerAdmin=" + cancelerAdmin
				+ ", datetime=" + datetime + ", gameName=" + gameName + ", gamecode=" + gamecode + ", htmltext=" + htmltext + ", issuenumber=" + issuenumber + ", pid=" + pid + ", reqfnticket=" + reqfnticket + ", reqfnticketcancel=" + reqfnticketcancel + ", reqtsn=" + reqtsn
				+ ", rescancelagencycode=" + rescancelagencycode + ", rspfnticketcancel=" + rspfnticketcancel + ", saleAgencyCodeFormat=" + saleAgencyCodeFormat + ", saleagencycode=" + saleagencycode + ", saletime=" + saletime + ", tsn=" + tsn + "]";
	}

}
