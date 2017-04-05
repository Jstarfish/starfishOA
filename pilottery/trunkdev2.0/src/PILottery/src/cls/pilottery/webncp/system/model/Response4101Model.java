package cls.pilottery.webncp.system.model;

import java.util.List;

import cls.pilottery.webncp.common.model.BaseResponse;

public class Response4101Model extends BaseResponse{
	private static final long serialVersionUID = 8367095321965996237L;
	private String queryDate;
	private List<Response4101Record> recordList ;

	public String getQueryDate() {
		return queryDate;
	}

	public void setQueryDate(String queryDate) {
		this.queryDate = queryDate;
	}

	public List<Response4101Record> getRecordList() {
		return recordList;
	}

	public void setRecordList(List<Response4101Record> recordList) {
		this.recordList = recordList;
	}
	
}
