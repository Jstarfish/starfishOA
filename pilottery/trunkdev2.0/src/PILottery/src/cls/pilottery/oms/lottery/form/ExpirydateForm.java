package cls.pilottery.oms.lottery.form;

import cls.pilottery.common.model.BaseEntity;

public class ExpirydateForm extends BaseEntity {
	private static final long serialVersionUID = 7813600960931487869L;
	private String tsnquery;
	private String reqfnticketpay;
	private String payagencycode;
	private String name;
	private Long sex;
	private Long age;
	private Long cardType;
	private String carId;
	private String guipayFlow;
	private long gameCode;
	private long issuenumber;// uint64 销售期号
	private Long payAmount;// 中奖金额 cloumn PAY_AMOUNT
	private Long payTax;// 税金 cloumn PAY_TAX
	private Long payamountAftertax;// 税后奖金 cloumn PAY_AMOUNT_AFTER_TAX
	private String realname;
	private String htmlText;
	private String gameName;
	private String contact;
	private Long payerAdmin;
	private String playname;
	private String reqfnticket;
	private String tsn;
	private long issuenumbrend;
	private String agencyCodeFormart;
	private String birthdate;

	public String getTsnquery() {
		return tsnquery;
	}

	public void setTsnquery(String tsnquery) {
		this.tsnquery = tsnquery;
	}

	public String getReqfnticketpay() {
		return reqfnticketpay;
	}

	public void setReqfnticketpay(String reqfnticketpay) {
		this.reqfnticketpay = reqfnticketpay;
	}

	public String getPayagencycode() {
		return payagencycode;
	}

	public void setPayagencycode(String payagencycode) {
		this.payagencycode = payagencycode;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Long getSex() {
		return sex;
	}

	public void setSex(Long sex) {
		this.sex = sex;
	}

	public Long getAge() {
		return age;
	}

	public void setAge(Long age) {
		this.age = age;
	}

	public Long getCardType() {
		return cardType;
	}

	public void setCardType(Long cardType) {
		this.cardType = cardType;
	}

	public String getCarId() {
		return carId;
	}

	public void setCarId(String carId) {
		this.carId = carId;
	}

	public String getGuipayFlow() {
		return guipayFlow;
	}

	public void setGuipayFlow(String guipayFlow) {
		this.guipayFlow = guipayFlow;
	}

	public long getGameCode() {
		return gameCode;
	}

	public void setGameCode(long gameCode) {
		this.gameCode = gameCode;
	}

	public long getIssuenumber() {
		return issuenumber;
	}

	public void setIssuenumber(long issuenumber) {
		this.issuenumber = issuenumber;
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

	public String getRealname() {
		return realname;
	}

	public void setRealname(String realname) {
		this.realname = realname;
	}

	public String getHtmlText() {
		return htmlText;
	}

	public void setHtmlText(String htmlText) {
		this.htmlText = htmlText;
	}

	public String getGameName() {
		return gameName;
	}

	public void setGameName(String gameName) {
		this.gameName = gameName;
	}

	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}

	public Long getPayerAdmin() {
		return payerAdmin;
	}

	public void setPayerAdmin(Long payerAdmin) {
		this.payerAdmin = payerAdmin;
	}

	public String getPlayname() {
		return playname;
	}

	public void setPlayname(String playname) {
		this.playname = playname;
	}

	public String getReqfnticket() {
		return reqfnticket;
	}

	public void setReqfnticket(String reqfnticket) {
		if (reqfnticket != "" && reqfnticket != null) {
			this.reqfnticket = reqfnticket.substring(0, 24);
		}

	}

	public String getTsn() {
		return tsn;
	}

	public void setTsn(String tsn) {
		if (tsn != null && tsn != "") {
			this.tsn = tsn.substring(0, 24);
		}
	}

	public long getIssuenumbrend() {
		return issuenumbrend;
	}

	public void setIssuenumbrend(long issuenumbrend) {
		this.issuenumbrend = issuenumbrend;
	}

	public String getAgencyCodeFormart() {
		return agencyCodeFormart;
	}

	public void setAgencyCodeFormart(String agencyCodeFormart) {
		this.agencyCodeFormart = agencyCodeFormart;
	}

	public String getBirthdate() {
		return birthdate;
	}

	public void setBirthdate(String birthdate) {
		this.birthdate = birthdate;
	}

}
