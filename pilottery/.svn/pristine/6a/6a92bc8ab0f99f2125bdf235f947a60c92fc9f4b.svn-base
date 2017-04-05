package cls.pilottery.webncp.system.service;

import cls.pilottery.webncp.common.model.BaseResponse;
import cls.pilottery.webncp.system.model.Request5002Model;
import cls.pilottery.webncp.system.model.Request5003Model;
import cls.pilottery.webncp.system.model.Request5004Model;
import cls.pilottery.webncp.system.vo.Request5003Parmt;
import cls.pilottery.webncp.system.vo.Request5004Parmt;
import cls.pilottery.webncp.system.vo.RequestParamt;
import cls.pilottery.webncp.system.vo.Response5002Vo;
import cls.pilottery.webncp.system.vo.Response5003Vo;
import cls.pilottery.webncp.system.vo.Response5004Vo;

/**
 * 
 * @author huangchy
 * 终端版本相关接口，包括5001，5002，5003，5004
 *
 */
public interface TerminalVersionService {
	public BaseResponse queryDeviceCode(String reqJson) throws Exception;
	public BaseResponse verifyVersion(String reqJson)throws Exception;
	public Response5002Vo getLastVersion(Request5002Model request);
	public Response5002Vo getVersionInfo(Response5002Vo vo);
	public Response5002Vo getProcessInfo(RequestParamt paramt);
	public void updateProcess(Response5002Vo vo);
	public void updateProcessTime(Response5002Vo vo);
	public BaseResponse updateDownload(String reqJson)throws Exception;
	public Response5003Vo  getProcessTime(Request5003Model request);
	public Integer updateDownProcessByNO(Request5003Parmt request);
	public void updateSoftware(Request5003Model request);
	public BaseResponse overDownload(String reqJson) throws Exception;
	public Integer updateOverupgradeproc(Request5004Parmt request);
	public Response5004Vo getUpgradeproc(Request5004Model request);
	public void updateOverSoftware(Request5004Parmt request);
}
