package cls.pilottery.webncp.system.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.common.utils.DateUtil;
import cls.pilottery.webncp.common.annotation.WebncpMethod;
import cls.pilottery.webncp.common.annotation.WebncpService;
import cls.pilottery.webncp.common.constants.WebncpErrorMessage;
import cls.pilottery.webncp.common.model.BaseResponse;
import cls.pilottery.webncp.system.dao.oms.MessageServiceDao;
import cls.pilottery.webncp.system.dao.pil.PILDataReportDao;
import cls.pilottery.webncp.system.model.Request4001Model;
import cls.pilottery.webncp.system.model.Request4002Model;
import cls.pilottery.webncp.system.model.Request4003Model;
import cls.pilottery.webncp.system.model.Request4004Model;
import cls.pilottery.webncp.system.model.Request4005Model;
import cls.pilottery.webncp.system.model.Response4001Model;
import cls.pilottery.webncp.system.model.Response4001Record;
import cls.pilottery.webncp.system.model.Response4002Model;
import cls.pilottery.webncp.system.model.Response4002Record;
import cls.pilottery.webncp.system.model.Response4003Model;
import cls.pilottery.webncp.system.model.Response4003Record;
import cls.pilottery.webncp.system.model.Response4004Model;
import cls.pilottery.webncp.system.model.Response4005Model;
import cls.pilottery.webncp.system.model.Response4005Record;
import cls.pilottery.webncp.system.model.Response4009Model;
import cls.pilottery.webncp.system.service.MessageService;
import cls.pilottery.webncp.system.vo.Response4001Vo;
import cls.pilottery.webncp.system.vo.Response4002Vo;

import com.alibaba.fastjson.JSONObject;

/**
 * 信息公布相关接口
 * 
 * 4001:开奖公告查询
 * 4002:中奖信息查询
 * 4003:通知列表查询
 * 4004:通知详情查询
 * 4005:开奖号码查询
 *
 */
@WebncpService
public class MessageServiceImpl implements MessageService {

	public static Logger logger = Logger.getLogger(MessageServiceImpl.class);
	
	@Autowired
	private MessageServiceDao messageServiceDao;
	@Autowired
	private PILDataReportDao pilDataReportDao;
	
	@Override
	@WebncpMethod(code = "4001")
	public BaseResponse getDrawAnnouncement(String reqJson) throws Exception {
		
		Request4001Model req = JSONObject.parseObject(reqJson, Request4001Model.class);
		BaseResponse rsp = new BaseResponse();
		
		logger.info("4001->getDrawAnnouncement: " + req);
		
		String gameCode = req.getGameCode();
		String perdIssue = req.getPerdIssue();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("gameCode", gameCode);
		map.put("perdIssue", perdIssue);
		
		//校验参数合法性
		if (!DateUtil.mathcFomat(gameCode, "[0-9]") || !DateUtil.mathcFomat(perdIssue, "[0-9]")) {
			logger.error("gameCode:" + gameCode + ", perdIssue:" + perdIssue);
			rsp.setErrorCode(WebncpErrorMessage.ERR_PARAM_FOMAT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_PARAM_FOMAT));
			return rsp;
		}
		
