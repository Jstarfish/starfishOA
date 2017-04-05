package cls.pilottery.oms.lottery.model;

import cls.pilottery.common.model.BaseEntity;

import java.util.List;

/**
 * Created by Reno Main on 2016/5/19.
 */
public class BadTicket extends BaseEntity {
    private String agencyCode;//站点编号
    private String saleTime;//销售时间
    private String issueNumber;//游戏期次
    private String saleTsn;//销售票号
    private String applyFlow;
    private String betlistStr;// 投注行信息列表
    private String gameName;//销售票号
    private int sellSeq;

    public String getGameName() {
        return gameName;
    }

    public void setGameName(String gameName) {
        this.gameName = gameName;
    }

    private List<Betinfo> betlist;// 投注行信息列表

    public String getBetlistStr() {
        return betlistStr;
    }

    public void setBetlistStr(String betlistStr) {
        this.betlistStr = betlistStr;
    }

    public String getAgencyCode() {
        return agencyCode;
    }

    public void setAgencyCode(String agencyCode) {
        this.agencyCode = agencyCode;
    }

    public String getApplyFlow() {
        return applyFlow;
    }

    public void setApplyFlow(String applyFlow) {
        this.applyFlow = applyFlow;
    }

    public String getSaleTime() {
        return saleTime;
    }

    public void setSaleTime(String saleTime) {
        this.saleTime = saleTime;
    }

    public String getIssueNumber() {
        return issueNumber;
    }

    public void setIssueNumber(String issueNumber) {
        this.issueNumber = issueNumber;
    }

    public List<Betinfo> getBetlist() {
        return betlist;
    }

    public void setBetlist(List<Betinfo> betlist) {
        this.betlist = betlist;
    }

    public String getSaleTsn() {
        return saleTsn;
    }

    public void setSaleTsn(String saleTsn) {
        this.saleTsn = saleTsn;
    }

	public int getSellSeq() {
		return sellSeq;
	}

	public void setSellSeq(int sellSeq) {
		this.sellSeq = sellSeq;
	}
}
