package cls.pilottery.packinfo;

/*
 * 方案信息实体
 * 主要用于初始化
 */
public class PlanInfo {

	private String planCode;//方案编码
	private String planName;//方案名称
	private long faceValue;//方案面值
	private String printerCode;//印制商
	
	/*
	 * 初始化函数
	 */
	public PlanInfo(String planCode,String planName,long faceValue,String pCode)
	{
		this.planCode = planCode;
		this.planName = planName;
		this.faceValue = faceValue;
		this.printerCode = pCode;
	}
	
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
