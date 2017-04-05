package cls.pilottery.webncp.system.model;

import java.util.List;

import cls.pilottery.webncp.common.model.BaseResponse;

public class Response3002Model extends BaseResponse {
	private static final long serialVersionUID = -8303767724840292384L;

	private List<Response3002Record> recordList ;
	
	private String perdIssue;//期次范围

	
	public String getPerdIssue() {
	
		return perdIssue;
	}

	
	public void setPerdIssue(String perdIssue) {
	
		this.perdIssue = perdIssue;
	}

	public List<Response3002Record> getRecordList() {
		return recordList;
	}

	public void setRecordList(List<Response3002Record> recordList) {
		this.recordList = recordList;
	}
	
}
