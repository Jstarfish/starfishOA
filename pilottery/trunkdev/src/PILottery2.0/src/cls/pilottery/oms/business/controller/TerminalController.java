package cls.pilottery.oms.business.controller;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.common.utils.SpringContextUtil;
import cls.pilottery.oms.business.form.TerminalForm;
import cls.pilottery.oms.business.model.OrgInfo;
import cls.pilottery.oms.business.model.Terminal;
import cls.pilottery.oms.business.model.TerminalStatus;
import cls.pilottery.oms.business.model.TerminalType;
import cls.pilottery.oms.business.model.TerminalYesNoType;
import cls.pilottery.oms.business.service.AgencyService;
import cls.pilottery.oms.business.service.TerminalService;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.BaseMessageRes;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.AddTerminalReq7001;
import cls.pilottery.oms.common.msg.UpdateTerminalStatusReq7005;
import cls.pilottery.oms.common.service.LogService;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;

@Controller
@RequestMapping("/terminal")
public class TerminalController {
	static Logger logger = Logger.getLogger(TerminalController.class);
	
	@Autowired
	private TerminalService terminalService;
	
	@Autowired
	private AgencyService agencyService;

	@Autowired
	private LogService logService;
	
	private Map<Integer, String> terminalStatusForm = EnumConfigEN.terminalStatusForm;
	private Map<Integer, String> trainingmode = EnumConfigEN.trainingmode;
	private Map<Integer, String> terminalQueryTypes = EnumConfigEN.terminalQueryTypes;
	private static List<TerminalType> terminalTypes;

	@ModelAttribute("terminalStatusForm")
	public Map<Integer, String> getTerminalStatusForm(HttpServletRequest request) {
		if (request != null)
			this.terminalStatusForm = LocaleUtil.getUserLocaleEnum("terminalStatusForm", request);
		return terminalStatusForm;
	}
	
	@ModelAttribute("trainingmode")
	public Map<Integer, String> trainingmode(HttpServletRequest request) {
		if (request != null)
			this.trainingmode = LocaleUtil.getUserLocaleEnum("trainingmode", request);
		return trainingmode;
	}
	
	@ModelAttribute("terminalQueryTypes")
	public Map<Integer, String> terminalQueryTypes(HttpServletRequest request) {
		if (request != null)
			this.terminalQueryTypes = LocaleUtil.getUserLocaleEnum("terminalQueryTypes", request);
		return terminalQueryTypes;
	}

	static {
		terminalTypes = new ArrayList<TerminalType>();
		terminalTypes.add(new TerminalType(1));
		//terminalTypes.add(new TerminalType(2));
	}
	
