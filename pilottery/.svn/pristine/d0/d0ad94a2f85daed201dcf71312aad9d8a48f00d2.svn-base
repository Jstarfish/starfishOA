package cls.pilottery.webncp.system.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.common.utils.DateUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.webncp.common.annotation.WebncpMethod;
import cls.pilottery.webncp.common.annotation.WebncpService;
import cls.pilottery.webncp.common.constants.WebncpErrorMessage;
import cls.pilottery.webncp.common.model.BaseResponse;
import cls.pilottery.webncp.system.dao.oms.VersionDao;
import cls.pilottery.webncp.system.model.Request5001Model;
import cls.pilottery.webncp.system.model.Request5002Model;
import cls.pilottery.webncp.system.model.Request5003Model;
import cls.pilottery.webncp.system.model.Request5004Model;
import cls.pilottery.webncp.system.model.Response5001Model;
import cls.pilottery.webncp.system.model.Response5002Model;
import cls.pilottery.webncp.system.service.TerminalVersionService;
import cls.pilottery.webncp.system.vo.Request5003Parmt;
import cls.pilottery.webncp.system.vo.Request5004Parmt;
import cls.pilottery.webncp.system.vo.RequestParamt;
import cls.pilottery.webncp.system.vo.Response5002Vo;
import cls.pilottery.webncp.system.vo.Response5003Vo;
import cls.pilottery.webncp.system.vo.Response5004Vo;

import com.alibaba.fastjson.JSONObject;

/**
 * 终端版本相关接口
 * 
 * 5001:查询设备编号
 * 5002:验证终端版本
 * 5003:更新版本下载进度
 * 5004:版本更新完成
 *
 */

@WebncpService
public class TerminalVersionServiceImpl implements TerminalVersionService {
	public static Logger log = Logger.getLogger(TerminalVersionServiceImpl.class);
	@Autowired
	private VersionDao versionDao;
	
