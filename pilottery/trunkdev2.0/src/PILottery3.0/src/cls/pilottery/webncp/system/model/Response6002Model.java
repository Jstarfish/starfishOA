package cls.pilottery.webncp.system.model;

import java.util.List;

import cls.pilottery.webncp.common.model.BaseResponse;

public class Response6002Model extends BaseResponse{
	private static final long serialVersionUID = 7706101863823578L;
	private List<Response6002Record> recordList;

	public List<Response6002Record> getRecordList() {
		return recordList;
	}

	public void setRecordList(List<Response6002Record> recordList) {
		this.recordList = recordList;
	}

}
