package cls.pilottery.web.report.model;

import java.io.Serializable;

public class PayoutReportModel implements Serializable {

	private static final long serialVersionUID = 3602043606038751652L;

	private String payoutDate;

	private String gameName;

	private long onePrize;

	private long twoPrize;

	private long threePrize;

	private long fourPrize;

	private long fivePrize;

	private long sixPrize;

	private long senvenPrize;

	private long eightPrize;
	private long ninePrize;
	private long tenPrize;
	private long otherPrize;

	private long amount;

	public String getPayoutDate() {
		return payoutDate;
	}

	public void setPayoutDate(String payoutDate) {
		this.payoutDate = payoutDate;
	}

	public String getGameName() {
		return gameName;
	}

	public void setGameName(String gameName) {
		this.gameName = gameName;
	}

	public long getOnePrize() {
		return onePrize;
	}

	public void setOnePrize(long onePrize) {
		this.onePrize = onePrize;
	}

	public long getTwoPrize() {
		return twoPrize;
	}

	public void setTwoPrize(long twoPrize) {
		this.twoPrize = twoPrize;
	}

	public long getThreePrize() {
		return threePrize;
	}

	public void setThreePrize(long threePrize) {
		this.threePrize = threePrize;
	}

	public long getFourPrize() {
		return fourPrize;
	}

	public void setFourPrize(long fourPrize) {
		this.fourPrize = fourPrize;
	}

	public long getFivePrize() {
		return fivePrize;
	}

	public void setFivePrize(long fivePrize) {
		this.fivePrize = fivePrize;
	}

	public long getSixPrize() {
		return sixPrize;
	}

	public void setSixPrize(long sixPrize) {
		this.sixPrize = sixPrize;
	}

	public long getSenvenPrize() {
		return senvenPrize;
	}

	public void setSenvenPrize(long senvenPrize) {
		this.senvenPrize = senvenPrize;
	}

	public long getAmount() {
		return amount;
	}

	public void setAmount(long amount) {
		this.amount = amount;
	}

	public long getEightPrize() {
		return eightPrize;
	}

	public void setEightPrize(long eightPrize) {
		this.eightPrize = eightPrize;
	}

	public long getNinePrize() {
		return ninePrize;
	}

	public void setNinePrize(long ninePrize) {
		this.ninePrize = ninePrize;
	}

	public long getTenPrize() {
		return tenPrize;
	}

	public void setTenPrize(long tenPrize) {
		this.tenPrize = tenPrize;
	}

	public long getOtherPrize() {
		return otherPrize;
	}

	public void setOtherPrize(long otherPrize) {
		this.otherPrize = otherPrize;
	}
}