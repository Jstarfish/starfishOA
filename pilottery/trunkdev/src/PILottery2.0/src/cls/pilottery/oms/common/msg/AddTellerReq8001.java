package cls.pilottery.oms.common.msg;


public class AddTellerReq8001 implements java.io.Serializable {

	private static final long serialVersionUID = 4860995373419387001L;
	private long  tellerCode;
	private String agencyCode;
	/*private String tellerName;*/
	private int tellerType;

	private long  password;   
	private int status;
	public long getTellerCode() {
		return tellerCode;
	}
	public void setTellerCode(long tellerCode) {
		this.tellerCode = tellerCode;
	}
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
/*	public String getTellerName() {
		return tellerName;
	}
	public void setTellerName(String tellerName) {
		this.tellerName = tellerName;
	}*/
	public int getTellerType() {
		return tellerType;
	}
	public void setTellerType(int tellerType) {
		this.tellerType = tellerType;
	}

	public long getPassword() {
		return password;
	}
	public void setPassword(long password) {
		this.password = password;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	@Override
	public String toString() {
		return "AddTellerReq8001 [tellerCode=" + tellerCode + ", agencyCode=" + agencyCode + ", tellerType=" + tellerType + ", password=" + password + ", status=" + status + "]";
	}

	
	 
}
