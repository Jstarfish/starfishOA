package cls.pilottery.webncp.system.model;

import java.util.List;

import cls.pilottery.webncp.common.model.BaseResponse;

public class Response4102Model extends BaseResponse {
	private static final long serialVersionUID = 6205126396021322512L;
	private List<Response4102Record> recordList;

	public List<Response4102Record> getRecordList() {
		return recordList;
	}

	public void setRecordList(List<Response4102Record> recordList) {
		this.recordList = recordList;
	}
	
}
