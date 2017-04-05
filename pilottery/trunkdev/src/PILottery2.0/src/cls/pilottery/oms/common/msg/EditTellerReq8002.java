package cls.pilottery.oms.common.msg;


public class EditTellerReq8002 implements java.io.Serializable {    
	private static final long serialVersionUID = 1371365813415072096L;
    private Long tellerCode;

    private int tellerType;
    /*private String tellerName;*/
    private String agencyCode;
    private int status;
    private long password;
  
	public Long getTellerCode() {
		return tellerCode;
	}
	public void setTellerCode(Long tellerCode) {
		this.tellerCode = tellerCode;
	}

	public int getTellerType() {
		return tellerType;
	}
	public void setTellerType(int tellerType) {
		this.tellerType = tellerType;
	}
	/*public String getTellerName() {
		return tellerName;
	}
	public void setTellerName(String tellerName) {
		this.tellerName = tellerName;
	}*/
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public long getPassword() {
		return password;
	}
	public void setPassword(long password) {
		this.password = password;
	}
	
	
}
