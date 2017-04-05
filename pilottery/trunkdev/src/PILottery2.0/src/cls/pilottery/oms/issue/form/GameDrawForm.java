package cls.pilottery.oms.issue.form;

import cls.pilottery.oms.issue.model.GameDrawInfo;

public class GameDrawForm {
    private Short gameCode;
    private Long issueNumber;

    private String shortName;
    
    private String drawNumber;

    private String prize_levels;
    private String prize_amounts;

    private GameDrawInfo gameDrawInfo = new GameDrawInfo();

    public Short getGameCode() {
        return gameCode;
    }
    public void setGameCode(Short gameCode) {
        this.gameCode = gameCode;
    }
    public Long getIssueNumber() {
        return issueNumber;
    }
    public void setIssueNumber(Long issueNumber) {
        this.issueNumber = issueNumber;
    }
    public String getDrawNumber() {
        return drawNumber;
    }
    public void setDrawNumber(String drawNumber) {
        this.drawNumber = drawNumber;
    }
    public GameDrawInfo getGameDrawInfo() {
        return gameDrawInfo;
    }
    public void setGameDrawInfo(GameDrawInfo gameDrawInfo) {
        this.gameDrawInfo = gameDrawInfo;
    }
    public String getPrize_levels() {
        return prize_levels;
    }
    public void setPrize_levels(String prize_levels) {
        this.prize_levels = prize_levels;
    }
    public String getPrize_amounts() {
        return prize_amounts;
    }
    public void setPrize_amounts(String prize_amounts) {
        this.prize_amounts = prize_amounts;
    }
    public String getShortName() {
        return shortName;
    }
    public void setShortName(String shortName) {
        this.shortName = shortName;
    }


}
