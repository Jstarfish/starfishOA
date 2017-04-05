package cls.pilottery.oms.common.msg;


public class UpdateAgencyStatusReq6005 implements java.io.Serializable{

	private static final long serialVersionUID = -7534353285020982116L;
	private String agencyCode;
	/*private int enable;*/
	private int status;
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
/*	public int getEnable() {
		return enable;
	}
	public void setEnable(int enable) {
		this.enable = enable;
	}*/
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	@Override
	public String toString() {
		return "UpdateAgencyStatusReq6005 [agencyCode=" + agencyCode + ", status=" + status + "]";
	}
	
	

}
