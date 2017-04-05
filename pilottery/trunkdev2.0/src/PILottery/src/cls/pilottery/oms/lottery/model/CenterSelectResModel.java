package cls.pilottery.oms.lottery.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import cls.pilottery.oms.common.utils.BeanFormart;

public class CenterSelectResModel implements Serializable {

	private static final long serialVersionUID = 4482166366082698607L;
	private String rspfn_ticket;
	private int gameCode;
	private String gameName;
	private int from_sale;
	private long startIssueNumber;
	private long lastIssueNumber; // uint64 结束期次
	private int issueCount; // uint32 总期数
	private long ticketAmount;// uint64 票面金额
	private int isTrain;// uint8 是否是培训票
	private int isCancel;// uint8 是否已退票:已退票(1)
	private int isWin;// uint8 是否中奖:未开奖(0) 未中奖(1) 中奖(2)
	private int isBigPrize; // uint8 是否是大奖
	private long amountBeforeTax;// uint64 中奖金额(税前)
	private long taxAmount; // uint64 税金
	private long amountAfterTax; // uint64 中奖金额(税后)
	private long sale_termCode; // uint64 售票终端编码
	private int sale_tellerCode; // uint32 售票销售员编码
	private long sale_time; // uint32 销售时间
	private int isPayed; // uint8 是否已兑奖:未兑奖(0) 已兑奖(1)
	private String pay_termCode;
	private String pay_tellerCode; // uint32 兑奖销售员编码
	private long pay_time;// 兑奖时间
	private String cancel_termCode; // uint64 退票终端编码
	private String cancel_tellerCode; // uint32 退票销售员编码
	private int cancel_time; // uint32 退票时间
	private String customName;// char[64] 彩民姓名
	private int cardType;// 件类型:身份证(1)护照(2)军官证(3)士兵证(4)回乡证(5)其他证件(9)
	private String cardCode; // char[18] 证件号码
	private int betStringLen;// uint16 投注字符串长度
	private String betString; // 投注字符串
	private String[] betStrings;// 投注字符串解析
	private int count;// 中奖奖等数目
	private String issue;// 期号
	private String periods;// 连续购买期数
	private String betingstr;// 投注行信息
	private List<GamePrize> prizes;
	private int bettinglinenumber;// 投注行数目
	private List<Betinfo> betlist;// 投注行信息列表
	private String tickAmount;// 投注票金额
	private Date pay_timeformat;
	private Date cancel_timeformat;
	private Date sale_timeformat;

	public Date getCancel_timeformat() {
		return cancel_timeformat;
	}

	public void setCancel_timeformat(Date cancel_timeformat) {
		this.cancel_timeformat = cancel_timeformat;
	}

	public String getRspfn_ticket() {
		return rspfn_ticket;
	}

	public void setRspfn_ticket(String rspfn_ticket) {
		this.rspfn_ticket = rspfn_ticket;
	}

	public int getGameCode() {
		return gameCode;
	}

	public void setGameCode(int gameCode) {
		this.gameCode = gameCode;
	}

	public String getGameName() {
		return gameName;
	}

	public void setGameName(String gameName) {
		this.gameName = gameName;
	}

	public long getStartIssueNumber() {
		return startIssueNumber;
	}

	public void setStartIssueNumber(long startIssueNumber) {
		this.startIssueNumber = startIssueNumber;
	}

	public long getLastIssueNumber() {
		return lastIssueNumber;
	}

	public void setLastIssueNumber(long lastIssueNumber) {
		this.lastIssueNumber = lastIssueNumber;
	}

	public int getIssueCount() {
		return issueCount;
	}

	public void setIssueCount(int issueCount) {
		this.issueCount = issueCount;
	}

	public long getTicketAmount() {
		return ticketAmount;
	}

	public void setTicketAmount(long ticketAmount) {
		this.ticketAmount = ticketAmount;
	}

	public int getIsTrain() {
		return isTrain;
	}

	public void setIsTrain(int isTrain) {
		this.isTrain = isTrain;
	}

	public int getIsCancel() {
		return isCancel;
	}

	public void setIsCancel(int isCancel) {
		this.isCancel = isCancel;
	}

	public int getIsWin() {
		return isWin;
	}

	public void setIsWin(int isWin) {
		this.isWin = isWin;
	}

	public int getIsBigPrize() {
		return isBigPrize;
	}

	public void setIsBigPrize(int isBigPrize) {
		this.isBigPrize = isBigPrize;
	}

	public long getAmountBeforeTax() {
		return amountBeforeTax;
	}

	public void setAmountBeforeTax(long amountBeforeTax) {
		this.amountBeforeTax = amountBeforeTax;
	}

	public long getTaxAmount() {
		return taxAmount;
	}

	public void setTaxAmount(long taxAmount) {
		this.taxAmount = taxAmount;
	}

	public long getAmountAfterTax() {
		return amountAfterTax;
	}

	public void setAmountAfterTax(long amountAfterTax) {
		this.amountAfterTax = amountAfterTax;
	}

	public long getSale_termCode() {
		return sale_termCode;
	}

	public void setSale_termCode(long sale_termCode) {
		this.sale_termCode = sale_termCode;
	}

	public int getSale_tellerCode() {
		return sale_tellerCode;
	}

