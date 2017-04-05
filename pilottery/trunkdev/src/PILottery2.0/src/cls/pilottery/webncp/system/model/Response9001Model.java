package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseResponse;

/**
 * 
 * @Description: 采集查询业务响应消息
 * @author: starfish
 * @date: 2016-2-24 下午5:54:17
 * 
 */
public class Response9001Model extends BaseResponse {
	private static final long serialVersionUID = -3720101217530783776L;

	private String reqSeq;
	private String reqLogType;
	private String reqPara1;
	private String rsync_ip;
	private Integer rsync_port;
	private String rsync_user;
	private String rsync_passwd;
	private String rsync_root_dir;

	public String getReqSeq() {
		return reqSeq;
	}

	public void setReqSeq(String reqSeq) {
		this.reqSeq = reqSeq;
	}

	public String getReqLogType() {
		return reqLogType;
	}

	public void setReqLogType(String reqLogType) {
		this.reqLogType = reqLogType;
	}

	public String getReqPara1() {
		return reqPara1;
	}

	public void setReqPara1(String reqPara1) {
		this.reqPara1 = reqPara1;
	}

	public String getRsync_ip() {
		return rsync_ip;
	}

	public void setRsync_ip(String rsync_ip) {
		this.rsync_ip = rsync_ip;
	}

	public Integer getRsync_port() {
		return rsync_port;
	}

	public void setRsync_port(Integer rsync_port) {
		this.rsync_port = rsync_port;
	}

	public String getRsync_user() {
		return rsync_user;
	}

	public void setRsync_user(String rsync_user) {
		this.rsync_user = rsync_user;
	}

	public String getRsync_passwd() {
		return rsync_passwd;
	}

	public void setRsync_passwd(String rsync_passwd) {
		this.rsync_passwd = rsync_passwd;
	}

	public String getRsync_root_dir() {
		return rsync_root_dir;
	}

	public void setRsync_root_dir(String rsync_root_dir) {
		this.rsync_root_dir = rsync_root_dir;
	}

}
