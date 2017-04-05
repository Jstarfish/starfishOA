package cls.pilottery.webncp.system.vo;

import java.io.Serializable;

public class RequestParamt implements Serializable {

	private static final long serialVersionUID = 8234774060162446904L;
	private String schedule_id;
	private String terminal_version;
	private String terminal_code;

	public String getSchedule_id() {
		return schedule_id;
	}

	public void setSchedule_id(String schedule_id) {
		this.schedule_id = schedule_id;
	}

	public String getTerminal_version() {
		return terminal_version;
	}

	public void setTerminal_version(String terminal_version) {
		this.terminal_version = terminal_version;
	}

	public String getTerminal_code() {
		return terminal_code;
	}

	public void setTerminal_code(String terminal_code) {
		this.terminal_code = terminal_code;
	}

}
