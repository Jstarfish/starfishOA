package cls.pilottery.web.teller.controller;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.oms.business.model.OrgInfo;
import cls.pilottery.oms.business.service.AgencyService;
import cls.pilottery.oms.business.service.TerminalService;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.BaseMessageRes;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.AddTellerReq8001;
import cls.pilottery.oms.common.msg.ResetTellerPwdReq8007;
import cls.pilottery.oms.common.msg.UpdateTellerStatusReq8005;
import cls.pilottery.oms.common.service.LogService;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;
import cls.pilottery.web.teller.form.TellerForm;
import cls.pilottery.web.teller.model.Teller;
import cls.pilottery.web.teller.model.TellerStatus;
import cls.pilottery.web.teller.service.TellerService;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

@Controller
@RequestMapping("/teller")
public class TellerController {
	static Logger logger = Logger.getLogger(TellerController.class);
	@Autowired
	private TellerService tellerService;
	@Autowired
	private TerminalService terminalService;
	@Autowired
	private AgencyService agencyService;
	@Autowired
	private LogService logService;
	private Map<Integer, String> tellerTypes = EnumConfigEN.tellerTypes;
	private Map<Integer, String> tellerQueryTypes = EnumConfigEN.tellerQueryTypes;
	private Map<Integer, String> agencyStatusItems = EnumConfigEN.agencyStatusItems;
	private Map<Integer, String> tellerStatus = EnumConfigEN.tellerStatus;

	/*
	 * 准备数据-枚举定义
	 */
	@ModelAttribute("tellerTypes")
	public Map<Integer, String> tellerTypes(HttpServletRequest request) {

		if (request != null)
			this.tellerTypes = LocaleUtil.getUserLocaleEnum("tellerTypes", request);
		return tellerTypes;
		// return goodsIssuesStatus;
	}

	@ModelAttribute("tellerQueryTypes")
	public Map<Integer, String> terminalStatus(HttpServletRequest request) {
		if (request != null)
			this.tellerQueryTypes = LocaleUtil.getUserLocaleEnum("tellerQueryTypes", request);
		return tellerQueryTypes;
	}

	@ModelAttribute("agencyStatusItems")
	public Map<Integer, String> agencyStatusItems(HttpServletRequest request) {
		if (request != null)
			this.agencyStatusItems = LocaleUtil.getUserLocaleEnum("agencyStatusItems", request);
		return agencyStatusItems;
	}

	@ModelAttribute("tellerStatus")
	public Map<Integer, String> tellerStatus(HttpServletRequest request) {

		if (request != null)
			this.tellerStatus = LocaleUtil.getUserLocaleEnum("tellerStatus", request);
		return tellerStatus;
	}

