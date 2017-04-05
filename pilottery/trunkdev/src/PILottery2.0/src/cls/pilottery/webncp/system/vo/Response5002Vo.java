package cls.pilottery.webncp.system.vo;

import java.io.Serializable;

public class Response5002Vo implements Serializable {

	private static final long serialVersionUID = 6063526020492089807L;
	private String schedule_id;
	private String schedule_name;
	private String pkgvers;
	private String updateTime;
	private String schedule_exec_date;
    private String terminal_code;
    private String is_comp_dl;
    private String startDate;
    private String endDate;
    private String downName;
	public String getSchedule_id() {
		return schedule_id;
	}

	public void setSchedule_id(String schedule_id) {
		this.schedule_id = schedule_id;
	}

	public String getSchedule_name() {
		return schedule_name;
	}

	public void setSchedule_name(String schedule_name) {
		this.schedule_name = schedule_name;
	}

	public String getPkgvers() {
		return pkgvers;
	}

	public void setPkgvers(String pkgvers) {
		this.pkgvers = pkgvers;
	}

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

	public String getSchedule_exec_date() {
		return schedule_exec_date;
	}

	public void setSchedule_exec_date(String schedule_exec_date) {
		this.schedule_exec_date = schedule_exec_date;
	}

	public String getTerminal_code() {
		return terminal_code;
	}

	public void setTerminal_code(String terminal_code) {
		this.terminal_code = terminal_code;
	}

	public String getIs_comp_dl() {
		return is_comp_dl;
	}

	public void setIs_comp_dl(String is_comp_dl) {
		this.is_comp_dl = is_comp_dl;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getDownName() {
		return downName;
	}

	public void setDownName(String downName) {
		this.downName = downName;
	}

}
