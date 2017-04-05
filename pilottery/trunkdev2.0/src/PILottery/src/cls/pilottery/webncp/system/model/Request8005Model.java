package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseRequest;

public class Request8005Model extends BaseRequest {
	private static final long serialVersionUID = -1914388140715891027L;
	private int Collectorid;
	private String LoginPwd;
	private String terminalCode;
	private int CheckBalance;
	private int CheckTerminal;
	public int getCollectorid() {
		return Collectorid;
	}
	public void setCollectorid(int collectorid) {
		Collectorid = collectorid;
	}
	public String getLoginPwd() {
		return LoginPwd;
	}
	public void setLoginPwd(String loginPwd) {
		LoginPwd = loginPwd;
	}
	public String getTerminalCode() {
		return terminalCode;
	}
	public void setTerminalCode(String terminalCode) {
		this.terminalCode = terminalCode;
	}
	public int getCheckBalance() {
		return CheckBalance;
	}
	public void setCheckBalance(int checkBalance) {
		CheckBalance = checkBalance;
	}
	public int getCheckTerminal() {
		return CheckTerminal;
	}
	public void setCheckTerminal(int checkTerminal) {
		CheckTerminal = checkTerminal;
	}

}