	//发送消息给主机的helper function
	private void sendMessageToHost(int func, Object params) {
		BaseMessageReq req = new BaseMessageReq(func, 2);
		req.setParams(params);
		long seq = logService.getNextSeq();
		req.setMsn(seq);
		String reqJson = JSONObject.toJSONString(req);
		logger.debug("向主机发送请求，请求内容："+reqJson);
		MessageLog msglog = new MessageLog(seq, reqJson);
		logService.insertLog(msglog);
		String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), reqJson);
		logger.debug("接收到主机的响应，消息内容："+resJson);
		if (resJson != null) {
			BaseMessageRes res = JSONObject.parseObject(resJson,BaseMessageRes.class);
			if (res.getRc() != 0) {
				logService.updateLog(msglog);
			}
		}
	}

	/**
	 * 
	 * @Title: addTerminalGet
	 * @Description: 新增销售终端
	 * @param @param request
	 * @param @param model
	 * @param @return
	 * @param @throws Exception 参数
	 * @return String 返回类型
	 * @throws
	 */
	// 新增销售终端
	@RequestMapping(params = "method=addTerminal", method = RequestMethod.GET)
	public String addTerminalGet(HttpServletRequest request, ModelMap model) throws Exception {
		
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		
		UserLanguage lg = user.getUserLang();
		Terminal tm = new Terminal();
		
		String agencyCode = request.getParameter("agencycode");
		model.addAttribute("agencyCode", agencyCode);
		model.addAttribute("terminalTypes", terminalTypes);
		
		if (agencyCode != null && !agencyCode.isEmpty()) {
			String recomendId = terminalService.recomandNum(agencyCode); 
			String preRecomendId = "";// 前八位
			String afRecomendId = "";// 后两位
			preRecomendId = recomendId.substring(0, recomendId.length() - 2);
			afRecomendId = recomendId.substring(recomendId.length() - 2);
			model.addAttribute("preRecomendId", preRecomendId);
			model.addAttribute("afRecomendId", afRecomendId);

			String agencyName = getAgencyNameByCode(agencyCode);
			if (terminalService.verifyTerminalLimitInCity(agencyCode)) {
				model.addAttribute("terminal", tm);
				model.addAttribute("paramAgencyName", agencyName);

				return LocaleUtil.getUserLocalePath("oms/terminal/addTerminal", request);
			} else {
				String message = "";
				if (lg == UserLanguage.ZH) {
					message = "所选区域的终端机数量已达上限，无法添加！";
				} else if (lg == UserLanguage.EN) {
					message = "Number of terminals in the selected region has reached the upper limit, no adding will be done!";
				}

				model.addAttribute("system_message", message);
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		}
		return LocaleUtil.getUserLocalePath("oms/terminal/addTerminal", request);
	}

	public String getAgencyNameByCode(String agencyCode) {
		return agencyService.getAgencyName(agencyCode);
	}

	/**
	 * 
	 * @Title: addTerminalPost
	 * @Description: 增加终端机
	 * @param @param request
	 * @param @param model
	 * @param @param terminal
	 * @param @return
	 * @param @throws Exception 参数
	 * @return String 返回类型
	 * @throws
	 */
	@RequestMapping(params = "method=addTerminal", method = RequestMethod.POST)
	public String addTerminalPost(HttpServletRequest request, ModelMap model, @ModelAttribute("terminal") Terminal terminal) throws Exception {

		try {
			terminal.setForPayment(new TerminalYesNoType(1));
			terminal.setEnableTellerLogon(new TerminalYesNoType(1));

			terminalService.addTerminal(terminal);
			if (terminal.getC_errcode() == 0) {
				AddTerminalReq7001 paramReq = new AddTerminalReq7001();
				paramReq.setTermCode(terminal.getTerminalCode());
				paramReq.setAgencyCode(terminal.getAgencyParent().getCode());
				paramReq.setTermMac(terminal.getMacAddress());
				paramReq.setUniqueCode(terminal.getUniqueCode());
				paramReq.setStatus(terminal.getTerminalStatus().getValue().shortValue());
				paramReq.setMachineModel(terminal.getTerminalType().shortValue());
				paramReq.setIsTrain(terminal.getTrainingMode().getValue().shortValue());
				sendMessageToHost(7001, paramReq);
				
				return LocaleUtil.getUserLocalePath("common/successTip", request);
			} else {
				logger.error("errmsgs:" + terminal.getC_errmsg());
				model.addAttribute("system_message", terminal.getC_errmsg());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			logger.error("errmsgs: " + e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}

	/**
	 * 判断是否MAC地址重复：1为重复
	 * 
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(params = "method=isRepeatedMacId")
	public String isRepeatedMacId(HttpServletRequest request) {
		String flag = "0";
		String macAddress = request.getParameter("macAddress");
		Integer count = terminalService.selectSameMacCount(macAddress);
		if (count.intValue() > 0) {
			flag = "1";
		}
		return flag;
	}

	@ResponseBody
	@RequestMapping(params = "method=getTerminalCode")
	public String getTerminalCode(HttpServletRequest request) {
		String recomendId = "";// 推荐码
		String agencyCode = request.getParameter("agencyCode");
		if (agencyCode != null) {
			recomendId = terminalService.recomandNum(agencyCode);
		}

		return recomendId;
	}

	// list
	@RequestMapping(params = "method=listTerminal", method = RequestMethod.GET)
	public String listTerminal(HttpServletRequest request, ModelMap model, @ModelAttribute("terminalForm") TerminalForm terminalForm) throws Exception {
		
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);

		terminalForm.setAreaCode(user.getInstitutionCode());

		Integer count = terminalService.countTerminalList(terminalForm);
		List<Terminal> list = new ArrayList<Terminal>();

		int pageIndex = PageUtil.getPageIndex(request);

		if (count != null && count.intValue() != 0) {
			terminalForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			terminalForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = terminalService.queryTerminalList(terminalForm);
		}
		updateTerminalTypeName(list);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);

		List<OrgInfo> orgList = agencyService.getOrgListByOrgCode(user.getInstitutionCode());
		model.addAttribute("orgList", orgList);
		model.addAttribute("pageIndex1", pageIndex);

		return LocaleUtil.getUserLocalePath("oms/terminal/terminalList", request);
	}

	@RequestMapping(params = "method=queryTerminal", method = RequestMethod.POST)
	public String queryTerminal(HttpServletRequest request, ModelMap model, @ModelAttribute("terminalForm") TerminalForm terminalForm) throws Exception {
		terminalForm.beforeQuery();

		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);

		terminalForm.setAreaCode(user.getInstitutionCode());

		Integer count = terminalService.countTerminalList(terminalForm);
		List<Terminal> list = new ArrayList<Terminal>();
		int pageIndex = PageUtil.getPageIndex(request);
		if (count != null && count.intValue() != 0) {
			terminalForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			terminalForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = terminalService.queryTerminalList(terminalForm);
		}
		updateTerminalTypeName(list);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);

		model.addAttribute("terminalForm", terminalForm);
		List<OrgInfo> orgList = agencyService.getOrgListByOrgCode(user.getInstitutionCode());
		model.addAttribute("orgList", orgList);
		model.addAttribute("pageIndex1", pageIndex);
		return LocaleUtil.getUserLocalePath("oms/terminal/terminalList", request);
	}

	private void updateTerminalTypeName(List<Terminal> list) {
		if (terminalTypes == null) {
			terminalTypes = new ArrayList<TerminalType>();
			terminalTypes.add(new TerminalType(1));
			terminalTypes.add(new TerminalType(2));
		}
		for (Terminal term : list) {
			term.setTerminalTypeName(searchTypeName(term.getTerminalType()));
		}
	}

	private String searchTypeName(Integer type) {
		String str = type.toString();
		for (int i = 0; i < terminalTypes.size(); i++) {
			if (type.intValue() == terminalTypes.get(i).getTypeCode().intValue()) {
				str = terminalTypes.get(i).getTypeName();
				break;
			}
		}
		return str;
	}

	@ResponseBody
	@RequestMapping(params = "method=disableTerminalByCode")
	public String disableTerminalByCode(HttpServletRequest request) throws Exception {

		Map<String, String> map = new HashMap<String, String>();
		try {
			Terminal terminal = new Terminal();
			terminal.setTerminalStatus(TerminalStatus.DISABLE);
			terminal.setTerminalCode(request.getParameter("terminalcode"));
			terminalService.updateStatus(terminal);
			if (terminal.getC_errcode() == 0) {
				UpdateTerminalStatusReq7005 paramReq = new UpdateTerminalStatusReq7005();
				paramReq.setTermCode(terminal.getTerminalCode());
				paramReq.setStatus(terminal.getTerminalStatus().getValue());
				sendMessageToHost(7005, paramReq);

				map.put("reservedSuccessMsg", "");
				return JSONArray.toJSONString(map);
			} else {
				logger.error("errmsgs:" + terminal.getC_errmsg());
				map.put("reservedSuccessMsg", URLEncoder.encode(SpringContextUtil.getMessage("terminal.fail", request), "utf-8"));
				return JSONArray.toJSONString(map);
			}
		} catch (Exception e) {
			logger.error("errmsgs: " + e.getMessage());
			map.put("reservedSuccessMsg", URLEncoder.encode(e.getMessage(), "utf-8"));
			return JSONArray.toJSONString(map);
		}
	}

	@ResponseBody
	@RequestMapping(params = "method=returnTerminalByCode")
	public String returnTerminalByCode(HttpServletRequest request) throws Exception {

		Map<String, String> map = new HashMap<String, String>();
		try {
			Terminal terminal = new Terminal();
			terminal.setTerminalStatus(TerminalStatus.RETURNED);
			terminal.setTerminalCode(request.getParameter("terminalcode"));
			terminalService.updateStatus(terminal);
			if (terminal.getC_errcode() == 0) {
				UpdateTerminalStatusReq7005 paramReq = new UpdateTerminalStatusReq7005();
				paramReq.setTermCode(terminal.getTerminalCode());
				paramReq.setStatus(terminal.getTerminalStatus().getValue());
				sendMessageToHost(7005, paramReq);

				map.put("reservedSuccessMsg", "");
				return JSONArray.toJSONString(map);
			} else {
				logger.error("errmsgs:" + terminal.getC_errmsg());
				map.put("reservedSuccessMsg", URLEncoder.encode(SpringContextUtil.getMessage("terminal.fail", request), "utf-8"));
				return JSONArray.toJSONString(map);
			}
		} catch (Exception e) {
			logger.error("errmsgs: " + e.getMessage());
			map.put("reservedSuccessMsg", URLEncoder.encode(e.getMessage(), "utf-8"));
			return JSONArray.toJSONString(map);
		}
	}

	// 修改销售终端
	@RequestMapping(params = "method=editTerminal", method = RequestMethod.GET)
	public String editTerminalSetup(HttpServletRequest request, ModelMap model) throws Exception {
		String codeString = request.getParameter("terminalcode");
		Long code = Long.valueOf(codeString);

		Terminal terminal = terminalService.getTerminalByCode(code);

		model.addAttribute("terminal", terminal);
		return LocaleUtil.getUserLocalePath("oms/terminal/editTerminal", request);

	}

	@RequestMapping(params = "method=editTerminal", method = RequestMethod.POST)
	public String editTerminalPost(HttpServletRequest request, ModelMap model, @ModelAttribute("terminal") Terminal terminal) throws Exception {
		
		try {
			terminalService.updateTerminal(terminal);
			if (terminal.getC_errcode() == 0) {
				AddTerminalReq7001 paramReq = new AddTerminalReq7001();
				paramReq.setTermCode(terminal.getTerminalCode());
				paramReq.setTermMac(terminal.getMacAddress());
				paramReq.setUniqueCode(terminal.getUniqueCode());
				paramReq.setMachineModel(terminal.getTerminalType());
				paramReq.setAgencyCode(terminal.getAgencyCode());
				paramReq.setIsTrain(terminal.getTrainingMode().getValue());
				sendMessageToHost(7001, paramReq);

				return LocaleUtil.getUserLocalePath("common/successTip", request);
			} else {
				logger.error("errmsgs:" + terminal.getC_errmsg());
				model.addAttribute("system_message", terminal.getC_errmsg());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			logger.error("errmsgs: " + e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}

	// get types
	@RequestMapping(params = "method=terminaltypes", method = RequestMethod.GET)
	public String getTerminalTypes(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		if (terminalTypes == null) {
			terminalTypes = terminalService.selectTerminalTypes();
		}
		String jsonStr = listToJsonStr(terminalTypes);
		response.setContentType("application/json;charset=UTF-8");

		response.getWriter().print(jsonStr);
		response.getWriter().flush();
		response.getWriter().close();

		return null;
	}

	private String listToJsonStr(List<TerminalType> list) {
		StringBuffer sb = new StringBuffer(512);
		sb.append("{\"parentlist\":[");
		for (int i = 0; i < list.size(); i++) {
			sb.append(" {\"name\":\" ");
			sb.append(list.get(i).getTypeName());
			sb.append(" \" ,\"code\": ");
			sb.append(list.get(i).getTypeCode());
			sb.append("}");
			if (i != (list.size() - 1))
				sb.append(",");
		}
		sb.append("]}");

		return sb.toString();
	}

	@ResponseBody
	@RequestMapping(params = "method=enableTerminalByCode")
	public String enableTerminalByCode(HttpServletRequest request) throws Exception {

		Map<String, String> map = new HashMap<String, String>();
		try {
			Terminal terminal = new Terminal();
			terminal.setTerminalStatus(TerminalStatus.ENABLE);
			terminal.setTerminalCode(request.getParameter("terminalcode"));
			terminalService.updateStatus(terminal);
			if (terminal.getC_errcode() == 0) {
				UpdateTerminalStatusReq7005 paramReq = new UpdateTerminalStatusReq7005();
				paramReq.setTermCode(terminal.getTerminalCode());
				paramReq.setStatus(terminal.getTerminalStatus().getValue());
				sendMessageToHost(7005, paramReq);

				map.put("reservedSuccessMsg", "");
				return JSONArray.toJSONString(map);
			} else {
				logger.error("errmsgs:" + terminal.getC_errmsg());
				map.put("reservedSuccessMsg", URLEncoder.encode(SpringContextUtil.getMessage("terminal.fail", request), "utf-8"));
				return JSONArray.toJSONString(map);
			}
		} catch (Exception e) {
			logger.error("errmsgs: " + e.getMessage());
			map.put("reservedSuccessMsg", URLEncoder.encode(e.getMessage(), "utf-8"));
			return JSONArray.toJSONString(map);
		}
	}
}