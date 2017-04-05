package cls.pilottery.fbs.model;

import cls.pilottery.common.model.BaseEntity;

import java.util.Date;

/**
 * Created by Reno Main on 2016/6/1.
 */
public class FbsIssue extends BaseEntity {
    private Long fbsIssueNumber;
    private String fbsIssueStart;
    private String fbsIssueEnd;
    private String publishTime;
    private int publishStatus;
    private String fbsIssueDate;

    private Integer matchCount;
    private Short gameCode;
    
    public Short getGameCode() {
		return gameCode;
	}

	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
	}

	public Integer getMatchCount() {
        return matchCount;
    }

    public void setMatchCount(Integer matchCount) {
        this.matchCount = matchCount;
    }

    public Long getFbsIssueNumber() {
        return fbsIssueNumber;
    }

    public void setFbsIssueNumber(Long fbsIssueNumber) {
        this.fbsIssueNumber = fbsIssueNumber;
    }

    public int getPublishStatus() {
        return publishStatus;
    }

    public void setPublishStatus(int publishStatus) {
        this.publishStatus = publishStatus;
    }

    public String getFbsIssueStart() {
        return fbsIssueStart;
    }

    public void setFbsIssueStart(String fbsIssueStart) {
        this.fbsIssueStart = fbsIssueStart;
    }

    public String getFbsIssueEnd() {
        return fbsIssueEnd;
    }

    public void setFbsIssueEnd(String fbsIssueEnd) {
        this.fbsIssueEnd = fbsIssueEnd;
    }

    public String getPublishTime() {
        return publishTime;
    }

    public void setPublishTime(String publishTime) {
        this.publishTime = publishTime;
    }

    public String getFbsIssueDate() {
        return fbsIssueDate;
    }

    public void setFbsIssueDate(String fbsIssueDate) {
        this.fbsIssueDate = fbsIssueDate;
    }
}
