package cls.taishan.system.model;

import java.io.Serializable;

public class UserLoginInfo implements Serializable {
	private static final long serialVersionUID = -1424773736744349251L;
	private String loginName;
	private int isLogin = 0;		//0 未登录，1已登录
	private long lastLoginTime;	//最近一次成功登录时间System.currentTimeMillis()
	private int pwdErrorTimes = 0;
	private String loginDevice;		//1：pc  2：pos终端
	private String token;
	public String getLoginName() {
		return loginName;
	}
	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}
	public int getIsLogin() {
		return isLogin;
	}
	public void setIsLogin(int isLogin) {
		this.isLogin = isLogin;
	}
	public long getLastLoginTime() {
		return lastLoginTime;
	}
	public void setLastLoginTime(long lastLoginTime) {
		this.lastLoginTime = lastLoginTime;
	}
	public int getPwdErrorTimes() {
		return pwdErrorTimes;
	}
	public void setPwdErrorTimes(int pwdErrorTimes) {
		this.pwdErrorTimes = pwdErrorTimes;
	}
	public String getLoginDevice() {
		return loginDevice;
	}
	public void setLoginDevice(String loginDevice) {
		this.loginDevice = loginDevice;
	}
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}
}
