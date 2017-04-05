package cls.pilottery.fbs.form;

import cls.pilottery.common.model.BaseEntity;

/**
 * Created by Reno Main on 2016/6/3.
 */
public class FbsDrawForm extends BaseEntity {

    private static final int bigSmallScore = 3;

    private Long gameCode;
    private String matchComp;
    private String startqueryTime;
    private String endqueryTime;

    private String matchDate;
    private Integer matchStatus;

    private String matchCode;

    private Integer subTypeCode;

    private long homeTeamCode;
    private long guestTeamCode;
    private String homeTeam;
    private String guestTeam;

    private int matchCompCode;
    private String issueCode;
    private long firstDrawUserId;
    private long secondDrawUserId;

    private String firstScoreTeam;
    private int firstfhHomeScore;
    private int firstfhGuestScore;
    private int firstshHomeScore;
    private int firstshGuestScore;

    private String secondScoreTeam;
    private int secondfhHomeScore;
    private int secondfhGuestScore;
    private int secondshHomeScore;
    private int secondshGuestScore;

    //胜平负让球
    private int score310;
    //胜负让球
    private float score30;


    private int firstFullScore;
    private int firstFullWinLosScore;
    private int firstFullWinLevelLosScore;
    private String firstHalfFullScore;
    private int firstFhshSingleDouble;
    private String firstSingleScore;

    private int secondFullScore;
    private int secondFullWinLosScore;
    private int secondFullWinLevelLosScore;
    private String secondHalfFullScore;
    private int secondFhshSingleDouble;
    private String secondSingleScore;


    private int fullHomeScore;
    private int fullGuestScore;

    private String finalScoreTeam;
    private Integer finalScoreTeamEnum;
    private int fullScore;
    private Integer fullScoreEnum;
    private int winlosResult;
    private Integer winlosResultEnum;
    private int winlevellosResult;
    private Integer winlevellosResultEnum;
    private String hfwinlevellosResult;
    private Integer hfwinlevellosResultEnum;
    private int hfSingleDouble;
    private String hfSingleDoubleString;
    private Integer hfSingleDoubleEnum;
    private String singleScore;
    private Integer singleScoreEnum;

    private Integer matchResultStatus;


    public String getFirstFhshSingleDoubleString() {
        getFirstFhshSingleDouble();
        String singleDoubleString = "";
        switch (this.firstFhshSingleDouble) {
            case 1:
                singleDoubleString = "上盘单数";
                break;
            case 2:
                singleDoubleString = "上盘双数";
                break;
            case 3:
                singleDoubleString = "下盘单数";
                break;
            case 4:
                singleDoubleString = "下盘双数";
                break;
        }
        return singleDoubleString;
    }

    public int getFirstFhshSingleDouble() {
        int fullScore = firstfhHomeScore + firstfhGuestScore + firstshHomeScore + firstshGuestScore;
        if (fullScore >= bigSmallScore) {
            if (fullScore % 2 == 0) {
                //上双
                this.firstFhshSingleDouble = 2;
            } else {
                //上单
                this.firstFhshSingleDouble = 1;
            }
        } else {
            if (fullScore % 2 == 0) {
                //下双
                this.firstFhshSingleDouble = 4;
            } else {
                //下单
                this.firstFhshSingleDouble = 3;
            }
        }
        return firstFhshSingleDouble;
    }

    public int getFirstFullScore() {
        this.firstFullScore = firstfhHomeScore + firstfhGuestScore + firstshHomeScore + firstshGuestScore;
        return firstFullScore;
    }

    public int getFirstFullWinLevelLosScore() {
        int score310 = getScore310();
        int homeScore = firstfhHomeScore + firstshHomeScore;
        int guestScore = firstfhGuestScore + firstshGuestScore;
        if (homeScore + score310 > guestScore) {
            this.firstFullWinLevelLosScore = 3;
        } else if (homeScore + score310 == guestScore) {
            this.firstFullWinLevelLosScore = 1;
        } else {
            this.firstFullWinLevelLosScore = 0;
        }
        return firstFullWinLevelLosScore;
    }

