package cls.pilottery.oms.common.msg;


public class AddTerminalReq7001 implements java.io.Serializable{

	private static final long serialVersionUID = 2884409520321824631L;
	private String termCode;
	private String agencyCode;
	private String termMac; 
	private String uniqueCode;
	
	private int machineModel;
	private int isTrain ;
	private int status;
	public String getTermCode() {
		return termCode;
	}
	public void setTermCode(String termCode) {
		this.termCode = termCode;
	}
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
	public String getTermMac() {
		return termMac;
	}
	public void setTermMac(String termMac) {
		this.termMac = termMac;
	}
	public String getUniqueCode() {
		return uniqueCode;
	}
	public void setUniqueCode(String uniqueCode) {
		this.uniqueCode = uniqueCode;
	}
	
	public int getMachineModel() {
		return machineModel;
	}
	public void setMachineModel(int machineModel) {
		this.machineModel = machineModel;
	}
	public int getIsTrain() {
		return isTrain;
	}
	public void setIsTrain(int isTrain) {
		this.isTrain = isTrain;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	@Override
	public String toString() {
		return "AddTerminalReq7001 [termCode=" + termCode + ", agencyCode=" + agencyCode + ", termMac=" + termMac
				+ ", uniqueCode=" + uniqueCode + ", machineModel=" + machineModel + ", isTrain=" + isTrain + ", status="
				+ status + "]";
	}
	

}
