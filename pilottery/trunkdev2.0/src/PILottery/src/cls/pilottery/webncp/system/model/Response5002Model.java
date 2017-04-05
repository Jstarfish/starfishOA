package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseResponse;

public class Response5002Model extends BaseResponse {

	private static final long serialVersionUID = -4706362459974896033L;
	private int schedule_id;
	private String version_no;
	private int update_flag;
	private String rsync_ip;
	private int rsync_port;
    private String rsync_user;
    private String rsync_passwd;
    private String rsync_root_dir;
	public int getSchedule_id() {
		return schedule_id;
	}
	public void setSchedule_id(int schedule_id) {
		this.schedule_id = schedule_id;
	}
	public String getVersion_no() {
		return version_no;
	}
	public void setVersion_no(String version_no) {
		this.version_no = version_no;
	}
	public int getUpdate_flag() {
		return update_flag;
	}
	public void setUpdate_flag(int update_flag) {
		this.update_flag = update_flag;
	}
	public String getRsync_ip() {
		return rsync_ip;
	}
	public void setRsync_ip(String rsync_ip) {
		this.rsync_ip = rsync_ip;
	}
	public int getRsync_port() {
		return rsync_port;
	}
	public void setRsync_port(int rsync_port) {
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
	@Override
	public String toString() {
		return "Response5002Model [schedule_id=" + schedule_id + ", version_no=" + version_no + ", update_flag="
				+ update_flag + ", rsync_ip=" + rsync_ip + ", rsync_port=" + rsync_port + ", rsync_user=" + rsync_user
				+ ", rsync_passwd=" + rsync_passwd + ", rsync_root_dir=" + rsync_root_dir + "]";
	}
    
}
