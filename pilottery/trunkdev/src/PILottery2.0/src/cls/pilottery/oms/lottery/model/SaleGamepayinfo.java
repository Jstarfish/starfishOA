package cls.pilottery.oms.lottery.model;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;

/**
 * 兑奖信息记录表对应的实体
 * 
 * @author dell
 * 
 */
public class SaleGamepayinfo extends BaseEntity {
	private static final long serialVersionUID = 1L;
	private String saleTsn;// 对应的字段名称TSN cloumn SALE_TSN
	private String applyflowSale;// 售票请求流水号 cloumn APPLYFLOW_SALE
	private Long gameCode;// 游戏编码 cloumn GAME_CODE
	private Long issueNumber;// 游戏期号 cloumn ISSUE_NUMBER
	private Long payAmount;// 中奖金额 cloumn PAY_AMOUNT
	private Long payTax;// 税金 cloumn PAY_TAX
	private Long payamountAftertax;// 税后奖金 cloumn PAY_AMOUNT_AFTER_TAX
	private String winnerName;// 中奖人姓名 cloumn WINNERNAME
	private Long gender;// 中奖人性别(1=男、2=女) cloumn GENDER
	private Long certType;// 中奖人证件类型(10=身份证、20=护照、
							// 30=军官证、40=士兵证、50=回乡证、90=其他证件) cloumn CERT_TYPE

	private String certNo;// 中奖人证件号码 cloumn CERT_NO
	private Long age;// 中奖人年龄 cloumn AGE
	private String contact;// 中奖人联系方式 cloumn CONTACT
	private String payer;// 兑奖操作员 cloumn PAYER
	private Date payTime;// 兑奖时间 cloumn PAY_TIME
	private String payAddr;// 兑奖地点 cloumn PAY_ADDR

	private Long isSucess;// 是否成功
	private String agencyCode;// 销售站点
	private String htmlText;// 原始凭证
	private String id;
	private String payTsn;
	private String playName;
	private String playname;
	private Long issuenumbrend;
	private String agencyCodeFormart;

	public SaleGamepayinfo() {

	}

	public String getSaleTsn() {
		return saleTsn;
	}

	public void setSaleTsn(String saleTsn) {
		this.saleTsn = saleTsn;
	}

	public String getApplyflowSale() {
		return applyflowSale;
	}

	public void setApplyflowSale(String applyflowSale) {
		this.applyflowSale = applyflowSale;
	}

	public Long getGameCode() {
		return gameCode;
	}

	public void setGameCode(Long gameCode) {
		this.gameCode = gameCode;
	}

	public Long getIssueNumber() {
		return issueNumber;
	}

	public void setIssueNumber(Long issueNumber) {
		this.issueNumber = issueNumber;
	}

	public Long getPayAmount() {
		return payAmount;
	}

	public void setPayAmount(Long payAmount) {
		this.payAmount = payAmount;
	}

	public Long getPayTax() {
		return payTax;
	}

	public void setPayTax(Long payTax) {
		this.payTax = payTax;
	}

	public Long getPayamountAftertax() {
		return payamountAftertax;
	}

	public void setPayamountAftertax(Long payamountAftertax) {
		this.payamountAftertax = payamountAftertax;
	}

	public String getWinnerName() {
		return winnerName;
	}

	public void setWinnerName(String winnerName) {
		this.winnerName = winnerName;
	}

	public Long getGender() {
		return gender;
	}

	public void setGender(Long gender) {
		this.gender = gender;
	}

	public Long getCertType() {
		return certType;
	}

	public void setCertType(Long certType) {
		this.certType = certType;
	}

	public String getCertNo() {
		return certNo;
	}

	public void setCertNo(String certNo) {
		this.certNo = certNo;
	}

	public Long getAge() {
		return age;
	}

	public void setAge(Long age) {
		this.age = age;
	}

	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}

	public String getPayer() {
		return payer;
	}

	public void setPayer(String payer) {
		this.payer = payer;
	}

	public Date getPayTime() {
		return payTime;
	}

	public void setPayTime(Date payTime) {
		this.payTime = payTime;
	}

	public String getPayAddr() {
		return payAddr;
	}

	public void setPayAddr(String payAddr) {
		this.payAddr = payAddr;
	}

	public Long getIsSucess() {
		return isSucess;
	}

	public void setIsSucess(Long isSucess) {
		this.isSucess = isSucess;
	}

	public String getAgencyCode() {
		return agencyCode;
	}

	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}

	public String getHtmlText() {
		return htmlText;
	}

	public void setHtmlText(String htmlText) {
		this.htmlText = htmlText;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPayTsn() {
		return payTsn;
	}

	public void setPayTsn(String payTsn) {
		this.payTsn = payTsn;
	}

	public String getPlayName() {
		return playName;
	}

	public void setPlayName(String playName) {
		this.playName = playName;
	}

	public String getPlayname() {
		return playname;
	}

	public void setPlayname(String playname) {
		this.playname = playname;
	}

	public Long getIssuenumbrend() {
		return issuenumbrend;
	}

	public void setIssuenumbrend(Long issuenumbrend) {
		this.issuenumbrend = issuenumbrend;
	}

	public String getAgencyCodeFormart() {
		return agencyCodeFormart;
	}

	public void setAgencyCodeFormart(String agencyCodeFormart) {
		this.agencyCodeFormart = agencyCodeFormart;
	}

}
