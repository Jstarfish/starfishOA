package cls.pilottery.webncp.system.model;

import java.util.List;

import cls.pilottery.webncp.common.model.BaseResponse;

public class Response3001Model extends BaseResponse {
	private static final long serialVersionUID = -8303767724840292384L;

	private List<Response3001Record> recordList ;
	
	private String dateScope;

	public String getDateScope() {
		return dateScope;
	}

	public void setDateScope(String dateScope) {
		this.dateScope = dateScope;
	}

	public List<Response3001Record> getRecordList() {
		return recordList;
	}

	public void setRecordList(List<Response3001Record> recordList) {
		this.recordList = recordList;
	}
	
}
