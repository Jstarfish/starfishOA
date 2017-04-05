package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class ModifyPwdRequest implements Serializable {
	private static final long serialVersionUID = 5482960255499176341L;
	private String oldPassword;
	private String newPassword;
	public String getOldPassword() {
		return oldPassword;
	}
	public void setOldPassword(String oldPassword) {
		this.oldPassword = oldPassword;
	}
	public String getNewPassword() {
		return newPassword;
	}
	public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
	}
}
