package cls.pilottery.web.outlet.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.DateUtil;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.business.service.AgencyService;
import cls.pilottery.web.capital.model.ResulstMessage;
import cls.pilottery.web.outlet.form.AddOutlet;
import cls.pilottery.web.outlet.form.AgencyDealRecordForm;
import cls.pilottery.web.outlet.form.DetailsForm;
import cls.pilottery.web.outlet.form.ListOutletForm;
import cls.pilottery.web.outlet.form.ResetPassowrd;
import cls.pilottery.web.outlet.model.Area;
import cls.pilottery.web.outlet.model.Bank;
import cls.pilottery.web.outlet.model.FundDailyRecord;
import cls.pilottery.web.outlet.model.MarketAdmin;
import cls.pilottery.web.outlet.model.Orgs;
import cls.pilottery.web.outlet.model.StoreType;
import cls.pilottery.web.outlet.service.OutletService;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.system.model.UserLanguage;

import com.alibaba.fastjson.JSONArray;

/**
 * 
 * @describe:站点管理的Controller
 * 
 */
@Controller
@RequestMapping("/outlets")
public class OutletController {

	static Logger logger = Logger.getLogger(OutletController.class);

	private Map<Integer, String> agencyType = new HashMap<Integer, String>();

	@ModelAttribute("agencyTypee")
	public Map<Integer, String> getUserStatus(HttpServletRequest request) {

		if (request != null)
			this.agencyType = LocaleUtil.getUserLocaleEnum("agencyType", request);
		return agencyType;
	}

	@Autowired
	OutletService outletService;
	@Autowired
	private AgencyService agencyService;

	/**
	 * 列表显示
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(params = "method=listOutlets")
	public String listAgencyGet(HttpServletRequest request, ModelMap model, @ModelAttribute("form") ListOutletForm form) {

		try {
			String insCode = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getInstitutionCode();
			form.setInsCode(insCode);
			Integer count = outletService.getOutletCount(form);
			List<Orgs> orgs = outletService.getInstitution(insCode);
			int pageIndex = PageUtil.getPageIndex(request);
			List<ListOutletForm> list = new ArrayList<ListOutletForm>();
			if (count != null && count.intValue() != 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = outletService.selectByCodeInsti(form);
			}
			model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
			model.addAttribute("listOutlets", list);
			model.addAttribute("orgs", orgs);
			model.addAttribute("form", form);
			return LocaleUtil.getUserLocalePath("data/outlets/listOutlets", request);
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			logger.error("展示异常" + e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}

	/**
	 * 增加销售站
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(params = "method=createInit")
	public String addAgencyGet(HttpServletRequest request, ModelMap model) {

		try {
			String insCode = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getInstitutionCode();
			if (insCode == null || insCode == "") {
				insCode = "-1";
			}
			List<Orgs> institution = outletService.getInstitution(insCode);
			List<Bank> allBank = outletService.getAllBank();
			List<StoreType> allStoreType = outletService.getAllStoreType();
			model.addAttribute("institution", institution);
			model.addAttribute("allBank", allBank);
			model.addAttribute("allStoreType", allStoreType);
			return LocaleUtil.getUserLocalePath("data/outlets/addAgencyin", request);
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			logger.error("添加站点异常" + e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}

	/**
	 * 联动函数
	 * 
	 * @param code
	 * @return
	 */
	@ResponseBody
	@RequestMapping(params = "method=liandong")
	public List<Area> getFirstCode(String code) {

		List<Area> areaOfIns = outletService.getAreaOfIns(code);
		return areaOfIns;
	}

	@ResponseBody
	@RequestMapping(params = "method=liandong1")
	public List<MarketAdmin> getSecCode(String code) {

		List<MarketAdmin> market = outletService.getMaketAdminByInscode(code);
		return market;
	}

