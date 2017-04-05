package cls.pilottery.webncp.system.dao;

import java.util.Map;

import cls.pilottery.webncp.system.model.Request5001Model;
import cls.pilottery.webncp.system.model.Request5002Model;
import cls.pilottery.webncp.system.model.Request5003Model;
import cls.pilottery.webncp.system.model.Request5004Model;
import cls.pilottery.webncp.system.model.Response5001Model;
import cls.pilottery.webncp.system.vo.Request5003Parmt;
import cls.pilottery.webncp.system.vo.Request5004Parmt;
import cls.pilottery.webncp.system.vo.RequestParamt;
import cls.pilottery.webncp.system.vo.Response5002Vo;
import cls.pilottery.webncp.system.vo.Response5003Vo;
import cls.pilottery.webncp.system.vo.Response5004Vo;

public interface VersionDao {
	public Response5001Model queryDeviceCode(Request5001Model request);

	public void updateVersion(Request5002Model request);

	public Response5002Vo getLastVersion(Request5002Model request);

	public Response5002Vo getVersionInfo(Response5002Vo vo);

	public Response5002Vo getProcessInfo(RequestParamt paramt);

	public void updateProcess(Response5002Vo vo);

	public void updateProcessTime(Response5002Vo vo);

	public Response5003Vo getProcessTime(Request5003Model request);

	public void updateDownProcessByNO(Request5003Parmt request);

	public void updateSoftware(Request5003Model request);

	public void updateOverupgradeproc(Request5004Parmt request);

	public Response5004Vo getUpgradeproc(Request5004Model request);

	public void updateOverSoftware(Request5004Parmt request);

	public String getUserPwdById(int collectorid);

	public long getCurrentBalance(String terminalCode);

	public void saveCheckInfo(Map<String, Object> map);
}
