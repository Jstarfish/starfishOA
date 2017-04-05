package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseRequest;

public class Request3006Model extends BaseRequest {
	private static final long serialVersionUID = -1280930040284955437L;
	private String date;
	private String agencyCode;
	private int type;
	private int pageSize = 10;
	private int pageIndex = 1;
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	public int getPageIndex() {
		return pageIndex;
	}
	public void setPageIndex(int pageIndex) {
		this.pageIndex = pageIndex;
	}
}
