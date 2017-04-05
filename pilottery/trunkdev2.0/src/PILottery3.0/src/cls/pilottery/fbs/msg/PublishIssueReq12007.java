package cls.pilottery.fbs.msg;

/**
 * Created by Reno Main on 2016/6/12.
 */
public class PublishIssueReq12007 implements java.io.Serializable{
    private static final long serialVersionUID = 4697452198441721002L;
    private Long gameCode;

    public Long getGameCode() {
        return gameCode;
    }

    public void setGameCode(Long gameCode) {
        this.gameCode = gameCode;
    }
}
