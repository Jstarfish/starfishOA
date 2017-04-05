package cls.pilottery.fbs.model;

import cls.pilottery.common.model.BaseEntity;

/**
 * Created by Reno Main on 2016/6/3.
 */
public class FbsMatch extends BaseEntity {
    private String matchCode;
    private String matchSeq;
    private String matchDesc;
    private String matchComp;
    private int matchCompCode;
    private String homeTeam;
    private long homeTeamCode;
    private String guestTeam;
    private long guestTeamCode;

    private String matchIssue;

    //胜平负让球
    private int score310;
    //胜负让球
    private float score30;

    private String matchDate;
    private String matchStartTime;
    private String matchEndTime;

    private String beginSaleTime;
    private String endSaleTime;

    private int saleStatus;
    private int matchStatus;
    private int drawStatus;
    private String matchResultTime;
    private String matchRewardTime;

    private long firstDrawUserId;
    private long secondDrawUserId;

    private Integer firstfhHomeScore;
    private Integer firstfhGuestScore;
    private Integer firstshHomeScore;
    private Integer firstshGuestScore;

    private Integer finalScoreTeam;

    public Integer getFinalScoreTeam() {
        return finalScoreTeam;
    }

    public void setFinalScoreTeam(Integer finalScoreTeam) {
        this.finalScoreTeam = finalScoreTeam;
    }

    public int getSaleStatus() {
        return saleStatus;
    }

    public void setSaleStatus(int saleStatus) {
        this.saleStatus = saleStatus;
    }

    public Integer getFirstfhGuestScore() {
        return firstfhGuestScore;
    }

    public void setFirstfhGuestScore(Integer firstfhGuestScore) {
        this.firstfhGuestScore = firstfhGuestScore;
    }

    public Integer getFirstfhHomeScore() {
        return firstfhHomeScore;
    }

    public void setFirstfhHomeScore(Integer firstfhHomeScore) {
        this.firstfhHomeScore = firstfhHomeScore;
    }

    public Integer getFirstshGuestScore() {
        return firstshGuestScore;
    }

    public void setFirstshGuestScore(Integer firstshGuestScore) {
        this.firstshGuestScore = firstshGuestScore;
    }

    public Integer getFirstshHomeScore() {
        return firstshHomeScore;
    }

    public void setFirstshHomeScore(Integer firstshHomeScore) {
        this.firstshHomeScore = firstshHomeScore;
    }

    public long getSecondDrawUserId() {
        return secondDrawUserId;
    }

    public void setSecondDrawUserId(long secondDrawUserId) {
        this.secondDrawUserId = secondDrawUserId;
    }

    public long getFirstDrawUserId() {
        return firstDrawUserId;
    }

    public void setFirstDrawUserId(long firstDrawUserId) {
        this.firstDrawUserId = firstDrawUserId;
    }

    public int getMatchCompCode() {
        return matchCompCode;
    }

    public void setMatchCompCode(int matchCompCode) {
        this.matchCompCode = matchCompCode;
    }

    public long getGuestTeamCode() {
        return guestTeamCode;
    }

    public void setGuestTeamCode(long guestTeamCode) {
        this.guestTeamCode = guestTeamCode;
    }

    public long getHomeTeamCode() {
        return homeTeamCode;
    }

    public void setHomeTeamCode(long homeTeamCode) {
        this.homeTeamCode = homeTeamCode;
    }

    public int getDrawStatus() {
        return drawStatus;
    }

    public void setDrawStatus(int drawStatus) {
        this.drawStatus = drawStatus;
    }

    public String getMatchIssue() {
        return matchIssue;
    }

    public void setMatchIssue(String matchIssue) {
        this.matchIssue = matchIssue;
    }

    public String getMatchResultTime() {
        return matchResultTime;
    }

    public void setMatchResultTime(String matchResultTime) {
        this.matchResultTime = matchResultTime;
    }

    public String getMatchRewardTime() {
        return matchRewardTime;
    }

    public void setMatchRewardTime(String matchRewardTime) {
        this.matchRewardTime = matchRewardTime;
    }

    public int getMatchStatus() {
        return matchStatus;
    }

    public void setMatchStatus(int matchStatus) {
        this.matchStatus = matchStatus;
    }

    public String getEndSaleTime() {
        return endSaleTime;
    }

    public void setEndSaleTime(String endSaleTime) {
        this.endSaleTime = endSaleTime;
    }

    public float getScore30() {
        return score30;
    }

    public void setScore30(float score30) {
        this.score30 = score30;
    }

    public int getScore310() {
        return score310;
    }

    public void setScore310(int score310) {
        this.score310 = score310;
    }

    public String getBeginSaleTime() {
        return beginSaleTime;
    }

    public void setBeginSaleTime(String beginSaleTime) {
        this.beginSaleTime = beginSaleTime;
    }

    public String getMatchDate() {
        return matchDate;
    }

    public void setMatchDate(String matchDate) {
        this.matchDate = matchDate;
    }

    public String getMatchStartTime() {
        return matchStartTime;
    }

    public void setMatchStartTime(String matchStartTime) {
        this.matchStartTime = matchStartTime;
    }

    public String getMatchEndTime() {
        return matchEndTime;
    }

    public void setMatchEndTime(String matchEndTime) {
        this.matchEndTime = matchEndTime;
    }

    public String getMatchCode() {
        return matchCode;
    }

    public void setMatchCode(String matchCode) {
        this.matchCode = matchCode;
    }

    public String getMatchSeq() {
        return matchSeq;
    }

    public void setMatchSeq(String matchSeq) {
        this.matchSeq = matchSeq;
    }

    public String getMatchDesc() {
        return matchDesc;
    }

    public void setMatchDesc(String matchDesc) {
        this.matchDesc = matchDesc;
    }

    public String getMatchComp() {
        return matchComp;
    }

    public void setMatchComp(String matchComp) {
        this.matchComp = matchComp;
    }

    public String getHomeTeam() {
        return homeTeam;
    }

    public void setHomeTeam(String homeTeam) {
        this.homeTeam = homeTeam;
    }

    public String getGuestTeam() {
        return guestTeam;
    }

    public void setGuestTeam(String guestTeam) {
        this.guestTeam = guestTeam;
    }
}