	@Override
	@WebncpMethod(code = "5001")
	public BaseResponse queryDeviceCode(String reqJson) throws Exception {
		BaseResponse reps = new BaseResponse();
		Request5001Model req = JSONObject.parseObject(reqJson, Request5001Model.class);

		String macAddr = req.getMac_addr();// 终端网络地址
		if (!DateUtil.macAddrFomat(macAddr)) {
			reps.setCMD(req.getCMD());
			reps.setErrorCode(0);
			reps.setErrorMesg("wrong fomat param!");
			log.error("wrong fomat param!");
			return reps;
		}
		Response5001Model res = this.versionDao.queryDeviceCode(req);
		res.setCMD(req.getCMD());
		if (res != null) {
			log.info("查询5001成功");
			res.setErrorCode(WebncpErrorMessage.SUCCESS);
			res.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.SUCCESS));

		} else {
			res = new Response5001Model();
			log.error(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_RECORD_NOTEXSIT));
			res.setErrorCode(WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			res.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_RECORD_NOTEXSIT));
		}
		return res;
	}

	@Override
	@WebncpMethod(code = "5002")
	public BaseResponse verifyVersion(String reqJson) throws Exception {
		Request5002Model req = JSONObject.parseObject(reqJson, Request5002Model.class);
		BaseResponse reps = new BaseResponse();
		String termCode = String.valueOf(req.getTerminal_code());// 终端机编码
		String terminalModel = String.valueOf(req.getTerminal_model());// 终端机机型
		String vernId = req.getTerminal_version();// 当前终端运行的软件版本
		if (!DateUtil.mathcFomat(termCode, "[0-9]") || !DateUtil.mathcFomat(terminalModel, "[0-9]")
				|| !DateUtil.mathcFomat(vernId, "[0-9.]")) {
			log.error("wrong fomat param!");
			reps.setErrorCode(0);
			reps.setErrorMesg("wrong fomat param!");
			reps.setCMD(req.getCMD());
			return reps;
		}
		reps = this.updateVersion(req);
		return reps;
	}

	@SuppressWarnings("unused")
	private Response5002Model updateVersion(Request5002Model request) {
		Response5002Model response=new Response5002Model();
		try {
			this.versionDao.updateVersion(request);
			Response5002Vo vo = this.getLastVersion(request);
			// 获取当前机型的最新的升级计划
			// 另外需要判断，当前终端是否存在于升级过程表中

			String schduleid = "";// 升级计划编号
			String pkgvers = ""; // 升级包版本
			String updtime = null; // 更新日期
			int recordInProcess = 0;// 是否在过程表中登记
			boolean isHasDownLoad = false;// 是否已经下载完成
			boolean needUpdate = false;// 是否需要更新
			int updateFlag = 2; // 更新标识 2 立即更新 1延后更新
			String vernId = request.getTerminal_version();// 当前终端运行的软件版本
			String startDate = "";// 开始下载时间
			String endDate = "";// 结束下载时间
			String downName = "";// 下载文件名
			if (vo != null) {
				schduleid = vo.getSchedule_id();
				pkgvers = vo.getPkgvers().trim();
				updtime = vo.getUpdateTime();
				vo.setTerminal_code(StringUtils.leftPad(request.getTerminal_code().toString(), 10,"0"));
				if (pkgvers != null) {
					Response5002Vo vo1 = this.getVersionInfo(vo);
					if (vo1 != null) {
						recordInProcess = 1;
						isHasDownLoad = vo1.getIs_comp_dl().equals("1");
					}
					RequestParamt paramt = new RequestParamt();
					paramt.setTerminal_code(StringUtils.leftPad(request.getTerminal_code().toString(), 10,"0"));
					paramt.setSchedule_id(schduleid);
					paramt.setTerminal_version(pkgvers);
					Response5002Vo vopreocess = this.getProcessInfo(paramt);
					if (vopreocess != null) {
						startDate = vopreocess.getStartDate();
						endDate = vopreocess.getEndDate();
						downName = vopreocess.getDownName();
						vopreocess.setSchedule_id(schduleid);
						vopreocess.setPkgvers(pkgvers);
					}
					if (pkgvers.trim().equals(vernId)) {// 如果版本一致
						this.updateProcess(vopreocess);
						
						response.setErrorCode(WebncpErrorMessage.ERR_SAME_VERSION);
						log.error("版本一致,不需要更新!");
						response.setErrorMesg("The new vesion is same as current vesion of terminal machine");
						return response;
					}
					if (recordInProcess <= 0) {
						response.setCMD(request.getCMD());
						response.setErrorCode(WebncpErrorMessage.ERR_PROC_RECORD_NOTEXSIT);
						log.error(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_PROC_RECORD_NOTEXSIT));
						response.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_PROC_RECORD_NOTEXSIT));
						return response;
					}
					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date nowDate = new Date();// 现在时间
					String nowTime = df.format(nowDate);
					if (updtime != null) {
						Date d;

						d = df.parse(updtime);
						updateFlag = d.after(nowDate) ? 1 : 2;
						/* 计划更新时间 */

					} else {
						updateFlag = 1;
					}
					
					response.setCMD(request.getCMD());
					response.setRsync_ip(PropertiesUtil.readValue("download_ftp_ip"));
					response.setRsync_port(Integer.parseInt(PropertiesUtil.readValue("download_ftp_port")));
					response.setRsync_user(PropertiesUtil.readValue("download_ftp_username"));
					response.setRsync_passwd(PropertiesUtil.readValue("download_ftp_password"));
					response.setRsync_root_dir(PropertiesUtil.readValue("download_ftp_path"));
					response.setErrorCode(WebncpErrorMessage.SUCCESS);
					response.setErrorMesg("has new version");
					response.setSchedule_id(Integer.valueOf(schduleid));
					response.setVersion_no(pkgvers);
					response.setUpdate_flag(Integer.valueOf(updateFlag));
					if (isHasDownLoad == false){
						this.updateProcessTime(vopreocess);
					}
					
				}
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return response;
	}

	@Override
	public Response5002Vo getLastVersion(Request5002Model request) {
		return this.versionDao.getLastVersion(request);
	}

	@Override
	public Response5002Vo getVersionInfo(Response5002Vo vo) {
		return this.versionDao.getVersionInfo(vo);
	}

	@Override
	public Response5002Vo getProcessInfo(RequestParamt paramt) {
		return this.versionDao.getProcessInfo(paramt);
	}

	@Override
	public void updateProcess(Response5002Vo vo) {
		this.versionDao.updateProcess(vo);
	}

	@Override
	public void updateProcessTime(Response5002Vo vo) {
		this.versionDao.updateProcessTime(vo);
		
	}

	@Override
	@WebncpMethod(code = "5003")
	public BaseResponse updateDownload(String reqJson) throws Exception {
		Request5003Model req = JSONObject.parseObject(reqJson, Request5003Model.class);
		BaseResponse res = new BaseResponse();
		String terminal_id =req.getTerminal_code().toString();//终端唯一编号
		String schedule_id =String.valueOf(req.getSchedule_id());//升级计划编号
		String versionNo =req.getVersion_no();//软件更新版本号
		String modulePro =String.valueOf(req.getModule_progress());//模块升级进度
		String modeleName =req.getModule_name();//正在升级的模块名
		if (!DateUtil.mathcFomat(terminal_id, "[0-9]") || !DateUtil.mathcFomat(schedule_id, "[0-9]") || !DateUtil.mathcFomat(versionNo, "[0-9.]") || !DateUtil.mathcFomat(modulePro, "[0-9]") || DateUtil.existSqlWords(modeleName)){
			res.setCMD(req.getCMD());
			res.setErrorCode(0);
			res.setErrorMesg("wrong fomat param!");
			return res;
		}
	
		String startDate = null;
		Response5003Vo vo=this.versionDao.getProcessTime(req);
		if(vo!=null){
			startDate=vo.getStartDate();
		}
		Request5003Parmt request=new Request5003Parmt();
		request.setStartDate(startDate);
		request.setModule_progress(req.getModule_progress());
		request.setModule_name(req.getModule_name());
		request.setSchedule_id(req.getSchedule_id());
		request.setTerminal_code(req.getTerminal_code());
		request.setVersion_no(req.getVersion_no());
		int result =this.updateDownProcessByNO(request);
		if (result > 0) {
		        this.updateSoftware(req);	
		        res.setCMD(req.getCMD());
		        res.setErrorCode(WebncpErrorMessage.SUCCESS);
				res.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.SUCCESS));
		}else {
		
			res.setCMD(req.getCMD());
			res.setErrorCode(WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			res.setErrorMesg("record not exist!");
		}
		return res;
	}

	@Override
	public Response5003Vo getProcessTime(Request5003Model request) {
		return this.versionDao.getProcessTime(request);
	}

	@Override
	public Integer updateDownProcessByNO(Request5003Parmt request) {
		Integer resulst=0;
		try{
			this.versionDao.updateDownProcessByNO(request);
			resulst=1;
		}catch(Exception e){
			resulst=0;
		}
		return resulst;
		
	}

	@Override
	public void updateSoftware(Request5003Model request) {
		this.versionDao.updateSoftware(request);
		
	}

	@Override
	@WebncpMethod(code = "5004")
	public BaseResponse overDownload(String reqJson) throws Exception {
		BaseResponse reps = new BaseResponse();
		
		Request5004Model req = JSONObject.parseObject(reqJson, Request5004Model.class);
		reps.setCMD(req.getCMD());
		String terminal_id =String.valueOf(req.getTerminal_code());//终端唯一编号
		String schedule_id = String.valueOf(req.getSchedule_id());//升级计划编号
		String version_no = req.getVersion_no();//软件更新版本号
		if (!DateUtil.mathcFomat(terminal_id, "[0-9]") || !DateUtil.mathcFomat(schedule_id, "[0-9]") || !DateUtil.mathcFomat(version_no, "[0-9.]")){
		
			reps.setErrorCode(0);
			reps.setErrorMesg("wrong fomat param!");
			return reps;
		}
		Response5004Vo vo=this.getUpgradeproc(req);
		String downName=null;
		if(vo!=null){
			downName=vo.getDownName();
		}
		Request5004Parmt request=new Request5004Parmt ();
		request.setDownName(downName);
		request.setSchedule_id(req.getSchedule_id());
		request.setTerminal_code(req.getTerminal_code());
		request.setVersion_no(req.getVersion_no());
		int result =this.updateOverupgradeproc(request);
		if (result > 0) {
			this.updateOverupgradeproc(request);
			reps.setErrorCode(WebncpErrorMessage.SUCCESS);
			reps.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.SUCCESS));
		}
		else{
			log.error(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_RECORD_NOTEXSIT));
			reps.setErrorCode(WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			reps.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_RECORD_NOTEXSIT));
		}
		return reps;
	}

	@Override
	public Integer updateOverupgradeproc(Request5004Parmt request) {
		Integer resulst=0;
		try{
			 this.versionDao.updateOverupgradeproc(request);
			 resulst=1;
		}
		catch(Exception e){
			 resulst=0;
		}
		return  resulst;
	}

	@Override
	public Response5004Vo getUpgradeproc(Request5004Model request) {
		return this.versionDao.getUpgradeproc(request);
	}

	@Override
	public void updateOverSoftware(Request5004Parmt request) {
		this.versionDao.updateOverSoftware(request);
	}
}