    public int getFirstFullWinLosScore() {
        float score30 = getScore30();
        int homeScore = firstfhHomeScore + firstshHomeScore;
        int guestScore = firstfhGuestScore + firstshGuestScore;
        if (homeScore + score30 > guestScore) {
            this.firstFullWinLosScore = 3;
        } else if (homeScore + score30 == guestScore) {
            this.firstFullWinLosScore = 1;//这里永远不会出现，因为score30是0.5或者1.5...
        } else {
            this.firstFullWinLosScore = 0;
        }
        return firstFullWinLosScore;
    }

    public String getFirstHalfFullScore() {
        String upHalf = "";
        String wholeGame = "";
        if (firstfhHomeScore > firstfhGuestScore) {
            upHalf = "3";
        } else if (firstfhHomeScore == firstfhGuestScore) {
            upHalf = "1";
        } else if (firstfhHomeScore < firstfhGuestScore){
            upHalf = "0";
        }

        if (firstfhHomeScore + firstshHomeScore > firstfhGuestScore + firstshGuestScore) {
            wholeGame = "3";
        } else if (firstfhHomeScore + firstshHomeScore == firstfhGuestScore + firstshGuestScore) {
            wholeGame = "1";
        } else  if (firstfhHomeScore + firstshHomeScore < firstfhGuestScore + firstshGuestScore){
            wholeGame = "0";
        }
        this.firstHalfFullScore = upHalf + "-" + wholeGame;
        return firstHalfFullScore;
    }

    public String getFirstSingleScore() {
        String homeScore = String.valueOf(firstfhHomeScore + firstshHomeScore);
        String guestScore = String.valueOf(firstfhGuestScore + firstshGuestScore);
        this.firstSingleScore = homeScore + ":" + guestScore;
        return firstSingleScore;
    }

    public String getSecondFhshSingleDoubleString() {
        getSecondFhshSingleDouble();
        String singleDoubleString = "";
        switch (this.secondFhshSingleDouble) {
            case 1:
                singleDoubleString = "上盘单数";
                this.hfSingleDoubleEnum = 1;
                break;
            case 2:
                singleDoubleString = "上盘双数";
                this.hfSingleDoubleEnum = 2;
                break;
            case 3:
                singleDoubleString = "下盘单数";
                this.hfSingleDoubleEnum = 3;
                break;
            case 4:
                singleDoubleString = "下盘双数";
                this.hfSingleDoubleEnum = 4;
                break;
        }
        return singleDoubleString;
    }

    public int getSecondFhshSingleDouble() {
        int fullScore = secondfhHomeScore + secondfhGuestScore + secondshHomeScore + secondshGuestScore;
        if (fullScore >= bigSmallScore) {
            if (fullScore % 2 == 0) {
                //上双
                this.secondFhshSingleDouble = 2;
                this.hfSingleDoubleEnum = 2;
            } else {
                //上单
                this.secondFhshSingleDouble = 1;
                this.hfSingleDoubleEnum = 1;
            }
        } else {
            if (fullScore % 2 == 0) {
                //下双
                this.secondFhshSingleDouble = 4;
                this.hfSingleDoubleEnum = 4;
            } else {
                //下单
                this.secondFhshSingleDouble = 3;
                this.hfSingleDoubleEnum = 3;
            }
        }
        return secondFhshSingleDouble;
    }

    public int getSecondFullScore() {
        this.secondFullScore = secondfhHomeScore + secondfhGuestScore + secondshHomeScore + secondshGuestScore;
        switch (secondFullScore) {
            case 0:
                this.fullScoreEnum = 1;
                break;
            case 1:
                this.fullScoreEnum = 2;
                break;
            case 2:
                this.fullScoreEnum = 3;
                break;
            case 3:
                this.fullScoreEnum = 4;
                break;
            case 4:
                this.fullScoreEnum = 5;
                break;
            case 5:
                this.fullScoreEnum = 6;
                break;
            case 6:
                this.fullScoreEnum = 7;
                break;
            case 7:
                this.fullScoreEnum = 8;
                break;
            default:
                this.fullScoreEnum = 8;
                break;
        }
        return secondFullScore;
    }

