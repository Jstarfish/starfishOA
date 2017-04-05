package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseResponse;

public class Response5001Model  extends BaseResponse{

	private static final long serialVersionUID = -3418101817862431461L;
    private Long terminal_code;
	public Long getTerminal_code() {
		return terminal_code;
	}
	public void setTerminal_code(Long terminal_code) {
		this.terminal_code = terminal_code;
	}
	@Override
	public String toString() {
		return "Response5001Model [terminal_code=" + terminal_code + "]";
	}

   
}
