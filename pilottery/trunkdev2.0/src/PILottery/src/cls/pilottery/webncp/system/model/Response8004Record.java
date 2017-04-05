package cls.pilottery.webncp.system.model;

public class Response8004Record implements java.io.Serializable{
	private static final long serialVersionUID = 2361323254515416317L;
	private String agencyCode;
	private Long applyAmount;
	private String applyTime;
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
	public Long getApplyAmount() {
		return applyAmount;
	}
	public void setApplyAmount(Long applyAmount) {
		this.applyAmount = applyAmount;
	}
	public String getApplyTime() {
		return applyTime;
	}
	public void setApplyTime(String applyTime) {
		this.applyTime = applyTime;
	}
}
