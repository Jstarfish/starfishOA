package cls.pilottery.fbs.model;

public class Competition implements java.io.Serializable {
	
	private static final long serialVersionUID = 617503843345197114L;
	private String competitionCode;
	private String competitionName;
	public String getCompetitionCode() {
		return competitionCode;
	}
	public void setCompetitionCode(String competitionCode) {
		this.competitionCode = competitionCode;
	}
	public String getCompetitionName() {
		return competitionName;
	}
	public void setCompetitionName(String competitionName) {
		this.competitionName = competitionName;
	}
	
}
