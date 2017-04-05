package cls.pilottery.oms.lottery.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import cls.pilottery.oms.common.utils.BeanFormart;

public class LotteryResModel implements Serializable{	    
	private static final long serialVersionUID = -1784665366781653289L;
	private String reqfn_ticket_pay;//
	private String rspfn_ticket_pay;//兑奖响应交易流水号
	private long unique_tsn;
	private long unique_tsn_pay;//
	private String rspfn_ticket;// char[25] 销售彩票TSN
    private String reqfn_ticket;//
	private long areaCode_pay;// 兑奖请求销售站编码
	private long respayagencycode;// uint64 兑奖请求销售站编码
	private int gamecode;// uint8 游戏编码
	private short issueCount;// uint8 期数
	private long startIssueNumber;// uint64 起始销售期号
	private long endIssueNumber;// uint64 结束销售期号
	private int saleTime;// uint32 销售时间
	private long winningAmountWithTax;// money_t(int64) 中奖金额(税前)
	private long taxAmount;// money_t(int64) 税金
	private long winningAmount;// money_t(int64) 中奖金额税后
	private int transTimeStamp;// uint32 交易时间
	private int betStringLen;// uint16 投注字符串长度
	private String betString; // 投注字符串
	private int prizeCount;// 中奖奖等数目
	private List<LotterPrize> prizeDetail;
	private List<Betinfo> betlist;// 投注行信息列表
	private String betprize;
	private Date saletime_format;
	private Date transtimestamp_format;
	
	public long getRespayagencycode() {
		return respayagencycode;
	}
	public void setRespayagencycode(long respayagencycode) {
		this.respayagencycode = respayagencycode;
	}
	public int getGamecode() {
		return gamecode;
	}
	public void setGamecode(int gamecode) {
		this.gamecode = gamecode;
	}
	public short getIssueCount() {
		return issueCount;
	}
	public void setIssueCount(short issueCount) {
		this.issueCount = issueCount;
	}


	
	public long getWinningAmountWithTax() {
		return winningAmountWithTax;
	}
	public void setWinningAmountWithTax(long winningAmountWithTax) {
		this.winningAmountWithTax = winningAmountWithTax;
	}
	public long getTaxAmount() {
		return taxAmount;
	}
	public void setTaxAmount(long taxAmount) {
		this.taxAmount = taxAmount;
	}
	public long getWinningAmount() {
		return winningAmount;
	}
	public void setWinningAmount(long winningAmount) {
		this.winningAmount = winningAmount;
	}
	public int getTransTimeStamp() {
		return transTimeStamp;
	}
	public void setTransTimeStamp(int transTimeStamp) {
		this.transtimestamp_format=new Date(transTimeStamp*1000);
		this.transTimeStamp = transTimeStamp;
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
		String[] bets = betString.split("[|]");
		String betprize = "";
		if (bets.length > 0) {
			betprize = bets[5];
		}

		if (betprize != "" && betprize != null) {
			String beprizes[] = betprize.split("/");
			if (beprizes.length > 0) {
				betlist = new ArrayList<Betinfo>();
				for (int i = 0; i < beprizes.length; i++) {
					Betinfo info = new Betinfo();
					String att[] = beprizes[i].split("-");
					if (att.length > 0) {
						info = BeanFormart.transBean(att);
						betlist.add(info);
					}
				}
			}

		}
		this.betString = betString;
	}


	public List<Betinfo> getBetlist() {
		return betlist;
	}
	public void setBetlist(List<Betinfo> betlist) {
		this.betlist = betlist;
	}
	public String getBetprize() {
		return betprize;
	}
	public void setBetprize(String betprize) {
		this.betprize = betprize;
	}
	
	
	public Date getSaletime_format() {
		return saletime_format;
	}
	public void setSaletime_format(Date saletime_format) {
		this.saletime_format = saletime_format;
	}
	public Date getTranstimestamp_format() {
		return transtimestamp_format;
	}
	public void setTranstimestamp_format(Date transtimestamp_format) {
		this.transtimestamp_format = transtimestamp_format;
	}
	public String getReqfn_ticket_pay() {
		return reqfn_ticket_pay;
	}
	public void setReqfn_ticket_pay(String reqfn_ticket_pay) {
		this.reqfn_ticket_pay = reqfn_ticket_pay;
	}
	public String getRspfn_ticket_pay() {
		return rspfn_ticket_pay;
	}
	public void setRspfn_ticket_pay(String rspfn_ticket_pay) {
		this.rspfn_ticket_pay = rspfn_ticket_pay;
	}
	public long getUnique_tsn() {
		return unique_tsn;
	}
	public void setUnique_tsn(long unique_tsn) {
		this.unique_tsn = unique_tsn;
	}
	public long getUnique_tsn_pay() {
		return unique_tsn_pay;
	}
	public void setUnique_tsn_pay(long unique_tsn_pay) {
		this.unique_tsn_pay = unique_tsn_pay;
	}
	public String getRspfn_ticket() {
		return rspfn_ticket;
	}
	public void setRspfn_ticket(String rspfn_ticket) {
		this.rspfn_ticket = rspfn_ticket;
	}
	public String getReqfn_ticket() {
		return reqfn_ticket;
	}
	public void setReqfn_ticket(String reqfn_ticket) {
		this.reqfn_ticket = reqfn_ticket;
	}
	public long getAreaCode_pay() {
		return areaCode_pay;
	}
	public void setAreaCode_pay(long areaCode_pay) {
		this.areaCode_pay = areaCode_pay;
	}
	public long getStartIssueNumber() {
		return startIssueNumber;
	}
	public void setStartIssueNumber(long startIssueNumber) {
		this.startIssueNumber = startIssueNumber;
	}
	public long getEndIssueNumber() {
		return endIssueNumber;
	}
	public void setEndIssueNumber(long endIssueNumber) {
		this.endIssueNumber = endIssueNumber;
	}
	public int getSaleTime() {
		return saleTime;
	}
	public void setSaleTime(int saleTime) {
		this.saletime_format=new Date(saleTime*1000);
		this.saleTime = saleTime;
	}
	public int getPrizeCount() {
		return prizeCount;
	}
	public void setPrizeCount(int prizeCount) {
		this.prizeCount = prizeCount;
	}
	public List<LotterPrize> getPrizeDetail() {
		return prizeDetail;
	}
	public void setPrizeDetail(List<LotterPrize> prizeDetail) {
		this.prizeDetail = prizeDetail;
	}
}
