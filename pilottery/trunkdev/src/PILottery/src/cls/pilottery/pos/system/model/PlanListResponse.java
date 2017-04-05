package cls.pilottery.pos.system.model;

public class PlanListResponse{
	private static final long serialVersionUID = -7456498433187997635L;
	private String planCode;
	private String planName;
	private long faceValue;
	private String printerCode;
	public String getPlanCode() {
		return planCode;
	}
	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}
	public String getPlanName() {
		return planName;
	}
	public void setPlanName(String planName) {
		this.planName = planName;
	}
	public long getFaceValue() {
		return faceValue;
	}
	public void setFaceValue(long faceValue) {
		this.faceValue = faceValue;
	}
	public String getPrinterCode() {
		return printerCode;
	}
	public void setPrinterCode(String printerCode) {
		this.printerCode = printerCode;
	}
	
}
