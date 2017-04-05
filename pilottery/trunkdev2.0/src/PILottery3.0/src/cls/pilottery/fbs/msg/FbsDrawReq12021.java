package cls.pilottery.fbs.msg;

/**
 * Created by Reno Main on 2016/6/12.
 */
public class FbsDrawReq12021 implements java.io.Serializable{
    private static final long serialVersionUID = 4697452198441721002L;
    private Long gameCode;
    private Long issueNumber;
    private Long matchCode;
    private String drawResults;
    private String matchResult;


    public Long getGameCode() {
        return gameCode;
    }

    public void setGameCode(Long gameCode) {
        this.gameCode = gameCode;
    }

    public String getDrawResults() {
        return drawResults;
    }

    public void setDrawResults(String drawResults) {
        this.drawResults = drawResults;
    }

    public Long getIssueNumber() {
        return issueNumber;
    }

    public void setIssueNumber(Long issueNumber) {
        this.issueNumber = issueNumber;
    }

    public Long getMatchCode() {
        return matchCode;
    }

    public void setMatchCode(Long matchCode) {
        this.matchCode = matchCode;
    }

    public String getMatchResult() {
        return matchResult;
    }

    public void setMatchResult(String matchResult) {
        this.matchResult = matchResult;
    }
}
