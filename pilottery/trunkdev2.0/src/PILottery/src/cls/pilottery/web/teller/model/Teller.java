package cls.pilottery.web.teller.model;

import org.apache.log4j.Logger;

import cls.pilottery.common.entity.AbstractEntity;
import cls.pilottery.oms.business.model.AreaParent;

public class Teller extends AbstractEntity {

	private static final long serialVersionUID = 4787847772180689570L;

	static Logger logger = Logger.getLogger(Teller.class);

	private Long tellerCode; // 销售员编码
	private String tellerCodeToChar; // 格式化后的销售员编码
	private String agencyCodeToChar; // 格式化后的销售站编码
	private AreaParent agencyParent;
	private String tellerName;
	private TellerType tellerType; // 销售员类型
	private TellerStatus tellerStatus; // 销售员状态
	private String tellerPassword; // 销售员密码
	private Long latestTerminalId;
	private String latestLogOnTime; // "yyyy-MM-dd hh:mm:ss"
	private String latestLogOffTime; // "yyyy-MM-dd hh:mm:ss"
	private String agencyCode;
	private String agencyName;
	private int isLogin;

	// add
	private int newTellerType;
	private int newTellerStatus;

	public int getNewTellerType() {
		return newTellerType;
	}

	public void setNewTellerType(int newTellerType) {
		this.newTellerType = newTellerType;
	}

	public int getNewTellerStatus() {
		return newTellerStatus;
	}

	public void setNewTellerStatus(int newTellerStatus) {
		this.newTellerStatus = newTellerStatus;
	}

	public AreaParent getAgencyParent() {
		return agencyParent;
	}

	public void setAgencyParent(AreaParent agencyParent) {
		this.agencyParent = agencyParent;
	}

	public Long getTellerCode() {
		return tellerCode;
	}

	public void setTellerCode(Long tellerCode) {
		this.tellerCode = tellerCode;
	}

	public String getTellerName() {
		return tellerName;
	}

	public void setTellerName(String tellerName) {
		this.tellerName = tellerName;
	}

	public TellerType getTellerType() {
		return tellerType;
	}

	public void setTellerType(TellerType tellerType) {
		this.tellerType = tellerType;
	}

	public TellerStatus getTellerStatus() {
		return tellerStatus;
	}

	public void setTellerStatus(TellerStatus tellerStatus) {
		this.tellerStatus = tellerStatus;
	}

	public String getTellerPassword() {
		return tellerPassword;
	}

	public void setTellerPassword(String tellerPassword) {
		this.tellerPassword = tellerPassword;
	}

	public Long getLatestTerminalId() {
		return latestTerminalId;
	}

	public void setLatestTerminalId(Long latestTerminalId) {
		this.latestTerminalId = latestTerminalId;
	}

	public String getLatestLogOnTime() {
		return latestLogOnTime;
	}

	public void setLatestLogOnTime(String latestLogOnTime) {
		this.latestLogOnTime = latestLogOnTime;
	}

	public String getLatestLogOffTime() {
		return latestLogOffTime;
	}

	public void setLatestLogOffTime(String latestLogOffTime) {
		this.latestLogOffTime = latestLogOffTime;
	}

	public String getTellerCodeToChar() {
		return tellerCodeToChar;
	}

	public void setTellerCodeToChar(String tellerCodeToChar) {
		this.tellerCodeToChar = tellerCodeToChar;
	}

	public String getAgencyCodeToChar() {
		return agencyCodeToChar;
	}

	public void setAgencyCodeToChar(String agencyCodeToChar) {
		this.agencyCodeToChar = agencyCodeToChar;
	}

	public String getAgencyCode() {
		return agencyCode;
	}

	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}

	public String getAgencyName() {
		return agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public int getIsLogin() {
		return isLogin;
	}

	public void setIsLogin(int isLogin) {
		this.isLogin = isLogin;
	}

	@Override
	public String toString() {
		return "Teller [agencyCode=" + agencyCode + ", agencyCodeToChar=" + agencyCodeToChar + ", agencyParent="
				+ agencyParent + ", latestLogOffTime=" + latestLogOffTime + ", latestLogOnTime=" + latestLogOnTime
				+ ", latestTerminalId=" + latestTerminalId + ", tellerCode=" + tellerCode + ", tellerCodeToChar="
				+ tellerCodeToChar + ", tellerName=" + tellerName + ", tellerPassword=" + tellerPassword
				+ ", tellerStatus=" + tellerStatus + ", tellerType=" + tellerType + "]";
	}
}