    public int getSecondFullWinLevelLosScore() {
        int score310 = getScore310();
        int homeScore = secondfhHomeScore + secondshHomeScore;
        int guestScore = secondfhGuestScore + secondshGuestScore;
        if (homeScore + score310 > guestScore) {
            this.secondFullWinLevelLosScore = 3;
            this.winlevellosResultEnum = 1;
        } else if (homeScore + score310 == guestScore) {
            this.secondFullWinLevelLosScore = 1;
            this.winlevellosResultEnum = 2;
        } else {
            this.secondFullWinLevelLosScore = 0;
            this.winlevellosResultEnum = 3;
        }
        return secondFullWinLevelLosScore;
    }

    public int getSecondFullWinLosScore() {
        float score30 = getScore30();
        int homeScore = secondfhHomeScore + secondshHomeScore;
        int guestScore = secondfhGuestScore + secondshGuestScore;
        if (homeScore + score30 > guestScore) {
            this.secondFullWinLosScore = 3;
            this.winlosResultEnum = 1;
        } else if (homeScore + score30 == guestScore) {
            this.secondFullWinLosScore = 1;//这里永远不会出现，因为score30是0.5或者1.5...
            this.winlosResultEnum = 2;
        } else {
            this.secondFullWinLosScore = 0;
            this.winlosResultEnum = 2;
        }
        return secondFullWinLosScore;
    }

    public String getSecondHalfFullScore() {
        String upHalf = "";
        String downHalf = "";
        if (secondfhHomeScore > secondfhGuestScore) {
            upHalf = "3";
        } else if (secondfhHomeScore == secondfhGuestScore) {
            upHalf = "1";
        } else if (secondfhHomeScore < secondfhGuestScore){
            upHalf = "0";
        }

        if (secondfhHomeScore+secondshHomeScore >secondfhGuestScore+ secondshGuestScore) {
            downHalf = "3";
        } else if (secondfhHomeScore+secondshHomeScore == secondfhGuestScore+secondshGuestScore) {
            downHalf = "1";
        } else if(secondfhHomeScore+secondshHomeScore < secondfhGuestScore+secondshGuestScore){
            downHalf = "0";
        }
        this.secondHalfFullScore = upHalf + "-" + downHalf;

        if (this.secondHalfFullScore.equals("3-3"))
            this.hfwinlevellosResultEnum = 1;
        if (this.secondHalfFullScore.equals("3-1"))
            this.hfwinlevellosResultEnum = 2;
        if (this.secondHalfFullScore.equals("3-0"))
            this.hfwinlevellosResultEnum = 3;
        if (this.secondHalfFullScore.equals("1-3"))
            this.hfwinlevellosResultEnum = 4;
        if (this.secondHalfFullScore.equals("1-1"))
            this.hfwinlevellosResultEnum = 5;
        if (this.secondHalfFullScore.equals("1-0"))
            this.hfwinlevellosResultEnum = 6;
        if (this.secondHalfFullScore.equals("0-3"))
            this.hfwinlevellosResultEnum = 7;
        if (this.secondHalfFullScore.equals("0-1"))
            this.hfwinlevellosResultEnum = 8;
        if (this.secondHalfFullScore.equals("0-0"))
            this.hfwinlevellosResultEnum = 9;
        return secondHalfFullScore;
    }