	// 新增销售员
	@RequestMapping(params = "method=addTeller", method = RequestMethod.GET)
	public String addTellerGet(HttpServletRequest request, ModelMap model) throws Exception {
		String agencyCode = request.getParameter("agencycode");
		model.addAttribute("agencyCode", agencyCode);
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();

		if (agencyCode != null && !agencyCode.isEmpty()) {
			if (terminalService.verifyTellerLimitInOrgs(agencyCode)) {
				return LocaleUtil.getUserLocalePath("teller/addTeller", request);

			} else {
				logger.debug("所选区域的销售员数量已达上限，无法添加！");
				if (lg == UserLanguage.ZH) {
					model.addAttribute("system_message", "所选区域的销售员数量已达上限，无法添加！");
				} else if (lg == UserLanguage.EN) {
					model.addAttribute("system_message",
							"Number of tellers in the selected region has reached the upper limit, no adding will be done!");
				}
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		}
		
		return LocaleUtil.getUserLocalePath("teller/addTeller", request);
	}

	public String getAgencyNameByCode(String agencyCode) {
		return agencyService.getAgencyName(agencyCode);
	}

	@RequestMapping(params = "method=addTeller", method = RequestMethod.POST)
	public String addTellerPost(HttpServletRequest request, ModelMap model, @ModelAttribute("teller") Teller teller)
			throws Exception {
		try {
			teller.setTellerStatus(TellerStatus.ENABLE);
			teller.setTellerPassword(SysConstants.INIT_LOGIN_PASSWORD);
			
			logger.debug("新增销售员,执行存储过程p_teller_create");
			logger.debug(teller);
			tellerService.addTeller(teller);
			logger.debug("存储过程执行成功,Error Code:"+teller.getC_errcode()+"  ,Error Message:"+teller.getC_errmsg());
			if (teller.getC_errcode() == 0) {
				BaseMessageReq breq = new BaseMessageReq(8001, 2);
				AddTellerReq8001 req = new AddTellerReq8001();
				req.setTellerCode(teller.getTellerCode());
				req.setAgencyCode(teller.getAgencyCode());
				/*req.setTellerName(teller.getTellerName());*/
				req.setTellerType(teller.getTellerType().getValue().shortValue());
				req.setStatus(teller.getTellerStatus().getValue().shortValue());
				req.setPassword(Long.valueOf(teller.getTellerPassword()));
				// 向主机发送消息
				breq.setParams(req);
				long seq = this.logService.getNextSeq();
				breq.setMsn(seq);
				
				String json = JSONObject.toJSONString(breq);
				MessageLog msglog = new MessageLog(seq, json);
				this.logService.insertLog(msglog);
				String url = PropertiesUtil.readValue("url_host");
				logger.debug("向主机发送消息，请求内容："+json);
				String result = HttpClientUtils.postString(url, json);
				logger.debug("收到主机的响应，响应内容："+result);
				
				BaseMessageRes res = JSON.parseObject(result, BaseMessageRes.class);
				if (res !=null && res.getRc() == 0) {
					logService.updateLog(msglog);
				} else {
					return LocaleUtil.getUserLocalePath("common/errorTip", request);
				}

				return LocaleUtil.getUserLocalePath("common/successTip", request);
			} 
			model.addAttribute("system_message", teller.getC_errmsg());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);

		} catch (Exception e) {
			logger.error("新增销售员操作异常");
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		} 
	}

