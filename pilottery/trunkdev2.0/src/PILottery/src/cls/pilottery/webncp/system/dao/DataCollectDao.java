package cls.pilottery.webncp.system.dao;

import java.util.List;
import java.util.Map;

import cls.pilottery.webncp.system.model.Request8001Model;
import cls.pilottery.webncp.system.model.Request8004Model;
import cls.pilottery.webncp.system.model.Request8006Model;
import cls.pilottery.webncp.system.model.Request8007Model;
import cls.pilottery.webncp.system.model.Request9001Model;
import cls.pilottery.webncp.system.model.Request9002Model;
import cls.pilottery.webncp.system.model.Response8004Record;
import cls.pilottery.webncp.system.model.Response9001Model;

public interface DataCollectDao {

	public Response9001Model getLogByTermCode(Request9001Model request);
	
	public int updateLogStatus(Request9002Model request);

	public void outletTopUp(Request8001Model req);

	public int validateCollector(Request8004Model req);

	public long getAllowAmount(Request8004Model req);

	public int getTopupRecordCount(Request8004Model req);

	public List<Response8004Record> getTopupRecord(Request8004Model req);

	public int validateMMLoginPwd(Map<String,Object> map);

	public void outletWithdrawApp(Request8006Model req);

	public String getParamValueById(int i);

	public void outletWithdrawApprove(Request8006Model req);

	public int validateOutletOldPwd(Request8007Model req);

	public void updateOutletTransPwd(Request8007Model req);

}