    public String getSecondSingleScore() {
        String homeScore = String.valueOf(secondfhHomeScore + secondshHomeScore);
        String guestScore = String.valueOf(secondfhGuestScore + secondshGuestScore);
        this.secondSingleScore = homeScore + ":" + guestScore;
        if (this.secondSingleScore.equals("1:0")) {
            this.singleScoreEnum = 1;
        } else if (this.secondSingleScore.equals("2:0")) {
            this.singleScoreEnum = 2;
        } else if (this.secondSingleScore.equals("2:1")) {
            this.singleScoreEnum = 3;
        } else if (this.secondSingleScore.equals("3:0")) {
            this.singleScoreEnum = 4;
        } else if (this.secondSingleScore.equals("3:1")) {
            this.singleScoreEnum = 5;
        } else if (this.secondSingleScore.equals("3:2")) {
            this.singleScoreEnum = 6;
        } else if (this.secondSingleScore.equals("4:0")) {
            this.singleScoreEnum = 7;
        } else if (this.secondSingleScore.equals("4:1")) {
            this.singleScoreEnum = 8;
        } else if (this.secondSingleScore.equals("4:2")) {
            this.singleScoreEnum = 9;
        } else if ((secondfhHomeScore + secondshHomeScore) > (secondfhGuestScore + secondshGuestScore)) {
            this.singleScoreEnum = 10;
        } else if (this.secondSingleScore.equals("0:0")) {
            this.singleScoreEnum = 11;
        } else if (this.secondSingleScore.equals("1:1")) {
            this.singleScoreEnum = 12;
        } else if (this.secondSingleScore.equals("2:2")) {
            this.singleScoreEnum = 13;
        } else if (this.secondSingleScore.equals("3:3")) {
            this.singleScoreEnum = 14;
        } else if ((secondfhHomeScore + secondshHomeScore) == (secondfhGuestScore + secondshGuestScore)) {
            this.singleScoreEnum = 15;
        } else if (this.secondSingleScore.equals("0:1")) {
            this.singleScoreEnum = 16;
        } else if (this.secondSingleScore.equals("0:2")) {
            this.singleScoreEnum = 17;
        } else if (this.secondSingleScore.equals("1:2")) {
            this.singleScoreEnum = 18;
        } else if (this.secondSingleScore.equals("0:3")) {
            this.singleScoreEnum = 19;
        } else if (this.secondSingleScore.equals("1:3")) {
            this.singleScoreEnum = 20;
        } else if (this.secondSingleScore.equals("2:3")) {
            this.singleScoreEnum = 21;
        } else if (this.secondSingleScore.equals("0:4")) {
            this.singleScoreEnum = 22;
        } else if (this.secondSingleScore.equals("1:4")) {
            this.singleScoreEnum = 23;
        } else if (this.secondSingleScore.equals("2:4")) {
            this.singleScoreEnum = 24;
        } else if ((secondfhHomeScore + secondshHomeScore) < (secondfhGuestScore + secondshGuestScore)) {
            this.singleScoreEnum = 25;
        }
        return secondSingleScore;
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

    public String getHfSingleDoubleString() {
        return hfSingleDoubleString;
    }

    public void setHfSingleDoubleString(String hfSingleDoubleString) {
        this.hfSingleDoubleString = hfSingleDoubleString;
    }

    public Integer getFinalScoreTeamEnum() {
        return finalScoreTeamEnum;
    }

    public void setFinalScoreTeamEnum(Integer finalScoreTeamEnum) {
        this.finalScoreTeamEnum = finalScoreTeamEnum;
    }

    public Integer getFullScoreEnum() {
        return fullScoreEnum;
    }

    public void setFullScoreEnum(Integer fullScoreEnum) {
        this.fullScoreEnum = fullScoreEnum;
    }

    public Integer getHfSingleDoubleEnum() {
        return hfSingleDoubleEnum;
    }

    public void setHfSingleDoubleEnum(Integer hfSingleDoubleEnum) {
        this.hfSingleDoubleEnum = hfSingleDoubleEnum;
    }

    public Integer getSingleScoreEnum() {
        return singleScoreEnum;
    }

    public void setSingleScoreEnum(Integer singleScoreEnum) {
        this.singleScoreEnum = singleScoreEnum;
    }

    public Integer getHfwinlevellosResultEnum() {
        return hfwinlevellosResultEnum;
    }

    public void setHfwinlevellosResultEnum(Integer hfwinlevellosResultEnum) {
        this.hfwinlevellosResultEnum = hfwinlevellosResultEnum;
    }

    public Integer getWinlevellosResultEnum() {
        return winlevellosResultEnum;
    }

    public void setWinlevellosResultEnum(Integer winlevellosResultEnum) {
        this.winlevellosResultEnum = winlevellosResultEnum;
    }

    public Integer getWinlosResultEnum() {
        return winlosResultEnum;
    }

    public void setWinlosResultEnum(Integer winlosResultEnum) {
        this.winlosResultEnum = winlosResultEnum;
    }

    public Integer getSubTypeCode() {
        return subTypeCode;
    }

    public void setSubTypeCode(Integer subTypeCode) {
        this.subTypeCode = subTypeCode;
    }

    public Long getGameCode() {
        return gameCode;
    }

    public void setGameCode(Long gameCode) {
        this.gameCode = gameCode;
    }

    public Integer getMatchStatus() {
        return matchStatus;
    }

    public void setMatchStatus(Integer matchStatus) {
        this.matchStatus = matchStatus;
    }

    public int getHfSingleDouble() {
        return hfSingleDouble;
    }

    public void setHfSingleDouble(int hfSingleDouble) {
        this.hfSingleDouble = hfSingleDouble;
    }

    public String getHfwinlevellosResult() {
        return hfwinlevellosResult;
    }

    public void setHfwinlevellosResult(String hfwinlevellosResult) {
        this.hfwinlevellosResult = hfwinlevellosResult;
    }

    public String getFinalScoreTeam() {
        return finalScoreTeam;
    }

    public void setFinalScoreTeam(String finalScoreTeam) {
        this.finalScoreTeam = finalScoreTeam;
    }

    public int getFullGuestScore() {
        return fullGuestScore;
    }

    public void setFullGuestScore(int fullGuestScore) {
        this.fullGuestScore = fullGuestScore;
    }

    public int getFullHomeScore() {
        return fullHomeScore;
    }

    public void setFullHomeScore(int fullHomeScore) {
        this.fullHomeScore = fullHomeScore;
    }

    public int getFullScore() {
        return fullScore;
    }

    public void setFullScore(int fullScore) {
        this.fullScore = fullScore;
    }

    public String getSingleScore() {
        return singleScore;
    }

    public void setSingleScore(String singleScore) {
        this.singleScore = singleScore;
    }

    public int getWinlevellosResult() {
        return winlevellosResult;
    }

    public void setWinlevellosResult(int winlevellosResult) {
        this.winlevellosResult = winlevellosResult;
    }

    public int getWinlosResult() {
        return winlosResult;
    }

    public void setWinlosResult(int winlosResult) {
        this.winlosResult = winlosResult;
    }

    public void setFirstFhshSingleDouble(int firstFhshSingleDouble) {
        this.firstFhshSingleDouble = firstFhshSingleDouble;
    }

    public void setFirstFullScore(int firstFullScore) {
        this.firstFullScore = firstFullScore;
    }

    public void setFirstFullWinLevelLosScore(int firstFullWinLevelLosScore) {
        this.firstFullWinLevelLosScore = firstFullWinLevelLosScore;
    }

    public void setFirstFullWinLosScore(int firstFullWinLosScore) {
        this.firstFullWinLosScore = firstFullWinLosScore;
    }

    public void setFirstHalfFullScore(String firstHalfFullScore) {
        this.firstHalfFullScore = firstHalfFullScore;
    }

    public void setFirstSingleScore(String firstSingleScore) {
        this.firstSingleScore = firstSingleScore;
    }

    public void setSecondFhshSingleDouble(int secondFhshSingleDouble) {
        this.secondFhshSingleDouble = secondFhshSingleDouble;
    }

    public void setSecondFullScore(int secondFullScore) {
        this.secondFullScore = secondFullScore;
    }

    public void setSecondFullWinLevelLosScore(int secondFullWinLevelLosScore) {
        this.secondFullWinLevelLosScore = secondFullWinLevelLosScore;
    }

    public void setSecondFullWinLosScore(int secondFullWinLosScore) {
        this.secondFullWinLosScore = secondFullWinLosScore;
    }

    public void setSecondHalfFullScore(String secondHalfFullScore) {
        this.secondHalfFullScore = secondHalfFullScore;
    }

    public void setSecondSingleScore(String secondSingleScore) {
        this.secondSingleScore = secondSingleScore;
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

    public String getMatchCode() {
        return matchCode;
    }

    public void setMatchCode(String matchCode) {
        this.matchCode = matchCode;
    }

    public int getFirstfhGuestScore() {
        return firstfhGuestScore;
    }

    public void setFirstfhGuestScore(int firstfhGuestScore) {
        this.firstfhGuestScore = firstfhGuestScore;
    }

    public int getFirstfhHomeScore() {
        return firstfhHomeScore;
    }

    public void setFirstfhHomeScore(int firstfhHomeScore) {
        this.firstfhHomeScore = firstfhHomeScore;
    }

    public String getFirstScoreTeam() {
        return firstScoreTeam;
    }

    public void setFirstScoreTeam(String firstScoreTeam) {
        this.firstScoreTeam = firstScoreTeam;
    }

    public int getFirstshGuestScore() {
        return firstshGuestScore;
    }

    public void setFirstshGuestScore(int firstshGuestScore) {
        this.firstshGuestScore = firstshGuestScore;
    }

    public int getFirstshHomeScore() {
        return firstshHomeScore;
    }

    public void setFirstshHomeScore(int firstshHomeScore) {
        this.firstshHomeScore = firstshHomeScore;
    }

    public int getSecondfhGuestScore() {
        return secondfhGuestScore;
    }

    public void setSecondfhGuestScore(int secondfhGuestScore) {
        this.secondfhGuestScore = secondfhGuestScore;
    }

    public int getSecondfhHomeScore() {
        return secondfhHomeScore;
    }

    public void setSecondfhHomeScore(int secondfhHomeScore) {
        this.secondfhHomeScore = secondfhHomeScore;
    }

    public String getSecondScoreTeam() {
        return secondScoreTeam;
    }

    public void setSecondScoreTeam(String secondScoreTeam) {
        this.secondScoreTeam = secondScoreTeam;
    }

    public int getSecondshGuestScore() {
        return secondshGuestScore;
    }

    public void setSecondshGuestScore(int secondshGuestScore) {
        this.secondshGuestScore = secondshGuestScore;
    }

    public int getSecondshHomeScore() {
        return secondshHomeScore;
    }

    public void setSecondshHomeScore(int secondshHomeScore) {
        this.secondshHomeScore = secondshHomeScore;
    }

    public String getMatchDate() {
        return matchDate;
    }

    public void setMatchDate(String matchDate) {
        this.matchDate = matchDate;
    }

    public String getEndqueryTime() {
        return endqueryTime;
    }

    public void setEndqueryTime(String endqueryTime) {
        this.endqueryTime = endqueryTime;
    }

    public String getMatchComp() {
        return matchComp;
    }

    public void setMatchComp(String matchComp) {
        this.matchComp = matchComp;
    }

    public String getStartqueryTime() {
        return startqueryTime;
    }

    public void setStartqueryTime(String startqueryTime) {
        this.startqueryTime = startqueryTime;
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

    public String getIssueCode() {
        return issueCode;
    }

    public void setIssueCode(String issueCode) {
        this.issueCode = issueCode;
    }

    public int getMatchCompCode() {
        return matchCompCode;
    }

    public void setMatchCompCode(int matchCompCode) {
        this.matchCompCode = matchCompCode;
    }

    public long getFirstDrawUserId() {
        return firstDrawUserId;
    }

    public void setFirstDrawUserId(long firstDrawUserId) {
        this.firstDrawUserId = firstDrawUserId;
    }

    public long getSecondDrawUserId() {
        return secondDrawUserId;
    }

    public void setSecondDrawUserId(long secondDrawUserId) {
        this.secondDrawUserId = secondDrawUserId;
    }

    public Integer getMatchResultStatus() {
        return matchResultStatus;
    }

    public void setMatchResultStatus(Integer matchResultStatus) {
        this.matchResultStatus = matchResultStatus;
    }
}
