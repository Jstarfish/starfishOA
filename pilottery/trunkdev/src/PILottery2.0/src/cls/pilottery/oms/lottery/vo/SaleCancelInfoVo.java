package cls.pilottery.oms.lottery.vo;

import java.util.Date;

public class SaleCancelInfoVo implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String canceler;// 取消操作员
	private Date cancelTime;// 取消时间
	private String gameName;// 游戏名称
	private Long issueNumer;// 游戏期号
	private Long cancelAmount;// 取消金额
	private String saleTsn; // Tsn
	private String saleAgencyCode;// 销售站
	private Long cancelComm;// 佣金
	private Long isSuccess;// 是否成功
	private String cancelTsn;// 退票Tsn
	private String cancelAgencyCode;// 退票站点
	private String id;
	private Long gameCode;
	private Date caldate;
	private Date saleTime;
	private String saleAgencyCodeFormat;
	private String cancelAgencyCodeFormat;

	public String getCanceler() {
		return canceler;
	}

	public void setCanceler(String canceler) {
		this.canceler = canceler;
	}

	public Date getCancelTime() {
		return cancelTime;
	}

	public void setCancelTime(Date cancelTime) {
		this.cancelTime = cancelTime;
	}

	public String getGameName() {
		return gameName;
	}

	public void setGameName(String gameName) {
		this.gameName = gameName;
	}

	public Long getIssueNumer() {
		return issueNumer;
	}

	public void setIssueNumer(Long issueNumer) {
		this.issueNumer = issueNumer;
	}

	public Long getCancelAmount() {
		return cancelAmount;
	}

	public void setCancelAmount(Long cancelAmount) {
		this.cancelAmount = cancelAmount;
	}

	public String getSaleTsn() {
		return saleTsn;
	}

	public void setSaleTsn(String saleTsn) {
		this.saleTsn = saleTsn;
	}

	public String getSaleAgencyCode() {
		return saleAgencyCode;
	}

	public void setSaleAgencyCode(String saleAgencyCode) {
		this.saleAgencyCode = saleAgencyCode;
	}

	public Long getCancelComm() {
		return cancelComm;
	}

	public void setCancelComm(Long cancelComm) {
		this.cancelComm = cancelComm;
	}

	public Long getIsSuccess() {
		return isSuccess;
	}

	public void setIsSuccess(Long isSuccess) {
		this.isSuccess = isSuccess;
	}

	public String getCancelTsn() {
		return cancelTsn;
	}

	public void setCancelTsn(String cancelTsn) {
		this.cancelTsn = cancelTsn;
	}

	public String getCancelAgencyCode() {
		return cancelAgencyCode;
	}

	public void setCancelAgencyCode(String cancelAgencyCode) {
		this.cancelAgencyCode = cancelAgencyCode;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Long getGameCode() {
		return gameCode;
	}

	public void setGameCode(Long gameCode) {
		this.gameCode = gameCode;
	}

	public Date getCaldate() {
		return caldate;
	}

	public void setCaldate(Date caldate) {
		this.caldate = caldate;
	}

	public Date getSaleTime() {
		return saleTime;
	}

	public void setSaleTime(Date saleTime) {
		this.saleTime = saleTime;
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

}
