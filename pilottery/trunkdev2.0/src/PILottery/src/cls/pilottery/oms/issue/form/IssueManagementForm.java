package cls.pilottery.oms.issue.form;

import cls.pilottery.common.model.BaseEntity;

public class IssueManagementForm extends BaseEntity{
	private static final long serialVersionUID = 1698940232592065389L;

	private int gameCode;
	private String issueNumber;
	private int issueStatus;
	private String isPublish;
	private String openDate;
	private int publishNumber;
	
	private Long beginIssue;
	private Long issueNos;		//排期期数
	private String planStartHour;	//开始时间
	private String planCloseHour;	//关闭时间
	private int[] drawDays;		//开奖日
	private String issType;		//排期方式
	private Short stepTime; 	//间隔时间
	private Short issDays; 		//排期天数
	private String beginDay;	//开始日期
	
	//添加排期时间
	private String planStartHour2;
	private Short stepTime2;
	private Long issueNos2;
	private String planStartHour3;
	private Short stepTime3;
	private Long issueNos3;
	private String planStartHour4;
	private Short stepTime4;
	private Long issueNos4;
	
	public int getGameCode() {
		return gameCode;
	}
	public void setGameCode(int gameCode) {
		this.gameCode = gameCode;
	}
	public String getIssueNumber() {
		return issueNumber;
	}
	public void setIssueNumber(String issueNumber) {
		this.issueNumber = issueNumber;
	}
	public int getIssueStatus() {
		return issueStatus;
	}
	public void setIssueStatus(int issueStatus) {
		this.issueStatus = issueStatus;
	}
	public String getIsPublish() {
		return isPublish;
	}
	public void setIsPublish(String isPublish) {
		this.isPublish = isPublish;
	}
	public String getOpenDate() {
		return openDate;
	}
	public void setOpenDate(String openDate) {
		this.openDate = openDate;
	}
	public int getPublishNumber() {
		return publishNumber;
	}
	public void setPublishNumber(int publishNumber) {
		this.publishNumber = publishNumber;
	}
	public Long getBeginIssue() {
		return beginIssue;
	}
	public void setBeginIssue(Long beginIssue) {
		this.beginIssue = beginIssue;
	}
	public Long getIssueNos() {
		return issueNos;
	}
	public void setIssueNos(Long issueNos) {
		this.issueNos = issueNos;
	}
	public String getPlanStartHour() {
		return planStartHour;
	}
	public void setPlanStartHour(String planStartHour) {
		this.planStartHour = planStartHour;
	}
	public String getPlanCloseHour() {
		return planCloseHour;
	}
	public void setPlanCloseHour(String planCloseHour) {
		this.planCloseHour = planCloseHour;
	}
	public int[] getDrawDays() {
		return drawDays;
	}
	public void setDrawDays(int[] drawDays) {
		this.drawDays = drawDays;
	}
	public String getIssType() {
		return issType;
	}
	public void setIssType(String issType) {
		this.issType = issType;
	}
	public Short getStepTime() {
		return stepTime;
	}
	public void setStepTime(Short stepTime) {
		this.stepTime = stepTime;
	}
	public Short getIssDays() {
		return issDays;
	}
	public void setIssDays(Short issDays) {
		this.issDays = issDays;
	}
	public String getBeginDay() {
		return beginDay;
	}
	public void setBeginDay(String beginDay) {
		this.beginDay = beginDay;
	}
	public String getPlanStartHour2() {
		return planStartHour2;
	}
	public void setPlanStartHour2(String planStartHour2) {
		this.planStartHour2 = planStartHour2;
	}
	public Short getStepTime2() {
		return stepTime2;
	}
	public void setStepTime2(Short stepTime2) {
		this.stepTime2 = stepTime2;
	}
	public Long getIssueNos2() {
		return issueNos2;
	}
	public void setIssueNos2(Long issueNos2) {
		this.issueNos2 = issueNos2;
	}
	public String getPlanStartHour3() {
		return planStartHour3;
	}
	public void setPlanStartHour3(String planStartHour3) {
		this.planStartHour3 = planStartHour3;
	}
	public Short getStepTime3() {
		return stepTime3;
	}
	public void setStepTime3(Short stepTime3) {
		this.stepTime3 = stepTime3;
	}
	public Long getIssueNos3() {
		return issueNos3;
	}
	public void setIssueNos3(Long issueNos3) {
		this.issueNos3 = issueNos3;
	}
	public String getPlanStartHour4() {
		return planStartHour4;
	}
	public void setPlanStartHour4(String planStartHour4) {
		this.planStartHour4 = planStartHour4;
	}
	public Short getStepTime4() {
		return stepTime4;
	}
	public void setStepTime4(Short stepTime4) {
		this.stepTime4 = stepTime4;
	}
	public Long getIssueNos4() {
		return issueNos4;
	}
	public void setIssueNos4(Long issueNos4) {
		this.issueNos4 = issueNos4;
	}
}
