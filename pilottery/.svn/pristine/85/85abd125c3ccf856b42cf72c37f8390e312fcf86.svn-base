package cls.pilottery.webncp.system.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.common.utils.DateUtil;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.webncp.common.annotation.WebncpMethod;
import cls.pilottery.webncp.common.annotation.WebncpService;
import cls.pilottery.webncp.common.constants.WebncpErrorMessage;
import cls.pilottery.webncp.common.model.BaseResponse;
import cls.pilottery.webncp.system.dao.DataCollectDao;
import cls.pilottery.webncp.system.model.Request8001Model;
import cls.pilottery.webncp.system.model.Request8004Model;
import cls.pilottery.webncp.system.model.Request8006Model;
import cls.pilottery.webncp.system.model.Request8007Model;
import cls.pilottery.webncp.system.model.Request9001Model;
import cls.pilottery.webncp.system.model.Request9002Model;
import cls.pilottery.webncp.system.model.Response8004Model;
import cls.pilottery.webncp.system.model.Response8004Record;
import cls.pilottery.webncp.system.model.Response9001Model;
import cls.pilottery.webncp.system.service.DataCollectService;

import com.alibaba.fastjson.JSONObject;

/**
 * 数据采集相关接口 
 * 9001:采集查询,查询是否需要有提供日志的记录 
 * 9002:完成通知,更新对应的记录为已完成 
 * 8001:缴款申请 
 * 8002:缴款记录查询 
 * 8006:站点提现
 * 8007:站点交易密码修改
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

		if (StringUtils.isEmpty(termCode) || !DateUtil.mathcFomat(termCode, "[0-9]")) {
			res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND, "wrong fomat param!");
			log.error("wrong fomat param");
			return res;
		}

		Response9001Model resp = this.dataCollectDao.getLogByTermCode(req);
		if (resp != null) {
			res.setCMD(req.getCMD());
			resp.setRsync_ip(PropertiesUtil.readValue("upload_ftp_ip"));
			resp.setRsync_port(Integer.parseInt(PropertiesUtil.readValue("upload_ftp_port")));
			resp.setRsync_user(PropertiesUtil.readValue("upload_ftp_username"));
			resp.setRsync_passwd(PropertiesUtil.readValue("upload_ftp_password"));
			resp.setRsync_root_dir(PropertiesUtil.readValue("upload_ftp_path"));
			log.info("采集查询9001成功");
		} else {
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
		if (StringUtils.isEmpty(reqSeq) || !DateUtil.mathcFomat(reqSeq, "[0-9]")) {
			res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND, "wrong fomat param!");
			log.error("wrong fomat param!");
			return res;
		}
		if (StringUtils.isEmpty(fileName.trim())) {
			res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND, "file name is null");
			log.error("file name is null");
			return res;
		}
		int result = dataCollectDao.updateLogStatus(req);
		if (result > 0) {
			return res;
		} else {
			res = new BaseResponse(WebncpErrorMessage.ERR_RECORD_NOTEXSIT, "record not exist!");
			log.error("record not exist!");
		}
		return res;
	}

	@Override
	@WebncpMethod(code = "8001")
	public BaseResponse paymentApply(String reqJson) throws Exception {
		Request8001Model req = JSONObject.parseObject(reqJson, Request8001Model.class);
		BaseResponse res = null;

		if (req == null || req.getManagerId() == null || StringUtils.isEmpty(req.getTransPwd()) || StringUtils.isEmpty(req.getAgencyCode()) || req.getApplyAmount() == null) {
			res = new BaseResponse(WebncpErrorMessage.ERR_PARAM_FOMAT, "wrong fomat param!");
			log.error("参数错误!");
			return res;
		}

		req.setLoginPwd(MD5Util.MD5Encode(req.getLoginPwd()));
		req.setTransPwd(MD5Util.MD5Encode(req.getTransPwd()));
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("loginPwd", req.getLoginPwd());
		map.put("userId", req.getManagerId());
		int flag = dataCollectDao.validateMMLoginPwd(map);
		if (flag != 1) {
			res = new BaseResponse(800102);
			log.info("市场管理员ID或密码错误");
			return res;
		}
		
		log.debug("执行存储过程p_outlet_topup");
		dataCollectDao.outletTopUp(req);
		log.debug("存储过程执行完成，执行结构：[errorCode:" + req.getErrorCode() + ",errorMsg:" + req.getErrorMesg());
		if (req.getErrorCode() == 0) {
			res = new BaseResponse();
		} else if (req.getErrorCode() == 2 || req.getErrorCode() == 3 || req.getErrorCode() == 4) {
			res = new BaseResponse(800102);
			log.info("市场管理员ID或密码错误");
		} else {
			String errorMsg = req.getErrorMesg();
			if(errorMsg.contains("Insufficient account balance")){
				res = new BaseResponse(800107,"Insufficient account balance");
			}else{
				res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND,LocaleUtil.getUserLocaleErrorMsg(req.getErrorMesg(),"en"));
			}
		}

		return res;
	}

	@Override
	@WebncpMethod(code = "8004")
	public BaseResponse getTopupRecord(String reqJson) throws Exception {
		Request8004Model req = JSONObject.parseObject(reqJson, Request8004Model.class);

		if (req == null || req.getManagerId() < 1 || StringUtils.isEmpty(req.getLoginPwd())) {
			BaseResponse res = new BaseResponse(WebncpErrorMessage.ERR_PARAM_FOMAT, "wrong fomat param!");
			log.error("参数错误!");
			return res;
		}
		req.setLoginPwd(MD5Util.MD5Encode(req.getLoginPwd()));
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("loginPwd", req.getLoginPwd());
		map.put("userId", req.getManagerId());
		int flag = dataCollectDao.validateMMLoginPwd(map);

		if (flag != 1) {
			BaseResponse res = new BaseResponse(800102);
			log.info("市场管理员ID或密码错误");
			return res;
		} else {
			Response8004Model res = new Response8004Model();
			long allowAmount = dataCollectDao.getAllowAmount(req);
			int totalCount = dataCollectDao.getTopupRecordCount(req);
			List<Response8004Record> list = dataCollectDao.getTopupRecord(req);
			res.setAllowAmount(allowAmount);
			res.setRecordList(list);
			res.setRecordCount(list.size());
			res.setTotalCount(totalCount);
			res.setPageCount((int) Math.ceil(totalCount / req.getPageSize()));

			return res;
		}
	}

	@Override
	@WebncpMethod(code = "8006")
	public BaseResponse outletWithdraw(String reqJson) throws Exception {
		Request8006Model req = JSONObject.parseObject(reqJson, Request8006Model.class);
		BaseResponse res = null;

		if (req == null || req.getManagerId() == null || StringUtils.isEmpty(req.getLoginPwd()) || StringUtils.isEmpty(req.getTransPwd()) || StringUtils.isEmpty(req.getAgencyCode()) || req.getApplyAmount() == null) {
			res = new BaseResponse(WebncpErrorMessage.ERR_PARAM_FOMAT, "wrong fomat param!");
			log.error("参数错误!");
			return res;
		}

		req.setLoginPwd(MD5Util.MD5Encode(req.getLoginPwd()));
		req.setTransPwd(MD5Util.MD5Encode(req.getTransPwd()));
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("loginPwd", req.getLoginPwd());
		map.put("userId", req.getManagerId());
		int flag = dataCollectDao.validateMMLoginPwd(map);
		if (flag != 1) {
			res = new BaseResponse(800102);
			log.info("市场管理员ID或密码错误");
			return res;
		}

		log.debug("执行存储过程p_outlet_withdraw_app");
		dataCollectDao.outletWithdrawApp(req);
		log.debug("存储过程执行完成，执行结构：[errorCode:" + req.getErrorCode() + ",errorMsg:" + req.getErrorMesg());
		if (req.getErrorCode() == 0) {

//			String cashWdLimitAmount = dataCollectDao.getParamValueById(10);
//			long limitAmount = Long.parseLong(cashWdLimitAmount);
//
//			if (req.getApplyAmount() <= limitAmount) {
				log.debug("自动进行提现审批，执行存储过程：p_withdraw_approve_mm");
				dataCollectDao.outletWithdrawApprove(req);
				log.debug("存储过程执行完成，执行结构：[errorCode:" + req.getErrorCode() + ",errorMsg:" + req.getErrorMesg());
				if (req.getErrorCode() == 0) {
					res = new BaseResponse();
				} else if (req.getErrorCode() == 4) {
					res = new BaseResponse(800106);
					log.info("提现金额不足");
				} else {
					res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND,LocaleUtil.getUserLocaleErrorMsg(req.getErrorMesg(),"en"));
				}
			//}
		} else if (req.getErrorCode() == 2 || req.getErrorCode() == 4) {
			res = new BaseResponse(800102);
			log.info("市场管理员ID或交易密码错误");
		} else if (req.getErrorCode() == 2) {
			res = new BaseResponse(800106);
			log.info("提现金额不足");
		} else {
			res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND,LocaleUtil.getUserLocaleErrorMsg(req.getErrorMesg(),"en"));
		}

		return res;
	}
	
	@Override
	@WebncpMethod(code = "8007")
	public BaseResponse updateOutletTransPwd(String reqJson) throws Exception {
		Request8007Model req = JSONObject.parseObject(reqJson, Request8007Model.class);
		BaseResponse res = new BaseResponse();
		if (StringUtils.isEmpty(req.getAgencyCode()) || StringUtils.isEmpty(req.getOldPwd()) || StringUtils.isEmpty(req.getNewPwd())) {
			res = new BaseResponse(WebncpErrorMessage.ERR_PARAM_FOMAT, "wrong fomat param!");
			log.error("wrong fomat param!");
			return res;
		}
		req.setOldPwd(MD5Util.MD5Encode(req.getOldPwd()));
		int result = dataCollectDao.validateOutletOldPwd(req);
		if (result > 0) {
			req.setNewPwd(MD5Util.MD5Encode(req.getNewPwd()));
			dataCollectDao.updateOutletTransPwd(req);
			return res;
		} else {
			res = new BaseResponse(800201, "原密码不正确");
			log.error("原密码不正确");
		}
		return res;
	}
}
