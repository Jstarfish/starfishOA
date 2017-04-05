package cls.pilottery.webncp.system.service.impl;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import cls.pilottery.common.utils.DateUtil;
import cls.pilottery.webncp.common.annotation.WebncpMethod;
import cls.pilottery.webncp.common.annotation.WebncpService;
import cls.pilottery.webncp.common.constants.WebncpErrorMessage;
import cls.pilottery.webncp.common.model.BaseResponse;
import cls.pilottery.webncp.system.dao.oms.DataReportDao;
import cls.pilottery.webncp.system.dao.pil.PILDataReportDao;
import cls.pilottery.webncp.system.model.DealFlowModel;
import cls.pilottery.webncp.system.model.Request3001Model;
import cls.pilottery.webncp.system.model.Request3002Model;
import cls.pilottery.webncp.system.model.Request3003Model;
import cls.pilottery.webncp.system.model.Request3005Model;
import cls.pilottery.webncp.system.model.Request3006Model;
import cls.pilottery.webncp.system.model.Request3007Model;
import cls.pilottery.webncp.system.model.Request3008Model;
import cls.pilottery.webncp.system.model.Request3009Model;
import cls.pilottery.webncp.system.model.Response3001Model;
import cls.pilottery.webncp.system.model.Response3001Record;
import cls.pilottery.webncp.system.model.Response3002Model;
import cls.pilottery.webncp.system.model.Response3002Record;
import cls.pilottery.webncp.system.model.Response3003Model;
import cls.pilottery.webncp.system.model.Response3005Model;
import cls.pilottery.webncp.system.model.Response3006Model;
import cls.pilottery.webncp.system.model.Response3007Model;
import cls.pilottery.webncp.system.model.Response3008Model;
import cls.pilottery.webncp.system.model.Response3009Model;
import cls.pilottery.webncp.system.service.DataReportService;
import cls.pilottery.webncp.system.vo.RequestParamt3005;

import com.alibaba.fastjson.JSONObject;

/**
 * 
 *	数据报表相关接口
 *	3001:时段报表,根据时间范围,查询站点的销售额等信息.
 *	3002:期次报表,根据期次范围,查询站点的销售额信息.
 *	3004:原体彩日结报表
 *  3005:员体彩月结报表
 *  3006:交易流水查询
 *  3007:实时报表查询
 *  3008:日结报表
 *  3009:月结报表
 *  3010:查询站点账户余额 
 *  
 */
@WebncpService
public class DataReportServiceImpl implements DataReportService {

	public static Logger log = Logger.getLogger(DataReportServiceImpl.class);
	
	@Autowired
	private DataReportDao dataReportDao;
	
	@Autowired
	private PILDataReportDao pilDataReportDao;

