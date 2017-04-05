package cls.pilottery.webncp.system.service.impl;

import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.webncp.common.annotation.WebncpMethod;
import cls.pilottery.webncp.common.annotation.WebncpService;
import cls.pilottery.webncp.common.model.BaseResponse;
import cls.pilottery.webncp.system.dao.TdsProcessDao;
import cls.pilottery.webncp.system.model.Response2002Model;
import cls.pilottery.webncp.system.model.Response30d4Model;
import cls.pilottery.webncp.system.service.TdsProcessService;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;

@WebncpService
public class TdsProcessServiceImpl implements TdsProcessService {
	public static Logger log = Logger.getLogger(TdsProcessServiceImpl.class); 
	
	@Autowired
	private TdsProcessDao tdsProcessDao;

	@SuppressWarnings("unchecked")
	@Override
	@WebncpMethod(code = "2001")
	public BaseResponse getDrawAnnouncement(String reqJson) throws Exception {
		Map req = JSONObject.parseObject(reqJson, Map.class);
		Integer issueNumber = (Integer)req.get("issue");
		Integer gameCode = (Integer)req.get("game");
		
		Response30d4Model param = new Response30d4Model();
		if(gameCode == null || gameCode < 0 || issueNumber== null || issueNumber < 0){
			log.debug("TDS查询开奖公告参数错误");
			BaseResponse response = new BaseResponse(2);	//参数错误
			response.setCMD(0x2001);
			String json = JSON.toJSONString(response,SerializerFeature.WriteMapNullValue);
			param.setResultJson(json);
			return param;
		}
		param.setGameCode(gameCode);
		param.setIssueNumber(issueNumber);
		
		log.debug("执行存储过程p_set_json_issue_draw_notice");
		tdsProcessDao.getDrawAnnouncement(param);
		log.debug("p_set_json_issue_draw_notice执行完成.");
		log.debug(param);
		
		if(param.getErrorCode() != 0){
			log.debug("TDS查询开奖公告存储过程异常！");
			BaseResponse response = new BaseResponse(1);	//参数错误
			response.setCMD(0x2001);
			String json = JSON.toJSONString(response,SerializerFeature.WriteMapNullValue);
			param.setResultJson(json);
			return param;
		}
		
		return param;
	}
	
	@Override
	@WebncpMethod(code = "2002")
	public BaseResponse getTdsVersion(String reqJson) throws Exception {
		String version = this.tdsProcessDao.getTdsVersion();
		
		Response2002Model resp = new Response2002Model();
		resp.setLatest_version(version);
		resp.setRsync_ip(PropertiesUtil.readValue("download_ftp_ip"));
		resp.setRsync_port(Integer.parseInt(PropertiesUtil.readValue("download_ftp_port")));
		resp.setRsync_user(PropertiesUtil.readValue("download_ftp_username"));
		resp.setRsync_passwd(PropertiesUtil.readValue("download_ftp_password"));
		resp.setRsync_root_dir(PropertiesUtil.readValue("download_ftp_path"));

		return resp;
	}


}
