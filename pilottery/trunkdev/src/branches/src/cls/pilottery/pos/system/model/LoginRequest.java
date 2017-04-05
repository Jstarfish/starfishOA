package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class LoginRequest implements Serializable {
	private static final long serialVersionUID = 5793673894427319219L;
	private String username;
	private String password;
	private String type;
	private String deviceType;
	private String deviceSign;
	private String version;
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getDeviceType() {
		return deviceType;
	}
	public void setDeviceType(String deviceType) {
		this.deviceType = deviceType;
	}
	public String getDeviceSign() {
		return deviceSign;
	}
	public void setDeviceSign(String deviceSign) {
		this.deviceSign = deviceSign;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	@Override
	public String toString() {
		return "LoginRequest [deviceSign=" + deviceSign + ", deviceType="
				+ deviceType + ", password=" + password + ", type=" + type
				+ ", username=" + username + ", version=" + version + "]";
	}
}
