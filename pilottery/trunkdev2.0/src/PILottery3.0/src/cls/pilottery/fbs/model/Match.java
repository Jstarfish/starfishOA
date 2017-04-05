package cls.pilottery.fbs.model;

import java.io.Serializable;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import cls.pilottery.common.model.BaseEntity;

public class Match extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 5127787752754971617L;

	private Long gameCode = 14l;

	private Long matchCode;
	private Long matchSeq;

	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date matchDate;

	private String homeTeamCode; // 主队
	private String guestTeamCode; // 客队
	private String homeTeamName;
	private String guestTeamName;

	private String matchDesc;
	private Long fbsIssueNumber; // 所属期次
	private Long competition; // 所属联赛
	private String competitionName;
	private int isSale;
	private int status; // 比赛状态
	private int fullTimeResult; // 全场比赛结果
	private int winLevelLosScore; // 胜负平让球数 WIN_LEVEL_LOS_SCORE
	private float winLosScore; // 胜负让球数 WIN_LOS_SCORE
	private int homeScore; // 主队全场进球数 fh_home_score
	private int guestScore; // 客队全场进球数 full_guest_score
	private Long competitionRound; // 比赛场次 COMPETITION_ROUND
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date matchStartDate; // 比赛开始时间
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") 
	private Date matchEndDate;	//
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") 
	private Date beginSaleDate;	//销售开始时间
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") 
	private Date endSaleDate;	//销售截止时间

	private int totalCount; // 球队比赛总场次
	private int flatCount; // 主队平的场次
	private int winCount;
	private int failCount;
	private int score; // 总进球数

	public int getIsSale() {
		return isSale;
	}

	public void setIsSale(int isSale) {
		this.isSale = isSale;
	}

	public Long getGameCode() {
		return gameCode;
	}

	public void setGameCode(Long gameCode) {
		this.gameCode = gameCode;
	}

	public int getScore() {
		return score;
	}

	public void setScore(int score) {
		this.score = score;
	}

	public int getFailCount() {
		return failCount;
	}

	public void setFailCount(int failCount) {
		this.failCount = failCount;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public int getFlatCount() {
		return flatCount;
	}

	public void setFlatCount(int flatCount) {
		this.flatCount = flatCount;
	}

	public int getWinCount() {
		return winCount;
	}

	public void setWinCount(int winCount) {
		this.winCount = winCount;
	}

	public Long getMatchCode() {
		return matchCode;
	}

	public void setMatchCode(Long matchCode) {
		this.matchCode = matchCode;
	}

	public Long getMatchSeq() {
		return matchSeq;
	}

	public void setMatchSeq(Long matchSeq) {
		this.matchSeq = matchSeq;
	}

	public Date getMatchDate() {
		return matchDate;
	}

	public void setMatchDate(Date matchDate) {
		this.matchDate = matchDate;
	}

	public String getHomeTeamCode() {
		return homeTeamCode;
	}

	public void setHomeTeamCode(String homeTeamCode) {
		this.homeTeamCode = homeTeamCode;
	}

	public String getGuestTeamCode() {
		return guestTeamCode;
	}

	public void setGuestTeamCode(String guestTeamCode) {
		this.guestTeamCode = guestTeamCode;
	}

	public String getHomeTeamName() {
		return homeTeamName;
	}

	public void setHomeTeamName(String homeTeamName) {
		this.homeTeamName = homeTeamName;
	}

	public String getGuestTeamName() {
		return guestTeamName;
	}

	public void setGuestTeamName(String guestTeamName) {
		this.guestTeamName = guestTeamName;
	}

	public String getMatchDesc() {
		return matchDesc;
	}

	public void setMatchDesc(String matchDesc) {
		this.matchDesc = matchDesc;
	}

	public Long getFbsIssueNumber() {
		return fbsIssueNumber;
	}

	public void setFbsIssueNumber(Long fbsIssueNumber) {
		this.fbsIssueNumber = fbsIssueNumber;
	}

	public Long getCompetition() {
		return competition;
	}

	public void setCompetition(Long competition) {
		this.competition = competition;
	}

	public String getCompetitionName() {
		return competitionName;
	}

	public void setCompetitionName(String competitionName) {
		this.competitionName = competitionName;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public int getFullTimeResult() {
		return fullTimeResult;
	}

	public void setFullTimeResult(int fullTimeResult) {
		this.fullTimeResult = fullTimeResult;
	}

	public int getWinLevelLosScore() {
		return winLevelLosScore;
	}

	public void setWinLevelLosScore(int winLevelLosScore) {
		this.winLevelLosScore = winLevelLosScore;
	}

	public float getWinLosScore() {
		return winLosScore;
	}

	public void setWinLosScore(float winLosScore) {
		this.winLosScore = winLosScore;
	}

	public int getHomeScore() {
		return homeScore;
	}

	public void setHomeScore(int homeScore) {
		this.homeScore = homeScore;
	}

	public int getGuestScore() {
		return guestScore;
	}

	public void setGuestScore(int guestScore) {
		this.guestScore = guestScore;
	}

	public Long getCompetitionRound() {
		return competitionRound;
	}

	public void setCompetitionRound(Long competitionRound) {
		this.competitionRound = competitionRound;
	}

	public Date getMatchStartDate() {
		return matchStartDate;
	}

	public void setMatchStartDate(Date matchStartDate) {
		this.matchStartDate = matchStartDate;
	}

	public Date getMatchEndDate() {
		return matchEndDate;
	}

	public void setMatchEndDate(Date matchEndDate) {
		this.matchEndDate = matchEndDate;
	}

	public Date getBeginSaleDate() {
		return beginSaleDate;
	}

	public void setBeginSaleDate(Date beginSaleDate) {
		this.beginSaleDate = beginSaleDate;
	}

	public Date getEndSaleDate() {
		return endSaleDate;
	}

	public void setEndSaleDate(Date endSaleDate) {
		this.endSaleDate = endSaleDate;
	}

}
