package cls.pilottery.web.system.model;

import java.io.Serializable;

public class BatchRolePrivilege implements Serializable {
	private static final long serialVersionUID = -2581991300933345988L;

	private String roleid;

	private String pids;

	private int errorCode;

	private String errorMessage;



	

	public String getRoleid() {
		return roleid;
	}

	public void setRoleid(String roleid) {
		this.roleid = roleid;
	}

	public String getPids() {
		return pids;
	}

	public void setPids(String pids) {
		this.pids = pids;
	}

	public int getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(int errorCode) {
		this.errorCode = errorCode;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

}
