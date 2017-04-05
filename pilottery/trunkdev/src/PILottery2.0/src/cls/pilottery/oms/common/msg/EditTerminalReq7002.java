package cls.pilottery.oms.common.msg;

import cls.pilottery.oms.common.entity.BaseMessageReq;

public class EditTerminalReq7002 extends BaseMessageReq {
 
	private static final long serialVersionUID = -5745625548415199079L;
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
	

	
	

}