	@Override
	@WebncpMethod(code = "3001")
	public BaseResponse getSaleReportByDate(String reqJson) throws Exception {
		
		Request3001Model req = JSONObject.parseObject(reqJson, Request3001Model.class);
		BaseResponse res = new BaseResponse();
		String gameCode = req.getGameCode();
		String startDate = req.getStartDate();
		String endDate = req.getEndDate();
		String agencyCode = req.getAgencyCode();
		
		if (!DateUtil.mathcFomat(gameCode, "[0-9]") || !DateUtil.mathcFomat(startDate, "[0-9]")
				|| !DateUtil.mathcFomat(endDate, "[0-9]") || !DateUtil.mathcFomat(agencyCode, "[0-9]")) {
			res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND, "wrong fomat param!");
			log.error("wrong fomat param!");
			return res;
		}
		if (StringUtils.isNotEmpty(startDate) && StringUtils.isNotEmpty(endDate)) {
			if (startDate.length() != 8 || endDate.length() != 8){
				res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND, "wrong date param!");
				log.error("wrong date param!");
			return res;
			}
		}else{
			String maxDate = dataReportDao.getMaxDate(req);
			startDate = maxDate;
			endDate = maxDate;
		}
		
		List<Response3001Record> list = dataReportDao.getSaleReportByDate(req);
		Response3001Model response = new Response3001Model();
		response.setCMD(req.getCMD());
		response.setDateScope(startDate+"-"+endDate);
		response.setRecordList(list);
		log.info("时段报表查询3001成功");
		return response;
	}

	@Override
	@WebncpMethod(code = "3002")
	public BaseResponse getSaleReport(String reqJson) throws Exception {
		Request3002Model req = JSONObject.parseObject(reqJson, Request3002Model.class);
		BaseResponse res = new BaseResponse();
		String gameCode = req.getGameCode();
		String agencyCode = req.getAgencyCode();
		String startIssue = req.getStartIssue();
		String closeIssue = req.getCloseIssue();
		if (!DateUtil.mathcFomat(gameCode, "[0-9]") || !DateUtil.mathcFomat(agencyCode, "[0-9]") || !DateUtil.mathcFomat(startIssue, "[0-9]") || !DateUtil.mathcFomat(closeIssue, "[0-9]")){
    		res= new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND, "wrong fomat param!");
    		log.error("wrong fomat param!");
    		return res;
    	}
		List<Response3002Record> list = dataReportDao.getSaleReport(req);
		Response3002Model response=new Response3002Model();
		response.setCMD(req.getCMD());
		response.setPerdIssue(startIssue+"-"+closeIssue);
		response.setRecordList(list);
		log.info("时段报表查询3002成功");
		return response;
	}

	@Override
	@WebncpMethod(code = "3003")
	public BaseResponse getDailyBalanceReport(String reqJson) throws Exception {
		Request3003Model req=JSONObject.parseObject(reqJson,Request3003Model.class);
		String accountDay =req.getAccountDay();
		if (accountDay==null||accountDay=="") {
        	String maxDate=dataReportDao.get3003MaxDate(req);
    		accountDay=maxDate;
    		req.setAccountDay(accountDay);
    	}else{
    		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
     		req.setAccountDay(format.parse(accountDay).toString());
    	}
		Response3003Model response=new Response3003Model();
		response=dataReportDao.get3003Report(req);
		log.info("日结算报表3003查询成功");
		return response;
	}
	
	@Override
	@WebncpMethod(code = "3005")
	public BaseResponse getNewMonthBalanceReport(String reqJson) throws Exception {
		Request3005Model req=JSONObject.parseObject(reqJson,Request3005Model.class);
		String accountMonth = req.getAccountMonth();
		String agencyCode = req.getAgencyCode();
		String year = null;
        String month = null;
        BaseResponse res=new BaseResponse();
        SimpleDateFormat format = new SimpleDateFormat("yyyyMM");
    	if(accountMonth==null||accountMonth==""){
 			Calendar c = Calendar.getInstance();
 			c.add(Calendar.MONTH, -1);
 			accountMonth = format.format(c.getTime());
    	}
		if (!DateUtil.mathcFomat(accountMonth, "[0-9]") || !DateUtil.mathcFomat(agencyCode, "[0-9]")){
			res= new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND, "wrong fomat param!");
 			return res;
    	}
    	
    	if (!accountMonth.isEmpty()) {
    		year = accountMonth.substring(0, 4);
            month = accountMonth.substring(4,6);
     		format.parse(accountMonth);
     		int length = accountMonth.length();
     		if (length!=6){
     			res= new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND, "monthLength!=6");
     			return res;
     		}
    	}
    	RequestParamt3005 para=new RequestParamt3005();
    	para.setAccountMonth(month);
    	para.setAgencyCode(agencyCode);
    	para.setMonth(month);
    	para.setYear(year);
    	Response3005Model response=dataReportDao.get3005Report(para);
    	log.info("日结算报表表成功");
		return response;
	}
	
	@Override
	@WebncpMethod(code = "3006")
	public BaseResponse getAgencyFlow(String reqjson) throws Exception {
		Request3006Model req=JSONObject.parseObject(reqjson,Request3006Model.class);
		BaseResponse res = null;
		if(StringUtils.isEmpty(req.getDate())){
			//res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND,"查询日期为空");
			//return res;
			req.setDate(new SimpleDateFormat("yyyyMMdd").format(new Date()));
		}
		if(StringUtils.isEmpty(req.getAgencyCode())){
			res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND,"站点编码为空");
			return res;
		}
		List<DealFlowModel> list = pilDataReportDao.getAgencyFlow3006(req);
		if(list==null || list.size()==0){
			res = new BaseResponse(WebncpErrorMessage.ERR_RECORD_NOTEXSIT,"查询结果为空");
			return res;
		}
		Response3006Model result = new Response3006Model();
		result.setRecordList(list);
		result.setCMD(req.getCMD());
		return result;
	}
	
	@Override
	@WebncpMethod(code = "3007")
	public BaseResponse getRealTimeReport(String reqJson) throws Exception {
		Request3007Model req = JSONObject.parseObject(reqJson, Request3007Model.class);
		BaseResponse res = null;
		if(StringUtils.isEmpty(req.getAgencyCode())){
			res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND,"站点编码为空");
			return res;
		}
		Response3007Model resp = dataReportDao.get3007Report(req);
		if(resp == null){
			res = new BaseResponse(WebncpErrorMessage.ERR_RECORD_NOTEXSIT,"查询结果为空");
			return res;
		}
		return resp;
	}
	
	
	
	@Override
	@WebncpMethod(code = "3008")
	public BaseResponse getDaliyReport(String reqjson) throws Exception {
		Request3008Model req = JSONObject.parseObject(reqjson, Request3008Model.class);
		BaseResponse res = null;
		if(StringUtils.isEmpty(req.getAccountDay())){
			req.setAccountDay(new SimpleDateFormat("yyyyMMdd").format(new Date()));
		}
		if(StringUtils.isEmpty(req.getAgencyCode())){
			res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND,"站点编码为空");
			return res;
		}
		Response3008Model resp = dataReportDao.get3008Report(req);
		if(resp==null){
			res = new BaseResponse(WebncpErrorMessage.ERR_RECORD_NOTEXSIT,"查询结果为空");
			return res;
		}
		return resp;
	}

	@Override
	@WebncpMethod(code = "3009")
	public BaseResponse getMonthReport(String reqjson) throws Exception {
		Request3009Model req = JSONObject.parseObject(reqjson, Request3009Model.class);
		String accountMonth = req.getAccountMonth();
		String agencyCode = req.getAgencyCode();

		BaseResponse res = new BaseResponse();

		SimpleDateFormat format = new SimpleDateFormat("yyyyMM");
		if (StringUtils.isEmpty(accountMonth)) {
			Calendar c = Calendar.getInstance();
			c.add(Calendar.MONTH, -1);
			accountMonth = format.format(c.getTime());
			req.setAccountMonth(accountMonth);
		}
		/*
		 * StringBuilder acocuntMonthq = new StringBuilder(accountMonth);
		 * acocuntMonthq.insert(4, "-");
		 */
		if (!DateUtil.mathcFomat(accountMonth, "[0-9]") || !DateUtil.mathcFomat(agencyCode, "[0-9]")) {
			res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND, "wrong fomat param!");
			return res;
		}
		Response3009Model response = dataReportDao.get3009Report(req);
		if (response == null) {
			res = new BaseResponse(WebncpErrorMessage.ERR_RECORD_NOTEXSIT, "查询结果为空");
			return res;
		}
		return response;
	}
	
	@Override
	@WebncpMethod(code = "3010")
	public BaseResponse getAccountBalance(String reqjson) throws Exception {
		Map map=JSONObject.parseObject(reqjson,Map.class);
		BaseResponse res = new BaseResponse();
		String agencyCode = (String)map.get("agencyCode");
		if(StringUtils.isEmpty(agencyCode)){
			res = new BaseResponse(WebncpErrorMessage.ERR_NOCOMMAND,"站点编码为空");
			return res;
		}
		res = pilDataReportDao.getAccountBalance(agencyCode);
		if(res==null){
			res = new BaseResponse(WebncpErrorMessage.ERR_RECORD_NOTEXSIT,"查询结果为空");
		}
		res.setCMD((Integer)map.get("CMD"));
		
		return res;
	}
	
}
 