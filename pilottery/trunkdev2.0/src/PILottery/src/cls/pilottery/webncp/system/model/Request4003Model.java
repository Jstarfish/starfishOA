package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseRequest;

public class Request4003Model extends BaseRequest {

	private static final long serialVersionUID = 5658215402716604167L;
	private Integer pageSize;   //页面大小
	private Integer pageIndex;  //页面序号
	private String  areaCode;   //区域编号/销售站编号
	
	public Integer getPageSize() {
		return pageSize;
	}
	public void setPageSize(Integer pageSize) {
		this.pageSize = pageSize;
	}
	
	public Integer getPageIndex() {
		return pageIndex;
	}
	public void setPageIndex(Integer pageIndex) {
		this.pageIndex = pageIndex;
	}
	
	public String getAreaCode() {
		return areaCode;
	}
	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}
	
	@Override
	public String toString() {
		return "Request4003Model [pageSize=" + pageSize.toString() + ", pageIndex=" + pageIndex.toString() + ", areaCode=" + areaCode + "]";
	}
}