	public void setSale_tellerCode(int sale_tellerCode) {
		this.sale_tellerCode = sale_tellerCode;
	}

	public long getSale_time() {
		return sale_time;
	}

	public void setSale_time(long sale_time) {
		if (sale_time > 0) {
			this.sale_timeformat = new Date(sale_time * 1000L);
		}
		this.sale_time = sale_time;
	}

	public int getIsPayed() {
		return isPayed;
	}

	public void setIsPayed(int isPayed) {
		this.isPayed = isPayed;
	}

	public String getPay_termCode() {
		return pay_termCode;
	}

	public void setPay_termCode(String pay_termCode) {
		this.pay_termCode = pay_termCode;
	}

	public String getPay_tellerCode() {
		return pay_tellerCode;
	}

	public void setPay_tellerCode(String pay_tellerCode) {
		this.pay_tellerCode = pay_tellerCode;
	}

	public long getPay_time() {
		return pay_time;
	}

	public void setPay_time(long pay_time) {
		if (pay_time > 0) {
			this.pay_timeformat = new Date(pay_time * 1000L);
		}
		this.pay_time = pay_time;
	}

	public String getCancel_termCode() {
		return cancel_termCode;
	}

	public void setCancel_termCode(String cancel_termCode) {
		this.cancel_termCode = cancel_termCode;
	}

	public String getCancel_tellerCode() {
		return cancel_tellerCode;
	}

	public void setCancel_tellerCode(String cancel_tellerCode) {
		this.cancel_tellerCode = cancel_tellerCode;
	}

	public int getCancel_time() {
		return cancel_time;
	}

	public void setCancel_time(int cancel_time) {
		if (cancel_time > 0) {
			this.cancel_timeformat = new Date(cancel_time * 1000L);
		}
		this.cancel_time = cancel_time;
	}

	public String getCustomName() {
		return customName;
	}

	public void setCustomName(String customName) {
		this.customName = customName;
	}

	public int getCardType() {
		return cardType;
	}

	public void setCardType(int cardType) {
		this.cardType = cardType;
	}

	public String getCardCode() {
		return cardCode;
	}

	public void setCardCode(String cardCode) {
		this.cardCode = cardCode;
	}

	public int getBetStringLen() {
		return betStringLen;
	}

	public void setBetStringLen(int betStringLen) {
		this.betStringLen = betStringLen;
	}

	public String getBetString() {

		return betString;
	}

	public void setBetString(String betString) {
		if (betString != "" && betString != null) {
			String[] bets = betString.split("[|]");
			if (bets.length > 0) {
				for (int j = 0; j < bets.length; j++) {
					if (j == 1) {
						// issue = bets[j];
						this.setIssue(bets[j]);
					}
					if (j == 2) {
						// periods = bets[j];
						this.setPeriods(bets[j]);

					}
					if (j == 3) {
						// tickAmount = bets[j];
						this.setTickAmount(bets[j]);
					}
					if (j == 5) {
						// betingstr = bets[j];
						this.setBetingstr(bets[j]);

					}
				}
			}
		}
		this.betString = betString;
	}

	public String[] getBetStrings() {
		return betStrings;
	}

	public void setBetStrings(String[] betStrings) {
		this.betStrings = betStrings;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public String getIssue() {
		return issue;
	}

	public void setIssue(String issue) {
		this.issue = issue;
	}

	public String getPeriods() {
		return periods;
	}

	public void setPeriods(String periods) {
		this.periods = periods;
	}

	public String getBetingstr() {
		return betingstr;
	}

	public void setBetingstr(String betingstr) {

		this.betingstr = betingstr;
		if (!"".equals(betingstr) && null != betingstr) {
			String betatt[] = betingstr.split("/");
			bettinglinenumber = betatt.length;
			if (betatt.length > 0) {
				betlist = new ArrayList<Betinfo>();
				for (int i = 0; i < betatt.length; i++) {
					Betinfo info = new Betinfo();
					String att[] = betatt[i].split("-");
					if (att.length > 0) {
						info = BeanFormart.transBean(att);
						betlist.add(info);
					}
				}

			}
		}
	}

	public List<GamePrize> getPrizes() {
		return prizes;
	}

	public void setPrizes(List<GamePrize> prizes) {
		this.prizes = prizes;
	}

	public int getBettinglinenumber() {
		return bettinglinenumber;
	}

	public void setBettinglinenumber(int bettinglinenumber) {
		this.bettinglinenumber = bettinglinenumber;
	}

	public List<Betinfo> getBetlist() {
		return betlist;
	}

	public void setBetlist(List<Betinfo> betlist) {
		this.betlist = betlist;
	}

	public String getTickAmount() {
		return tickAmount;
	}

	public void setTickAmount(String tickAmount) {
		this.tickAmount = tickAmount;
	}

	public Date getPay_timeformat() {
		return pay_timeformat;
	}

	public void setPay_timeformat(Date pay_timeformat) {
		this.pay_timeformat = pay_timeformat;
	}

	public Date getSale_timeformat() {
		return sale_timeformat;
	}

	public void setSale_timeformat(Date sale_timeformat) {
		this.sale_timeformat = sale_timeformat;
	}

	public int getFrom_sale() {
		return from_sale;
	}

	public void setFrom_sale(int from_sale) {
		this.from_sale = from_sale;
	}
}
