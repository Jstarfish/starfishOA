package cls.pilottery.webncp.system.vo;

import java.io.Serializable;

public class Request5003Parmt implements Serializable {
	
	 
	    
	private static final long serialVersionUID = -2976442407269600778L;
	private String version_no;
    private Long terminal_code;
    private int schedule_id;
    private String module_name;
    private int module_progress;
    private String startDate;
	public String getVersion_no() {
		return version_no;
	}
	public void setVersion_no(String version_no) {
		this.version_no = version_no;
	}
	public Long getTerminal_code() {
		return terminal_code;
	}
	public void setTerminal_code(Long terminal_code) {
		this.terminal_code = terminal_code;
	}
	public int getSchedule_id() {
		return schedule_id;
	}
	public void setSchedule_id(int schedule_id) {
		this.schedule_id = schedule_id;
	}
	public String getModule_name() {
		return module_name;
	}
	public void setModule_name(String module_name) {
		this.module_name = module_name;
	}
	public int getModule_progress() {
		return module_progress;
	}
	public void setModule_progress(int module_progress) {
		this.module_progress = module_progress;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
    
}
