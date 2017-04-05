package cls.pilottery.webncp.system.model;

import java.util.List;

import cls.pilottery.webncp.common.model.BaseResponse;

public class Response4005Model extends BaseResponse {

	private static final long serialVersionUID = -8491452083139750588L;
	private Integer pageCount;    //页面总数
	private Integer totalCount;   //总记录数
	private Integer recordCount;  //结果记录数
	private List<Response4005Record> recordList;
	
	public Integer getPageCount() {
		return pageCount;
	}
	public void setPageCount(Integer pageCount) {
		this.pageCount = pageCount;
	}
	
	public Integer getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(Integer totalCount) {
		this.totalCount = totalCount;
	}
	
	public Integer getRecordCount() {
		return recordCount;
	}
	public void setRecordCount(Integer recordCount) {
		this.recordCount = recordCount;
	}
	public List<Response4005Record> getRecordList() {
		return recordList;
	}
	public void setRecordList(List<Response4005Record> recordList) {
		this.recordList = recordList;
	}
	
	
}
