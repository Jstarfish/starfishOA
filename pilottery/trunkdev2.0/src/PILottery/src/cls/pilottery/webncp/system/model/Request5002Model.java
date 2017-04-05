package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseRequest;

public class Request5002Model extends BaseRequest{
	private static final long serialVersionUID = -4874841881048418520L;
	private String terminal_version;
    private Long terminal_code;
    private int terminal_model;
	public String getTerminal_version() {
		return terminal_version;
	}
	public void setTerminal_version(String terminal_version) {
		this.terminal_version = terminal_version;
	}
	public Long getTerminal_code() {
		return terminal_code;
	}
	public void setTerminal_code(Long terminal_code) {
		this.terminal_code = terminal_code;
	}
	public int getTerminal_model() {
		return terminal_model;
	}
	public void setTerminal_model(int terminalModel) {
		terminal_model = terminalModel;
	}
	
}
