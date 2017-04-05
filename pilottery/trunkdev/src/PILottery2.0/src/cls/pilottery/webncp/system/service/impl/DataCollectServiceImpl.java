package cls.pilottery.webncp.system.service.impl;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.common.utils.DateUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.webncp.common.annotation.WebncpMethod;
import cls.pilottery.webncp.common.annotation.WebncpService;
import cls.pilottery.webncp.common.constants.WebncpErrorMessage;
import cls.pilottery.webncp.common.model.BaseResponse;
import cls.pilottery.webncp.system.dao.oms.DataCollectDao;
import cls.pilottery.webncp.system.model.Request9001Model;
import cls.pilottery.webncp.system.model.Request9002Model;
import cls.pilottery.webncp.system.model.Response5001Model;
import cls.pilottery.webncp.system.model.Response9001Model;
import cls.pilottery.webncp.system.model.Response9002Model;
import cls.pilottery.webncp.system.service.DataCollectService;

import com.alibaba.fastjson.JSONObject;

/**
 * 数据采集相关接口
 * 9001:采集查询,查询是否需要有提供日志的记录
 * 9002:完成通知,更新对应的记录为已完成
 *
 */

@WebncpService
public class DataCollectServiceImpl implements DataCollectService {

public static Logger log = Logger.getLogger(DataReportServiceImpl.class);
	
	@Autowired
	private DataCollectDao dataCollectDao;
	
	@Override
	@WebncpMethod(code = "9001")
	public BaseResponse getLogByTermCode(String reqJson) throws Exception {
		Request9001Model req = JSONObject.parseObject(reqJson, Request9001Model.class);
		BaseResponse res = new BaseResponse();
		String termCode = req.getTerminal_code();
		
		if (StringUtils.isEmpty(termCode) || !DateUtil.mathcFomat(termCode, "[0-9]")){
			res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND, "wrong fomat param!");
			log.error("wrong fomat param");
			return res;
		}
		
		Response9001Model resp=this.dataCollectDao.getLogByTermCode(req);
		if(resp != null){
			res.setCMD(req.getCMD());
	     	resp.setRsync_ip(PropertiesUtil.readValue("upload_ftp_ip"));
			resp.setRsync_port(Integer.parseInt(PropertiesUtil.readValue("upload_ftp_port")));
			resp.setRsync_user(PropertiesUtil.readValue("upload_ftp_username"));
			resp.setRsync_passwd(PropertiesUtil.readValue("upload_ftp_password"));
			resp.setRsync_root_dir(PropertiesUtil.readValue("upload_ftp_path"));
			log.info("采集查询9001成功");
		}else{
			res = new BaseResponse(WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			return res;
		}
		
		return resp;

}

	@Override
	@WebncpMethod(code = "9002")
	public BaseResponse updateLogStatus(String reqJson) throws Exception {
		Request9002Model req = JSONObject.parseObject(reqJson, Request9002Model.class);
		BaseResponse res = new BaseResponse();
		String reqSeq = req.getReqSeq();
		String fileName = req.getFileName();
		if (StringUtils.isEmpty(reqSeq) || !DateUtil.mathcFomat(reqSeq, "[0-9]")){
			res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND, "wrong fomat param!");
			log.error("wrong fomat param!");
			return res;
    	}
    	if (StringUtils.isEmpty(fileName.trim())){
    		res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND, "file name is null");
			log.error("file name is null");
			return res;
    	}
    	int result = dataCollectDao.updateLogStatus(req);
    	if (result > 0) {
			return res;
		} else {
			res = new BaseResponse(WebncpErrorMessage.ERR_RECORD_NOTEXSIT,"record not exist!");
			log.error("record not exist!");
		}
		return res;
 }
}