	@RequestMapping(params = "method=addOutlet")
	public String addOutlet(HttpServletRequest request, ModelMap model, AddOutlet outlet) {
		outlet.setPass(MD5Util.MD5Encode(SysConstants.INIT_LOGIN_PASSWORD));
		
		logger.debug("执行存储过程p_outlet_create");
		logger.debug(outlet);
		this.outletService.addOutlet(outlet);
		logger.debug("执行结果，Error code:" + outlet.getC_errorcode() + "   ,Error msg:" + outlet.getC_errormesg());
		if (outlet.getC_errorcode() != 0)
			try {
				throw new Exception(outlet.getC_errormesg());
			} catch (Exception e) {
				model.addAttribute("system_message", e.getMessage());
				logger.error("新增站点异常" + e);
				e.printStackTrace();
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}

	@RequestMapping(params = "method=detailsOutlets")
	public String detailsOutlet(HttpServletRequest request, ModelMap model) throws Exception {

		String code = request.getParameter("outletCode");
		DetailsForm form = outletService.getByCode(code);
		model.addAttribute("listForm", form);
		Map<Integer, String> local = LocaleUtil.getUserLocaleEnum("agencyType", request);
		model.addAttribute("agencyType", local.get(Integer.parseInt(form.getAgencyType().toString())));
		return LocaleUtil.getUserLocalePath("data/outlets/detailsAgency", request);
	}

	@RequestMapping(params = "method=modifyInit")
	public String modyInit(HttpServletRequest request, ModelMap model) throws Exception {

		try {
			String insCode = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getInstitutionCode();
			if (insCode == null || insCode == "") {
				insCode = "-1";
			}
			String code = request.getParameter("outletCode");
			DetailsForm form = outletService.getByCode(code);
			List<Orgs> institution = outletService.getInstitution(insCode);
			List<Bank> allBank = outletService.getAllBank();
			List<StoreType> allStoreType = outletService.getAllStoreType();
			model.addAttribute("outletCode", code);
			model.addAttribute("listForm", form);
			Map<Integer, String> local = LocaleUtil.getUserLocaleEnum("agencyType", request);
			model.addAttribute("agencyType", local.get(Integer.parseInt(form.getAgencyType().toString())));
			model.addAttribute("typeNum", Integer.parseInt(form.getAgencyType().toString()));
			model.addAttribute("institution", institution);
			model.addAttribute("allBank", allBank);
			model.addAttribute("allStoreType", allStoreType);
			return LocaleUtil.getUserLocalePath("data/outlets/modifydAgency", request);
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			logger.error("修改站点异常" + e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}

	@RequestMapping(params = "method=modify")
	public String modifyOutlet(HttpServletRequest request, ModelMap model, AddOutlet outlet) throws UnsupportedEncodingException {
		logger.debug("执行存储过程p_outlet_modify");
		logger.debug(outlet);
		this.outletService.modifyOutlet(outlet);
		logger.debug("执行结果，Error code:" + outlet.getC_errorcode() + "   ,Error msg:" + outlet.getC_errormesg());

		if (outlet.getC_errorcode() != 0)
			try {
				throw new Exception(outlet.getC_errormesg());
			} catch (Exception e) {
				model.addAttribute("system_message", e.getMessage());
				logger.error("修改站点异常" + e);
				e.printStackTrace();
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}

		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=deleteOutlets")
	public String deleteOutlets(HttpServletRequest request) {

		Map<String, String> map = new HashMap<String, String>();
		String outletCode = request.getParameter("outletCode");
		try {
			Integer telcount = this.agencyService.getSalerTellerByAgencode(outletCode);
			Integer temcount = this.agencyService.getSalerTermByAgenCode(outletCode);
			if (telcount == 0 && temcount == 0) {
				int staus = this.outletService.deleteupdeSatus(outletCode);
				if (staus == 0) {
					map.put("reservedSuccessMsg", "");
				}
			} else {
				if(LocaleUtil.isChinese(request)){
					map.put("reservedSuccessMsg", URLEncoder.encode("删除失败，该站点下还有销售员或终端机", "utf-8"));
				}else{
					map.put("reservedSuccessMsg", "Delete failed,the outlet contains terminal or teller");
				}
			}

		} catch (Exception e) {
			logger.error("errmsgs" + e.getMessage());
			if(LocaleUtil.isChinese(request)){
				try {
					map.put("reservedSuccessMsg", URLEncoder.encode("删除失败:"+e.getMessage(), "utf-8"));
				} catch (UnsupportedEncodingException e1) {
					e1.printStackTrace();
				}
			}else{
				map.put("reservedSuccessMsg", "Delete failed:"+e.getMessage());
			}
		}
		return JSONArray.toJSONString(map);
	}

	@ResponseBody
	@RequestMapping(params = "method=enable")
	public String enable(HttpServletRequest request) throws UnsupportedEncodingException {
		Map<String, String> map = new HashMap<String, String>();
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		UserLanguage lg = user.getUserLang();
		String outletCode = request.getParameter("outletCode");
		outletService.enable(outletCode);

		if (lg == UserLanguage.ZH) {
			String message = "成功";
			map.put("system_message", URLEncoder.encode(message, "utf-8"));

		} else if (lg == UserLanguage.EN) {
			String message = "Success";
			map.put("system_message", URLEncoder.encode(message, "utf-8"));
		}

		return JSONArray.toJSONString(map);
	}

	@ResponseBody
	@RequestMapping(params = "method=resetPass")
	public String resetPass(HttpServletRequest request) {

		String outletCode = request.getParameter("outletCode");
		String pass = MD5Util.MD5Encode(SysConstants.INIT_LOGIN_PASSWORD);
		ResetPassowrd reset = new ResetPassowrd();
		reset.setPassword(pass);
		reset.setOutletCode(outletCode);
		int status = this.outletService.resetPass(reset);
		if (status == 1) {
			return "success";
		}
		return "error";
	}

	@ResponseBody
	@RequestMapping(params = "method=disable")
	public String disable(HttpServletRequest request) {

		String outletCode = request.getParameter("outletCode");
		int status = this.outletService.disable(outletCode);
		if (status == 1) {
			return "success";
		} else {
			return "error";
		}

	}

	@ResponseBody
	@RequestMapping(params = "method=deleteOutletsInit")
	public String deleteOutletsInit(HttpServletRequest request) {

		String outletCode = request.getParameter("outletCode");
		long balance = this.outletService.selectBalance(outletCode);

		return String.valueOf(balance);
	}

	@RequestMapping(params = "method=agencyDealRecord")
	public String ListAgencyDealRecord(HttpServletRequest request, ModelMap model,AgencyDealRecordForm agencyForm){
		int count = 0;
		Calendar cld = Calendar.getInstance();
		String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
		agencyForm.setBeginTime(defaultDate);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("form", agencyForm);
		
		Map<Integer, String> local = LocaleUtil.getUserLocaleEnum("transFlowType", request);
		List<Integer> flowList = outletService.getFlowTypeList();
		Map<Integer,String> flowTypes = new HashMap<Integer,String>();
		for(Integer f : flowList){
			flowTypes.put(f, local.get(f));
		}
		
		model.addAttribute("flowTypes", flowTypes);
		
		return LocaleUtil.getUserLocalePath("outletService/agencyDealRecord", request);
	}
	@RequestMapping(params = "method=queryAgencyDealRecord")
	public String queryListAgencyDealRecord(HttpServletRequest request, ModelMap model, @ModelAttribute("agencyForm") AgencyDealRecordForm agencyForm) throws Exception {

		/*if (agencyForm == null || StringUtils.isEmpty(agencyForm.getBeginTime())) {
			agencyForm = new AgencyDealRecordForm();
			Calendar cld = Calendar.getInstance();
			String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
			agencyForm.setBeginTime(defaultDate);
			agencyForm.setEndTime(defaultDate);
		}*/
		
		String insCode = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getInstitutionCode();
		Map<Integer, String> local = LocaleUtil.getUserLocaleEnum("transFlowType", request);
		agencyForm.setInsCode(insCode);
		Integer count = outletService.getAgencyCount(agencyForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<AgencyDealRecordForm> agencyList = new ArrayList<AgencyDealRecordForm>();
		if (count != null && count.intValue() != 0) {
			agencyForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			agencyForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			agencyList = outletService.getAgencyDealList(agencyForm);
			for (AgencyDealRecordForm form : agencyList) {
				form.setDealEnType(local.get(form.getDealType()));
			}
		}
		
		List<Integer> flowList = outletService.getFlowTypeList();
		Map<Integer,String> flowTypes = new HashMap<Integer,String>();
		for(Integer f : flowList){
			flowTypes.put(f, local.get(f));
		}
		
		model.addAttribute("flowTypes", flowTypes);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageAgencyList", agencyList);
		model.addAttribute("form", agencyForm);
		return LocaleUtil.getUserLocalePath("outletService/agencyDealRecord", request);
	}

	@RequestMapping(params = "method=fundDailyRecord")
	public String fundDailyRecord(HttpServletRequest request, ModelMap model, @ModelAttribute("agencyForm") AgencyDealRecordForm agencyForm) throws Exception {

		String insCode = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getInstitutionCode();
		if (agencyForm.getBeginTime() == null) {
			agencyForm.setBeginTime(DateUtil.yesterday("yyyy-MM-dd"));
		}
		agencyForm.setInsCode(insCode);
		Integer count = outletService.getFundDailyCount(agencyForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<FundDailyRecord> agencyList = new ArrayList<FundDailyRecord>();
		if (count != null && count.intValue() != 0) {
			agencyForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			agencyForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			agencyList = outletService.getFundDailyList(agencyForm);
			Map<Integer, String> flowType = LocaleUtil.getUserLocaleEnum("transFlowType", request);
			for (FundDailyRecord list : agencyList) {
				list.setFundType(flowType.get(Integer.parseInt(list.getFundType())));
			}
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageAgencyList", agencyList);
		model.addAttribute("agencyForm", agencyForm);
		return LocaleUtil.getUserLocalePath("outletService/fundDailyRecord", request);
	}
}