	@RequestMapping(params = "method=listTeller", method = RequestMethod.GET)
	public String listTeller(HttpServletRequest request, ModelMap model,@ModelAttribute("tellerForm") TellerForm tellerForm) throws Exception {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String orgCode = user.getInstitutionCode();
		tellerForm.setCuserOrg(orgCode);

		try {
			Integer count = tellerService.countTellerList(tellerForm);
			List<Teller> list = new ArrayList<Teller>();
			int pageIndex = PageUtil.getPageIndex(request);

			if (count != null && count.intValue() != 0) {
				tellerForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				tellerForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = tellerService.queryTellerList(tellerForm);
			}
			model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
			model.addAttribute("pageDataList", list);

			model.addAttribute("tellerForm", tellerForm);

			List<OrgInfo> orgList = agencyService.getOrgListByOrgCode(user.getInstitutionCode());
			model.addAttribute("orgList", orgList);
		} catch (Exception e) {
			logger.error("查询销售员出现异常");
			e.printStackTrace();
		} 
		return LocaleUtil.getUserLocalePath("teller/tellerList", request);

	}
	@RequestMapping(params="method=queryTeller")
	public String queryTeller(HttpServletRequest request, ModelMap model,@ModelAttribute("tellerForm") TellerForm tellerForm) throws Exception {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String orgCode = user.getInstitutionCode();
		tellerForm.setCuserOrg(orgCode);
		
		//query list	
		Integer count = tellerService.countTellerList(tellerForm);		
		List<Teller> list = new ArrayList<Teller>();
		int pageIndex = PageUtil.getPageIndex(request);
		if (count != null && count.intValue() != 0) {
			tellerForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			tellerForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = tellerService.queryTellerList(tellerForm);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
        model.addAttribute("pageDataList", list);
		model.addAttribute("tellerForm",tellerForm);
		List<OrgInfo> orgList = agencyService.getOrgListByOrgCode(user.getInstitutionCode());
		model.addAttribute("orgList", orgList);
		model.addAttribute("pageIndex1", pageIndex);
		return LocaleUtil.getUserLocalePath("teller/tellerList", request);
	}
	@ResponseBody
	@RequestMapping(params = "method=disableTellerByCode")
	public String disableTellerByCode(HttpServletRequest request) throws Exception {
		String message = "";

		Map<String, String> map = new HashMap<String, String>();
		try {
			Teller teller = new Teller();
			teller.setTellerStatus(TellerStatus.DISABLE);
			teller.setTellerCode(Long.valueOf(request.getParameter("tellercode")));
			
			logger.debug("禁用销售员"+request.getParameter("tellercode")+"，执行存储过程：p_teller_status_change,");
			this.tellerService.updateStatus(teller);
			logger.debug("存储过程执行完毕,执行结果Error Code:"+teller.getC_errcode()+",Error Message:"+teller.getC_errmsg());
			
			if (teller.getC_errcode() == 0) {
				BaseMessageReq breq = new BaseMessageReq(8005, 2);
				// 向主机发送消息
				UpdateTellerStatusReq8005 req = new UpdateTellerStatusReq8005();
				long seq = this.logService.getNextSeq();
				
				req.setTellerCode(teller.getTellerCode());
				req.setStatus(teller.getTellerStatus().getValue().shortValue());
				breq.setMsn(seq);
				breq.setParams(req);
				String url = PropertiesUtil.readValue("url_host");
				String json = JSONObject.toJSONString(breq);
				MessageLog msglog = new MessageLog(seq, json);
				this.logService.insertLog(msglog);
				logger.debug("向主机发送消息，请求内容："+json);
				String result = HttpClientUtils.postString(url, json);
				logger.debug("收到主机的响应，消息内容："+result);
				BaseMessageRes res = JSON.parseObject(result, BaseMessageRes.class);

				if (res != null && res.getRc() == 0) {
					logService.updateLog(msglog);
				} else {
					logger.error("消息执行失败！");
				}
			} else {
				if (LocaleUtil.isChinese(request)) {
					message = "禁用销售员失败！";
				} else {
					message = "Failed to disable this teller!";
				}
				logger.error("禁用销售员失败！");
			}

			map.put("reservedSuccessMsg", message);
			return JSONArray.toJSONString(map);
		} catch (Exception e) {
			if (LocaleUtil.isChinese(request)) {
				message = "禁用销售员操作异常！";
			} else {
				message = "Exception occurred when disabling this teller!";
			}
			logger.error("禁用销售员操作异常！");
			e.printStackTrace();

			map.put("reservedSuccessMsg", message);
			return JSONArray.toJSONString(map);
		} 
	}
	
	@ResponseBody
	@RequestMapping(params="method=deleteTellerByCode")
	public String deleteTellerByCode(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		String message = "";
		//记录日志
		Map<String, String> map = new HashMap<String, String>();
		try {
			Teller teller = new Teller();
			teller.setTellerStatus(TellerStatus.DELETED);
			teller.setTellerCode(Long.valueOf(request.getParameter("tellercode")));

			tellerService.deleteTeller(teller);//普通sql
			
			BaseMessageReq breq = new BaseMessageReq(8005, 2);
			// 向主机发送消息
			UpdateTellerStatusReq8005 req = new UpdateTellerStatusReq8005();
			breq.setParams(req);
			long seq = this.logService.getNextSeq();
			req.setTellerCode(teller.getTellerCode());
			req.setStatus(teller.getTellerStatus().getValue().shortValue());
			breq.setMsn(seq);
			breq.setParams(req);
			
			String url = PropertiesUtil.readValue("url_host");
			String json = JSONObject.toJSONString(breq);
			MessageLog msglog = new MessageLog(seq, json);
			this.logService.insertLog(msglog);
			logger.debug("向主机发送消息，请求内容："+json);
			String result = HttpClientUtils.postString(url, json);
			logger.debug("收到主机的响应，消息内容："+result);
			BaseMessageRes res = JSON.parseObject(result, BaseMessageRes.class);

			if (res != null && res.getRc() == 0) {
				logService.updateLog(msglog);
			} else {
				logger.error("消息执行失败！");
				if (LocaleUtil.isChinese(request)) {
					message = "删除销售员失败！";
				} else {
					message = "Operation Failed!";
				}
			}
			
			map.put("reservedSuccessMsg", message);
			return JSONArray.toJSONString(map);
		} catch (Exception e) {
			if (lg == UserLanguage.ZH) {
				message = "删除销售员失败！";
			} else if (lg == UserLanguage.EN) {
				message = " Failed to delete the teller!";
			}
			e.printStackTrace();
			logger.error(message);
			
			map.put("reservedSuccessMsg", message);
			return JSONArray.toJSONString(map);
		}
	}
	@ResponseBody
	@RequestMapping(params="method=enableTellerByCode")
	public String enableTellerByCode(HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		
		String message = "";
		Map<String, String> map = new HashMap<String, String>();
		try {
			Teller teller = new Teller();
			teller.setTellerStatus(TellerStatus.ENABLE);
			teller.setTellerCode(Long.valueOf(request.getParameter("tellercode")));

			logger.debug("启用销售员"+request.getParameter("tellercode")+"，执行存储过程：p_teller_status_change,");
			this.tellerService.updateStatus(teller);
			logger.debug("存储过程执行完毕,执行结果Error Code:"+teller.getC_errcode()+",Error Message:"+teller.getC_errmsg());
			
			if (teller.getC_errcode()==0) {
				BaseMessageReq breq = new BaseMessageReq(8005, 2);
				// 向主机发送消息
				UpdateTellerStatusReq8005 req = new UpdateTellerStatusReq8005();
				long seq = this.logService.getNextSeq();
				req.setTellerCode(teller.getTellerCode());
				req.setStatus(teller.getTellerStatus().getValue().shortValue());
				breq.setMsn(seq);
				breq.setParams(req);
				String json = JSONObject.toJSONString(breq);
				MessageLog msglog = new MessageLog(seq, json);
				this.logService.insertLog(msglog);
				String url = PropertiesUtil.readValue("url_host");
				
				logger.debug("向主机发送消息，请求内容："+json);
				String result = HttpClientUtils.postString(url, json);
				logger.debug("收到主机的响应，消息内容："+result);
				BaseMessageRes res = JSON.parseObject(result, BaseMessageRes.class);

				if (res != null && res.getRc() == 0) {
					logService.updateLog(msglog);
				} else {
					logger.error("消息执行失败！");
					if (LocaleUtil.isChinese(request)) {
						message = "启用销售员成功！";
					} else {
						message = "Operation Failed!";
					}
				}
				
				map.put("reservedSuccessMsg", message);
				return JSONArray.toJSONString(map);
			} else {
				logger.error("启用销售员失败！");
			}
		
			map.put("reservedSuccessMsg", message);
			return JSONArray.toJSONString(map);
		} catch (Exception e) {
			if (lg == UserLanguage.ZH) {
				message = "启用销售员操作异常！";
			} else if (lg == UserLanguage.EN) {
				message = "Exception occurred when enabling this teller！";
			}
			
			map.put("reservedSuccessMsg", message);
			return JSONArray.toJSONString(map);
		} 
	}
	//修改销售员
	@RequestMapping(params="method=editTeller", method=RequestMethod.GET)
	public String editTellerSetup(HttpServletRequest request, ModelMap model) throws Exception {
		String codeString = request.getParameter("tellercode");
		Long tellerCode = Long.valueOf(codeString);
		
		String tellerCodeToChar = request.getParameter("tellerCodeToChar");
		model.addAttribute("tellerCodeToChar", tellerCodeToChar);
		
		Teller teller = tellerService.getTellerByCode(tellerCode);
		model.addAttribute("teller", teller);
		return LocaleUtil.getUserLocalePath("teller/editTeller", request);
	
	}
	@RequestMapping(params="method=editTeller", method=RequestMethod.POST)
	public String editTellerPost(HttpServletRequest request, ModelMap model,@ModelAttribute("teller") Teller teller) throws Exception {
	
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		String message = "";
		try {
			
			tellerService.updateTeller(teller);//这是普通sql

			BaseMessageReq breq = new BaseMessageReq(8001, 2);
			AddTellerReq8001 req  = new AddTellerReq8001();
			long seq = this.logService.getNextSeq();
			req.setTellerCode(teller.getTellerCode());
			req.setTellerType(teller.getTellerType().getValue().shortValue());
			req.setPassword(new Long(teller.getTellerPassword()));
			req.setAgencyCode(teller.getAgencyCode());
			breq.setParams(req);
			breq.setMsn(seq);
			String json = JSONObject.toJSONString(breq);
			MessageLog msglog = new MessageLog(seq, json);
			this.logService.insertLog(msglog);
			String url = PropertiesUtil.readValue("url_host");
			
			logger.debug("向主机发送消息，请求内容："+json);
			String result = HttpClientUtils.postString(url, json);
			logger.debug("收到主机的响应，消息内容："+result);
			BaseMessageRes res = JSON.parseObject(result, BaseMessageRes.class);

			if (res != null && res.getRc() == 0) {
				if (lg == UserLanguage.ZH) {
					message = "修改销售员成功";
				} else if (lg == UserLanguage.EN) {
					message = "Teller information is successfully edited!";
				}
				logService.updateLog(msglog);
			} else {
				if (lg == UserLanguage.ZH) {
					message = "修改销售员失败";
				} else if (lg == UserLanguage.EN) {
					message = "The operation is failed!";
				}
				logger.error("消息执行失败！");
				model.addAttribute("system_message",message );
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
			
			model.addAttribute("reservedHrefURL", "teller.do?method=listTeller");
			return LocaleUtil.getUserLocalePath("common/successTip", request);
			
		} catch (Exception e) {
			logger.error("修改销售员失败！");
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		} 
	}
	
	@ResponseBody
	@RequestMapping(params="method=resetPasswordByCode")
	public String resetPasswordByCode(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		String message = "";
		Map<String, String> map = new HashMap<String, String>();
		try {
			Teller teller = new Teller();
			teller.setTellerPassword(SysConstants.INIT_TRANS_PASSWORD);
			teller.setTellerCode(Long.valueOf(request.getParameter("tellercode")));
			tellerService.resetPassword(teller);

			BaseMessageReq breq = new BaseMessageReq(8007, 2);
			ResetTellerPwdReq8007 req = new ResetTellerPwdReq8007();
			long seq = this.logService.getNextSeq();
			req.setTellerCode(teller.getTellerCode());
			req.setPassword(Long.parseLong(teller.getTellerPassword()));
			breq.setParams(req);
			breq.setMsn(seq);
			String json = JSONObject.toJSONString(breq);
			MessageLog msglog = new MessageLog(seq, json);
			this.logService.insertLog(msglog);
			String url = PropertiesUtil.readValue("url_host");
			
			logger.debug("向主机发送消息，请求内容："+json);
			String result = HttpClientUtils.postString(url, json);
			logger.debug("收到主机的响应，消息内容："+result);
			BaseMessageRes res = JSON.parseObject(result, BaseMessageRes.class);

			if (res != null && res.getRc() == 0) {
				logService.updateLog(msglog);
			} else {
				if (lg == UserLanguage.ZH) {
					message = "充值销售员密码失败";
				} else if (lg == UserLanguage.EN) {
					message = "The operation is failed!";
				}
				logger.error("消息执行失败！");
			}
			
			map.put("reservedSuccessMsg", message);
			return JSONArray.toJSONString(map);
			
		} catch (Exception e) {
			logger.error("重置销售员密码异常！");
			e.printStackTrace();
			map.put("reservedSuccessMsg", message);
			return JSONArray.toJSONString(map);
		}
	}
}
