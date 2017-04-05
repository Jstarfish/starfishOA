package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseRequest;

/**
 * 
 * @Description: 采集查询业务请求消息
 * @author: starfish
 * @date: 2016-2-24 下午5:47:14
 * 
 */
public class Request9001Model extends BaseRequest {

	private static final long serialVersionUID = -1997246039769453166L;
	private String terminal_code;

	public String getTerminal_code() {
		return terminal_code;
	}

	public void setTerminal_code(String terminal_code) {
		this.terminal_code = terminal_code;
	}

}