		//查询游戏期次是否存在
		Integer issueCount = messageServiceDao.getIssueCount4001(map);
		logger.info(issueCount + " issue exist in database");
		if (issueCount == 0) {
			logger.error("errmsgs:" + WebncpErrorMessage.ERR_ISSUE_NOTEXSIT);
			rsp.setErrorCode(WebncpErrorMessage.ERR_ISSUE_NOTEXSIT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_ISSUE_NOTEXSIT));
			return rsp;
		}
		
		//若期次参数缺省，则获取当前期号最大的期次
		if (perdIssue == null || perdIssue.length() == 0) {
			perdIssue = messageServiceDao.getDefaultIssue4001(gameCode);
			req.setPerdIssue(perdIssue);
			map.put("perdIssue", perdIssue);
			logger.info("perdIssue not specified, use perdIssue=" + perdIssue);
		}
		
		//查询期次是否已开奖
		List<Response4001Vo> drawInfo = messageServiceDao.getDrawInfo4001(map);
		if (drawInfo == null || drawInfo.size() == 0) {
			logger.error("errmsgs: getDrawInfo4001: " + WebncpErrorMessage.ERR_ISSUE_EXIST_RESULT_NOTEXSIT);
			rsp.setErrorCode(WebncpErrorMessage.ERR_ISSUE_EXIST_RESULT_NOTEXSIT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_ISSUE_EXIST_RESULT_NOTEXSIT));
			return rsp;
		}
		logger.info("issue draw info: gameCode=" + drawInfo.get(0).getGameCode() + 
				", perdIssue=" + drawInfo.get(0).getPerdIssue() + 
				", drawTime=" + drawInfo.get(0).getDrawTime() + 
				", drawCode=" + drawInfo.get(0).getDrawCode());
		
		//获取中奖信息
		List<Response4001Record> prizeLevelInfo = messageServiceDao.getPrizeLevelInfo4001(map);
		if (prizeLevelInfo == null || prizeLevelInfo.size() == 0) {
			logger.error("errmsgs: getPrizeLevelInfo4001: " + WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			rsp.setErrorCode(WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_RECORD_NOTEXSIT));
			return rsp;
		}
		
		//处理成功，构造返回消息
		Response4001Model rspSuccess = new Response4001Model();
		rspSuccess.setCMD(0x4001);
		rspSuccess.setGameCode(drawInfo.get(0).getGameCode());
		rspSuccess.setPerdIssue(drawInfo.get(0).getPerdIssue());
		rspSuccess.setDrawTime(drawInfo.get(0).getDrawTime());
		rspSuccess.setDrawCode(drawInfo.get(0).getDrawCode());
		rspSuccess.setPrzieInfo(new ArrayList<Response4001Record>(prizeLevelInfo));	
		
		logger.info("0x4001 processed successfully");
		return rspSuccess;
	}

	@Override
	@WebncpMethod(code = "4002")
	public BaseResponse getWinningInfo(String reqJson) throws Exception {
		
		Request4002Model req = JSONObject.parseObject(reqJson, Request4002Model.class);
		BaseResponse rsp = new BaseResponse();
		
		logger.info("4002->getWinningInfo: " + req);

		String gameCode = req.getGameCode();
		String perdIssue = req.getPerdIssue();
		String agencyCode = req.getAgencyCode();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("gameCode", gameCode);
		map.put("perdIssue", perdIssue);
		map.put("agencyCode", agencyCode);
		
		//校验参数合法性
		if (!DateUtil.mathcFomat(gameCode, "[0-9]") || !DateUtil.mathcFomat(perdIssue, "[0-9]") || !DateUtil.mathcFomat(agencyCode, "[0-9]")) {
			logger.error("gameCode:" + gameCode + ", perdIssue:" + perdIssue + ", agencyCode:" + agencyCode);
			rsp.setErrorCode(WebncpErrorMessage.ERR_PARAM_FOMAT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_PARAM_FOMAT));
			return rsp;
		}
		
		//查询游戏期次是否存在
		Integer issueCount = messageServiceDao.getIssueCount4002(map);
		logger.info(issueCount + " issue exist in database");
		if (issueCount == 0) {
			logger.error("errmsgs:" + WebncpErrorMessage.ERR_ISSUE_NOTEXSIT);
			rsp.setErrorCode(WebncpErrorMessage.ERR_ISSUE_NOTEXSIT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_ISSUE_NOTEXSIT));
			return rsp;
		}
		
		//若期次参数缺省，则获取当前已开奖期号最大的期次
		if (perdIssue == null || perdIssue.length() == 0) {
			perdIssue = messageServiceDao.getDefaultIssue4002(map);
			if(perdIssue == null){
				rsp.setErrorCode(WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
				return rsp;
			}
			req.setPerdIssue(perdIssue);
			map.put("perdIssue", perdIssue);
			logger.info("perdIssue not specified, use perdIssue=" + perdIssue);
		}
		
		//获取期次开奖号码信息
		List<Response4002Vo> drawInfo = messageServiceDao.getDrawInfo4002(map);
		if (drawInfo == null || drawInfo.size() == 0) {
			logger.error("errmsgs: getDrawInfo4002: " + WebncpErrorMessage.ERR_ISSUE_EXIST_RESULT_NOTEXSIT);
			rsp.setErrorCode(WebncpErrorMessage.ERR_ISSUE_EXIST_RESULT_NOTEXSIT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_ISSUE_EXIST_RESULT_NOTEXSIT));
			return rsp;
		}
		logger.info("issue draw info: gameCode=" + drawInfo.get(0).getGameCode() + 
				", perdIssue=" + drawInfo.get(0).getPerdIssue() + 
				", drawCode=" + drawInfo.get(0).getDrawCode());
		
		//获取中奖信息
		List<Response4002Record> prizeLevelInfo = messageServiceDao.getPrizeLevelInfo4002(map);
		if (prizeLevelInfo == null || prizeLevelInfo.size() == 0) {
			logger.error("errmsgs: getPrizeLevelInfo4002: " + WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			rsp.setErrorCode(WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_RECORD_NOTEXSIT));
			return rsp;
		}

		//处理成功，构造返回消息
		Response4002Model rspSuccess = new Response4002Model();
		rspSuccess.setCMD(0x4002);
		rspSuccess.setGameCode(drawInfo.get(0).getGameCode());
		rspSuccess.setPerdIssue(drawInfo.get(0).getPerdIssue());
		rspSuccess.setDrawCode(drawInfo.get(0).getDrawCode());
		rspSuccess.setRecordList(new ArrayList<Response4002Record>(prizeLevelInfo));
		
		logger.info("0x4002 processed successfully");
		return rspSuccess;
	}

	@Override
	@WebncpMethod(code = "4003")
	public BaseResponse getNoticeList(String reqJson) throws Exception {
		
		Request4003Model req = JSONObject.parseObject(reqJson, Request4003Model.class);
		BaseResponse rsp = new BaseResponse();
		
		logger.info("4003->getNoticeList:" + req);
		
		Integer pageSize = req.getPageSize();
		Integer pageIndex = req.getPageIndex();
		String  agencyCode = req.getAreaCode(); //接口名称存在错误
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageSize", pageSize);
		map.put("pageIndex", pageIndex);
		map.put("agencyCode", agencyCode);
		map.put("beginNum", (pageIndex - 1) * pageSize);
		map.put("endNum", (pageIndex - 1) * pageSize + pageSize);
		/* beginNum < rows_in_one_page <= endNum  */
		
		//校验参数合法性
		if (!DateUtil.mathcFomat(agencyCode, "[0-9]")) {
			logger.error("pageSize:" + pageSize + ", pageIndex:" + pageIndex + ", agencyCode:" + agencyCode);
			rsp.setErrorCode(WebncpErrorMessage.ERR_PARAM_FOMAT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_PARAM_FOMAT));
			return rsp;
		}
		if (agencyCode.length() < 8) {
			logger.error("areaCode.lengh:" + agencyCode.length());
			rsp.setErrorCode(WebncpErrorMessage.AGENCY_CODE_ERROR);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.AGENCY_CODE_ERROR));
			return rsp;
		}
		
		//通过销售站编码获得区域编码
		String orgCode = pilDataReportDao.getOrgCodeByAgency(agencyCode);
		if (orgCode == null || orgCode == "") {
			logger.error("areaCode:" + orgCode);
			rsp.setErrorCode(WebncpErrorMessage.AGENCY_CODE_ERROR);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.AGENCY_CODE_ERROR));
			return rsp;
		}
		map.put("areaCode", orgCode);
		
		//查询通知列表
		List<Response4003Record> noticeList = messageServiceDao.getNoticeList4003(map);
		if (noticeList == null || noticeList.size() == 0) {
			logger.error("errmsgs: getNoticeList4003: " + WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			rsp.setErrorCode(WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_RECORD_NOTEXSIT));
			return rsp;
		}
		
		//处理成功，构造返回消息
		Response4003Model rspSuccess = new Response4003Model();
		rspSuccess.setCMD(0x4003);
		rspSuccess.setPageCount(1);
		rspSuccess.setTotalCount(noticeList.size());
		rspSuccess.setRecordCount(noticeList.size());
		rspSuccess.setRecordList(new ArrayList<Response4003Record>(noticeList));
		
		logger.info("0x4003 processed successfully");
		return rspSuccess;
	}

	@Override
	@WebncpMethod(code = "4004")
	public BaseResponse getNoticeDetails(String reqJson) throws Exception {
		
		Request4004Model req = JSONObject.parseObject(reqJson, Request4004Model.class);
		BaseResponse rsp = new BaseResponse();
		
		logger.info("4004->getNoticeDetails: " + req);
		
		String notCode = req.getNotCode();
		
		//校验参数合法性
		if (!DateUtil.mathcFomat(notCode, "[0-9]")) {
			logger.error("notCode:" + notCode);
			rsp.setErrorCode(WebncpErrorMessage.ERR_PARAM_FOMAT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_PARAM_FOMAT));
			return rsp;
		}
		
		//获得通知详情
		Response4004Model noticeDetail = messageServiceDao.getNotice4004(notCode);
		if (noticeDetail == null) {
			logger.error("errmsgs: getNotice4004: " + WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			rsp.setErrorCode(WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_RECORD_NOTEXSIT));
			return rsp;
		}
		
		//处理成功，构造返回消息
		Response4004Model rspSuccess = new Response4004Model();
		rspSuccess.setCMD(0x4004);
		rspSuccess.setNotCode(noticeDetail.getNotCode());
		rspSuccess.setSendTime(noticeDetail.getSendTime());
		rspSuccess.setTitle(noticeDetail.getTitle());
		rspSuccess.setContent(noticeDetail.getContent());
		
		logger.info("0x4004 processed successfully");
		return rspSuccess;
	}

	@Override
	@WebncpMethod(code = "4005")
	public BaseResponse getDrawResult(String reqJson) throws Exception {
		Request4005Model req = JSONObject.parseObject(reqJson, Request4005Model.class);
		BaseResponse rsp = new BaseResponse();
		
		logger.info("4005->getDrawResult: " + req);
		
		String gameCode = req.getGameCode();
		String perdIssue = req.getPerdIssue();
		Integer pageSize = req.getPageSize();
		Integer pageIndex = req.getPageIndex();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("gameCode", gameCode);
		map.put("perdIssue", perdIssue);
		map.put("pageSize", pageSize);
		map.put("pageIndex", pageIndex);
		map.put("beginNum", (pageIndex - 1) * pageSize);
		map.put("endNum", (pageIndex - 1) * pageSize + pageSize);
		/* beginNum < rows_in_one_page <= endNum  */
		
		//校验参数合法性
		if (!DateUtil.mathcFomat(gameCode, "[0-9]") || !DateUtil.mathcFomat(perdIssue, "[0-9]")) {
			logger.error("gameCode:" + gameCode + ", perdIssue:" + perdIssue);
			rsp.setErrorCode(WebncpErrorMessage.ERR_PARAM_FOMAT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_PARAM_FOMAT));
			return rsp;
		}
		
		//查询游戏期次是否存在
		Integer issueCount = messageServiceDao.getIssueCount4005(map);
		logger.info(issueCount + " issue exist in database");
		if (issueCount == 0) {
			logger.error("errmsgs:" + WebncpErrorMessage.ERR_ISSUE_NOTEXSIT);
			rsp.setErrorCode(WebncpErrorMessage.ERR_ISSUE_NOTEXSIT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_ISSUE_NOTEXSIT));
			return rsp;
		}
		
		//查询开奖号码
		List<Response4005Record> drawNumberList = messageServiceDao.getDrawNumber4005(map);
		if (drawNumberList == null || drawNumberList.size() == 0) {
			logger.error("errmsgs: getDrawNumber4005: " + WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			rsp.setErrorCode(WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			rsp.setErrorMesg(WebncpErrorMessage.getMsg(WebncpErrorMessage.ERR_RECORD_NOTEXSIT));
			return rsp;
		}
		
		//处理成功，构造返回消息
		Response4005Model rspSuccess = new Response4005Model();
		rspSuccess.setCMD(0x4005);
		rspSuccess.setPageCount(1);
		rspSuccess.setTotalCount(drawNumberList.size());
		rspSuccess.setRecordCount(drawNumberList.size());
		rspSuccess.setRecordList(new ArrayList<Response4005Record>(drawNumberList));
		
		logger.info("0x4005 processed successfully");
		return rspSuccess;
	}
	
	/**
     * 最新通知编号
     */
    @WebncpMethod(code = "4009")
    public BaseResponse getNewNotice(String reqJson) throws Exception {
    	Map req = JSONObject.parseObject(reqJson, Map.class);
		BaseResponse rsp = null;
		String agencyCode = (String)req.get("agencyCode");
		logger.info("4009->getNewNotice: " + req);
		
		String noticeId = messageServiceDao.getNewNoticeId4009(agencyCode);
		
		if (noticeId == null) {
			logger.error("errmsgs: getNewNoticeId4009: " + WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			rsp = new BaseResponse(WebncpErrorMessage.ERR_RECORD_NOTEXSIT);
			return rsp;
		}
		
		//处理成功，构造返回消息
		Response4009Model rspSuccess = new Response4009Model();
		rspSuccess.setCMD(0x4009);
		rspSuccess.setNotId(noticeId);
		
		logger.info("0x4009 processed successfully");
		return rspSuccess;
    }

}
