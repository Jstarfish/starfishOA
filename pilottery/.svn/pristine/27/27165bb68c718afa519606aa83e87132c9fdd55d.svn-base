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

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.HttpClientUtils;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.common.utils.PropertiesUtil;
import cls.pilottery.oms.business.form.AgencyForm;
import cls.pilottery.oms.business.model.Agency;
import cls.pilottery.oms.business.model.AgencyBank;
import cls.pilottery.oms.business.model.AgencyRefunVo;
import cls.pilottery.oms.business.model.AgencyStatus;
import cls.pilottery.oms.business.model.OrgInfo;
import cls.pilottery.oms.business.model.ShopType;
import cls.pilottery.oms.business.service.AgencyService;
import cls.pilottery.oms.common.entity.BaseMessageReq;
import cls.pilottery.oms.common.entity.BaseMessageRes;
import cls.pilottery.oms.common.entity.MessageLog;
import cls.pilottery.oms.common.msg.AgencyGameAuthReq5007;
import cls.pilottery.oms.common.msg.QytvAgencyReq6009;
import cls.pilottery.oms.common.msg.UpdateAgencyStatusReq6005;
import cls.pilottery.oms.common.service.LogService;
import cls.pilottery.web.area.model.Areas;
import cls.pilottery.web.area.model.GameAuth;
import cls.pilottery.web.area.model.GameAuthArray;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

@Controller
@RequestMapping("/agency")
public class AgencyController {
	static Logger logger = Logger.getLogger(AgencyController.class);
	@Autowired
	private AgencyService agencyService;
	@Autowired
	private LogService logService;

	private Map<Integer, String> agencyStatusItems = EnumConfigEN.agencyStatusItems;

	@ModelAttribute("shopTypes")
	public List<ShopType> populateShopTypes() {
		List<ShopType> types = new ArrayList<ShopType>();

		types.add(new ShopType(1, "店面类型1"));
		types.add(new ShopType(2, "店面类型2"));
		types.add(new ShopType(3, "店面类型3"));

		return types;
	}

	@ModelAttribute("agencyStatusItems")
	public Map<Integer, String> populateAgencyStatuses(HttpServletRequest request) {
		if (request != null)
			this.agencyStatusItems = LocaleUtil.getUserLocaleEnum("agencyStatusItems", request);
		return agencyStatusItems;

	}

	@ModelAttribute("agencyBanks")
	public List<AgencyBank> populateAgencyBanks() {
		List<AgencyBank> banks = agencyService.getBanks();

		return banks;
	}

	@RequestMapping(params = "method=banklist", method = RequestMethod.GET)
	public String getAgencyBanks(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
		List<AgencyBank> banks = agencyService.getBanks();

		String jsonStr = listToJsonStr(banks);
		response.setContentType("application/json;charset=UTF-8");
		response.getWriter().print(jsonStr);
		response.getWriter().flush();
		response.getWriter().close();

		return null;
	}

	private String listToJsonStr(List<AgencyBank> list) {
		StringBuffer sb = new StringBuffer(512);
		sb.append("{\"parentlist\":[");
		for (int i = 0; i < list.size(); i++) {
			sb.append(" {\"name\":\" ");
			sb.append(list.get(i).getBankName());
			sb.append(" \" ,\"code\": ");
			sb.append(list.get(i).getBankId());
			sb.append("}");
			if (i != (list.size() - 1))
				sb.append(",");
		}
		sb.append("]}");

		return sb.toString();
	}

	public String getAgencyNameByCode(String agencyCode) {

		return agencyService.getAgencyName(agencyCode);
	}

	@RequestMapping(params = "method=listAgency")
	public String listAgency(HttpServletRequest request, ModelMap model,AgencyForm agencyForm) throws Exception {
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String cuserOrg = currentUser.getInstitutionCode();
		//agencyForm.setAreaCode(cuserOrg);
		agencyForm.setCuserOrg(cuserOrg);
		List<AgencyBank> listbanks = this.agencyService.getBanks();
		model.addAttribute("listbanks", listbanks);
		model.addAttribute("agencyForm", agencyForm);

		Integer count = agencyService.countAgencyList(agencyForm);
		List<Agency> list = new ArrayList<Agency>();
		int pageIndex = PageUtil.getPageIndex(request);

		if (count != null && count.intValue() != 0) {
			agencyForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			agencyForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = agencyService.queryAgencyList(agencyForm);
		}

		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);

