package cls.pilottery.oms.monitor.model.xmlEntity;

public class Location {

	private String agency_code;
	private String count;
	private String agency_name; // 销售站名称
	private String agency_addr; // 销售站地址
	private String total_win; // 该奖在销售站的总注数
	private String prize_level; // 奖级
	private String prize_name; // 奖级名称

	public String getAgency_code() {
		return agency_code;
	}

	public void setAgency_code(String agencyCode) {
		agency_code = agencyCode;
	}

	public String getCount() {
		return count;
	}

	public void setCount(String count) {
		this.count = count;
	}

	public String getAgency_name() {
		return agency_name;
	}

	public void setAgency_name(String agencyName) {
		agency_name = agencyName;
	}

	public String getAgency_addr() {
		return agency_addr;
	}

	public void setAgency_addr(String agencyAddr) {
		agency_addr = agencyAddr;
	}

	public String getTotal_win() {
		return total_win;
	}

	public void setTotal_win(String totalWin) {
		total_win = totalWin;
	}

	public void setPrize_name(String prize_name) {
		this.prize_name = prize_name;
	}

	public String getPrize_name() {
		return prize_name;
	}

	public void setPrize_level(String prize_level) {
		this.prize_level = prize_level;
	}

	public String getPrize_level() {
		return prize_level;
	}

}