		List<OrgInfo> orgList = agencyService.getOrgListByOrgCode(currentUser.getInstitutionCode());
		model.addAttribute("orgList", orgList);
		return LocaleUtil.getUserLocalePath("oms/agency/agencyList", request);

	}

	@ResponseBody
	@RequestMapping(params = "method=disableAgencyByCode")
	public String disableAgencyByCode(HttpServletRequest request) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		try {
			String agencycode = request.getParameter("agencycode");
			Agency agency = new Agency();
			agency.setAgencyStatus(AgencyStatus.DISABLE);
			agency.setAgencyCode(agencycode);
			agencyService.updateStatus(agency);
			// 向主机发送消息
			UpdateAgencyStatusReq6005 updateAgencyStatusReq = new UpdateAgencyStatusReq6005();
			updateAgencyStatusReq.setAgencyCode(agency.getAgencyCode());
			updateAgencyStatusReq.setStatus(AgencyStatus.DISABLE.getValue().shortValue());
			BaseMessageReq req = new BaseMessageReq(6005, 2);
			req.setParams(updateAgencyStatusReq);
			long seq = this.logService.getNextSeq();
			req.setMsn(seq);
			String reqJson = JSONObject.toJSONString(req);

			MessageLog msglog = new MessageLog(seq, reqJson);
			this.logService.insertLog(msglog);

			logger.debug("向主机发送请求，请求内容："+reqJson);
			String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), reqJson);
			logger.debug("接收到主机的响应，消息内容："+resJson);
			
			BaseMessageRes res = JSON.parseObject(resJson, BaseMessageRes.class);
			int status = res.getRc();

			if (status == 0) {

				if (lg == UserLanguage.ZH) {
					String message = "成功";
					map.put("system_message", URLEncoder.encode(message, "utf-8"));

				} else if (lg == UserLanguage.EN) {
					String message = "Sucess";
					map.put("system_message", URLEncoder.encode(message, "utf-8"));
				}

				return JSONArray.toJSONString(map);
			} else {
				String message = agency.getC_errmsg();
				map.put("system_message", URLEncoder.encode(message, "utf-8"));
				return JSONArray.toJSONString(map);
			}
		} catch (Exception e) {
			if (lg == UserLanguage.ZH) {
				String message = "失败";
				map.put("system_message", URLEncoder.encode(message, "utf-8"));

			} else if (lg == UserLanguage.EN) {
				String message = "Failed";
				map.put("system_message", URLEncoder.encode(message, "utf-8"));
			}

			return JSONArray.toJSONString(map);
		}
	}

	@RequestMapping(params = "method=returnAgency", method = RequestMethod.GET)
	public String returnAgencySetup(HttpServletRequest request, ModelMap model) throws Exception {
		String codeString = request.getParameter("agencycode");
		String nameString = getAgencyNameByCode(codeString);

		String agencyCodeTochar = request.getParameter("agencyCodeTochar");
		model.addAttribute("agencyCodeTochar", agencyCodeTochar);
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		Agency agency = new Agency();
		agency.setAgencyCode(codeString);
		agency.setAgencyName(nameString);

		try {
			agency.setAgencyStatus(AgencyStatus.RETURNED);
			BaseMessageReq breq = new BaseMessageReq(6009, 2);
			QytvAgencyReq6009 req = new QytvAgencyReq6009();
			req.setAgencyCode(agency.getAgencyCode());
			req.setAuditCode(0);
			req.setUserId(user.getId().intValue());
			breq.setParams(req);
			long seq = this.logService.getNextSeq();
			breq.setMsn(seq);
			String json = JSONObject.toJSONString(breq);

			Integer telcount = this.agencyService.getSalerTellerByAgencode(agency.getAgencyCode());
			Integer temcount = this.agencyService.getSalerTermByAgenCode(agency.getAgencyCode());

			MessageLog msglog = new MessageLog(seq, json);
			this.logService.insertLog(msglog);
			if (telcount == 0 || temcount == 0) {
				logger.debug("清退销售站------------------------");
				logger.debug("向主机发送请求，请求内容："+json);
				String resJson = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), json);
				logger.debug("接收到主机的响应，消息内容："+resJson);
				
				BaseMessageRes res = JSON.parseObject(resJson, BaseMessageRes.class);
				int status = res.getRc();
				if (status != 0) {

					if (lg == UserLanguage.ZH) {
						logger.debug("清退销售站失败!");
						model.addAttribute("system_message", "清退销售站失败!");

					} else if (lg == UserLanguage.EN) {
						logger.debug("Failed to remove this agency!");
						model.addAttribute("system_message", "Failed to remove this agency!");
					}
					// ResustUtil.getModelMap(status, model);
					return LocaleUtil.getUserLocalePath("common/errorTip", request);

				} else {
					if (lg == UserLanguage.ZH) {
						logger.debug("成功!");
						model.addAttribute("system_message", "成功!");

					} else if (lg == UserLanguage.EN) {
						logger.debug("Sucess!");
						model.addAttribute("system_message", "Sucess");
					}

					return "redirect:agency.do?method=getRefunce&agencyCode=" + agency.getAgencyCode();

				}
			} else {

				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			if (lg == UserLanguage.ZH) {
				logger.debug("清退销售站失败!");
				model.addAttribute("system_message", "清退销售站失败!");

			} else if (lg == UserLanguage.EN) {
				logger.debug("Failed to remove this agency!");
				model.addAttribute("system_message", "Failed to remove this agency!");
			}
			// ResustUtil.getModelMap(status, model);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);

		}
	}

	// game authen
	@RequestMapping(params = "method=gameAuthen", method = RequestMethod.GET)
	public String gameAuthenSetup(HttpServletRequest request, ModelMap model) throws Exception {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String agencyCode = request.getParameter("agencycode");
		String areaCode = user.getInstitutionCode();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("agencyCode", agencyCode);
		map.put("areaCode", areaCode);

		List<GameAuth> games2 = this.agencyService.selectGameFromAgencymap(map);
		model.addAttribute("games", games2);
		model.addAttribute("areaCode", areaCode);
		model.addAttribute("agencyCode", agencyCode);
		return LocaleUtil.getUserLocalePath("oms/agency/agencyAuth", request);
	}

	@RequestMapping(params = "method=gameAuthen", method = RequestMethod.POST)
	public String gameAuthenPost(HttpServletRequest request, ModelMap model, GameAuthArray gameparam) throws Exception {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		try {
			// String data = (String)request.getParameter("data");

			Agency agency = new Agency();
			List<GameAuth> games = gameparam.getGuth();
			if (games.size() > 0) {
				String agencyCode = games.get(0).getAgencyCode();
				agency.setAgencyCode(agencyCode);
				agency.setValidGames(games);
				String str = "";
				str = agencyService.batchInsertGameAuth(agency);

				String[] s = str.split("#");
				if (new Integer(s[0]) > 0) {
					model.addAttribute("system_message", s[1]);
					return LocaleUtil.getUserLocalePath("common/errorTip", request);

				}
				// 记录日志
				Long operAdmin = user.getId();

				BaseMessageReq breq = new BaseMessageReq(5007, 2);
				AgencyGameAuthReq5007 req = new AgencyGameAuthReq5007();
				req.setCtrlLevel(3);
				req.setCtrlCode(agencyCode);
				req.setStatus(0);
				req.setGameCount(games.size());
				long seq = this.logService.getNextSeq();
				req.setCtrls(games);
				breq.setParams(req);

				breq.setMsn(seq);
				String url = PropertiesUtil.readValue("url_host");
				String json = JSONObject.toJSONString(breq);

				MessageLog msglog = new MessageLog(seq, json);
				this.logService.insertLog(msglog);
				// 向主机发送消息
				
				logger.debug("向主机发送请求，请求内容："+json);
				String resulst = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), json);
				logger.debug("接收到主机的响应，消息内容："+resulst);
				
				BaseMessageRes res = JSON.parseObject(resulst, BaseMessageRes.class);
				logger.debug("游戏授权------------------------");
				logger.debug("操作者[" + operAdmin + "errCode:" + s[0] + "message:" + s[1] + "]");
				logger.debug("操作者[" + operAdmin + "AgencyGameAuthReq5007:" + req.toString());
				int stats = res.getRc();
				if (stats == 0) {
					if (lg == UserLanguage.ZH) {
						logger.debug("游戏授权成功!");
						model.addAttribute("system_message", "游戏授权成功!");

					} else if (lg == UserLanguage.EN) {
						logger.debug("Sucess!");
						model.addAttribute("system_message", "Sucess");
					}

					return LocaleUtil.getUserLocalePath("common/successTip", request);
				} else {

					if (lg == UserLanguage.ZH) {
						logger.debug("发送消息失败!");
						model.addAttribute("system_message", "发送消息失败!");

					} else if (lg == UserLanguage.EN) {
						logger.debug("Failed to send the message!");
						model.addAttribute("system_message", "Failed to send the message");
					}

					return LocaleUtil.getUserLocalePath("common/errorTip", request);
				}

			} else {

				if (lg == UserLanguage.ZH) {
					logger.debug("未选择任何游戏!");
					model.addAttribute("system_message", "未选择任何游戏!");

				} else if (lg == UserLanguage.EN) {
					logger.debug("No game selected!");
					model.addAttribute("system_message", "No game selected!");
				}

				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			if (lg == UserLanguage.ZH) {
				logger.debug("游戏授权失败!");
				model.addAttribute("system_message", "游戏授权失败!");

			} else if (lg == UserLanguage.EN) {
				logger.debug("Game authentication failure!");
				model.addAttribute("system_message", "Game authentication failure!");
			}

			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}

	// 销售站详情
	@RequestMapping(params = "method=detailAgency", method = RequestMethod.GET)
	public String detailAgency(HttpServletRequest request, ModelMap model) throws Exception {
		String agencycode = request.getParameter("agencycode");
		Agency agency = agencyService.getAgencyByCode(agencycode);
		model.addAttribute("agency", agency);
		List<GameAuth> games = agencyService.getGameFromAgency(agencycode);
		model.addAttribute("games", games);
		return LocaleUtil.getUserLocalePath("oms/agency/detailAgency", request);

	}

	@ResponseBody
	@RequestMapping(params = "method=enableAgencyBycode")
	public String enableAgencyBycode(HttpServletRequest request) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		try {
			String agencycode = request.getParameter("agencycode");
			Agency agency = new Agency();
			agency.setAgencyStatus(AgencyStatus.ENABLE);
			agency.setAgencyCode(agencycode);
			agencyService.updateStatus(agency);

			// 记录日志
			Long operAdmin = user.getId();
			int status = agency.getC_errcode();
			logger.debug("启用销售站------------------------");
			logger.debug("操作者[" + operAdmin + "errCode:" + agency.getC_errcode() + "message:" + agency.getC_errmsg() + "]");
			BaseMessageReq breq = new BaseMessageReq(6005, 2);
			UpdateAgencyStatusReq6005 req = new UpdateAgencyStatusReq6005();
			req.setAgencyCode(agency.getAgencyCode());
			req.setStatus(AgencyStatus.ENABLE.getValue().shortValue());

			long seq = this.logService.getNextSeq();
			breq.setMsn(seq);
			breq.setParams(req);
			// 向主机发送消息
			if (status == 0) {
				String url = PropertiesUtil.readValue("url_host");
				String json = JSONObject.toJSONString(breq);

				MessageLog msglog = new MessageLog(seq, json);
				this.logService.insertLog(msglog);
				logger.debug("向主机发送请求，请求内容："+json);
				String resulst = HttpClientUtils.postString(PropertiesUtil.readValue("url_host"), json);
				logger.debug("接收到主机的响应，消息内容："+resulst);
				
				BaseMessageRes res = JSON.parseObject(resulst, BaseMessageRes.class);
				if (res.getRc() == 0) {
					map.put("reservedSuccessMsg", "");
					return JSONArray.toJSONString(map);
				}

				String message = "";
				if (lg == UserLanguage.ZH) {
					logger.debug("发送消息失败!");
					message = "发送消息失败!";

				} else if (lg == UserLanguage.EN) {
					logger.debug("Failed to send the message");
					message = "Failed to send the message";
				}

				map.put("reservedSuccessMsg", URLEncoder.encode(message, "utf-8"));
				return JSONArray.toJSONString(map);
			} else {

				map.put("reservedSuccessMsg", URLEncoder.encode(agency.getC_errmsg(), "utf-8"));
				return JSONArray.toJSONString(map);
			}
		} catch (Exception e) {
			String message = "";
			if (lg == UserLanguage.ZH) {
				logger.debug("启用销售站失败!");
				message = "启用销售站失败!";

			} else if (lg == UserLanguage.EN) {
				logger.debug("Failed to enable this region");
				message = "Failed to enable this region";
			}

			map.put("reservedSuccessMsg", URLEncoder.encode(message, "utf-8"));

			return JSONArray.toJSONString(map);
		}
	}

	@RequestMapping(params = "method=getRefunce")
	public String getRefunce(HttpServletRequest request, ModelMap model) {
		String agencyCode = request.getParameter("agencyCode");
		AgencyRefunVo agencys = agencyService.getRefunInfoByagencycode(agencyCode);
		model.addAttribute("agencys", agencys);
		return LocaleUtil.getUserLocalePath("oms/agency/refund", request);

	}

	@ResponseBody
	@RequestMapping(params = "method=ifAgencyCodeExist")
	public String ifAgencyCodeExist(HttpServletRequest request) {
		String flag = "0";
		String agencyCode = request.getParameter("agencyCode");
		if (agencyCode != null && !agencyCode.isEmpty()) {
			Integer count = agencyService.ifAgencyCodeExist(agencyCode);
			if (count.intValue() > 0)
				flag = "1";
		}
		return flag;
	}

	@ResponseBody
	@RequestMapping(params = "method=ifAgencyCodeEnable")
	public String ifAgencyCodeEnable(HttpServletRequest request) {
		String flag = "0";
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String orgCode = user.getInstitutionCode();
		String agencyCode = request.getParameter("agencyCode");
		Areas area = this.agencyService.getAreaCodeByInstionCode(agencyCode);
		if (area != null) {
			if("00".equals(orgCode) || orgCode.equals(area.getAreaCode())){
				flag = "1";
			}
		}
		return flag;
	}
}
