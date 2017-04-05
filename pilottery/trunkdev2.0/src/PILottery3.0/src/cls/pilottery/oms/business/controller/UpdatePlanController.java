package cls.pilottery.oms.business.controller;

import java.io.UnsupportedEncodingException;
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
import cls.pilottery.common.EnumConfigZH;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.business.form.tmversionform.PlanQueryForm;
import cls.pilottery.oms.business.form.tmversionform.SoftwarePackageForm;
import cls.pilottery.oms.business.model.TerminalType;
import cls.pilottery.oms.business.model.areamodel.OMSArea;
import cls.pilottery.oms.business.model.tmversionmodel.PlanTermProgress;
import cls.pilottery.oms.business.model.tmversionmodel.SimpleSoftPack;
import cls.pilottery.oms.business.model.tmversionmodel.UpdatePlan;
import cls.pilottery.oms.business.service.OMSAreaService;
import cls.pilottery.oms.business.service.SoftwarePackageService;
import cls.pilottery.oms.business.service.UpdatePlanService;
import cls.pilottery.oms.common.utils.AjaxCharsetUtil;
import cls.pilottery.web.system.model.User;

import com.alibaba.fastjson.JSONArray;

@Controller
@RequestMapping("/updatePlan")
public class UpdatePlanController {

	static Logger logger = Logger.getLogger(UpdatePlanController.class);
	
	@Autowired
	private UpdatePlanService updatePlanService;
	
	@Autowired
	private SoftwarePackageService packService;

	@Autowired
	private OMSAreaService omsAreaService;
	/**
	 * 数据准备: 部门map
	 */
/*	@ModelAttribute("orgsMap")
	public Map<String, String> getOrgsMap() {
		Map<String, String> orgsMap = new HashMap<String, String>();
		List<OMSArea> infOrgsList = omsAreaService.getInfOrgsList();
		for (OMSArea ifo : infOrgsList) {
			orgsMap.put(ifo.getAreaCode().toString(), ifo.getAreaName());
		}
		return orgsMap;
	}*/

	
	@ModelAttribute("terminalTypes")
	public List<TerminalType> getTerminalType(){
		List<TerminalType> terminalTypes = new ArrayList<TerminalType>();
		terminalTypes.add(new TerminalType(1));
		terminalTypes.add(new TerminalType(2));
		return terminalTypes;
	}
	
	@ModelAttribute("planStatusMap")
	public Map<Integer, String> planStatus(){
		return EnumConfigEN.planStatus;
	}
	
	@RequestMapping(params = "method=updatePlanList")
	public String listPlan(HttpServletRequest request, HttpServletResponse response, ModelMap model,@ModelAttribute("planQueryForm")PlanQueryForm planForm) {
		
		List<Map<String, String>> validSoftVersion = packService.validSoftVersionNo();
		model.addAttribute("validSoftVersion", validSoftVersion);
		
		String tempVersion = "";
		if (planForm.getPackageVersion()!=null && !planForm.getPackageVersion().equals("0")) {
			tempVersion = planForm.getPackageVersion();
			planForm.setPackageVersion(planForm.getPackageVersion().replace(".", ""));
		}
		Integer count = updatePlanService.countPlanList(planForm);		
		List<UpdatePlan> list = new ArrayList<UpdatePlan>();
		int pageIndex = PageUtil.getPageIndex(request);
		if (count != null && count.intValue() != 0) {
			
			planForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			planForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = updatePlanService.queryPlanList(planForm);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
        model.addAttribute("pageDataList", list);
			
		if (planForm.getPackageVersion()!=null && !planForm.getPackageVersion().equals("0")) {
			planForm.setPackageVersion(tempVersion);
		}
		if (LocaleUtil.isChinese(request)) {
			model.addAttribute("planStatusMap",EnumConfigZH.planStatus);
		}
		model.addAttribute("planQueryForm", planForm);
		return LocaleUtil.getUserLocalePath("oms/tmversion/updatePlanList", request);
	}
	
	//add
	@RequestMapping(params = "method=addPlan", method=RequestMethod.GET)
	public String addPlanSetup(HttpServletRequest request, ModelMap model, PlanQueryForm planQueryForm)
			throws Exception {
		//获取部门信息
		List<OMSArea> orgsList = this.omsAreaService.getInfOrgsList();
		model.addAttribute("orgsList", orgsList);
		return LocaleUtil.getUserLocalePath("oms/tmversion/addPlan", request);
	}
	
	
	@RequestMapping(params = "method=addPlan", method=RequestMethod.POST)
	public String addPlan(HttpServletRequest request, ModelMap model, PlanQueryForm planQueryForm) throws Exception {
		try {
			
			UpdatePlan updatePlan = planQueryForm.getUpdatePlan();
			updatePlan.setCityCode(planQueryForm.getAreaCode());
			try {
				logger.debug("新增升级计划,执行存储过程p_om_updplan_create");
				updatePlanService.addUpgradePlan(updatePlan);
				logger.debug("存储过程执行完成,Error Code:"+updatePlan.getC_errcode()+"  ,Error Message:"+updatePlan.getC_errmsg());
				if (updatePlan.getC_errcode()==0) {
					logger.debug("新增升级计划成功！");
					model.addAttribute("reservedHrefURL",
					"updatePlan.do?method=updatePlanList");
					return LocaleUtil.getUserLocalePath("common/successTip", request);
				} else {
					model.addAttribute("system_message", updatePlan.getC_errmsg());
					return LocaleUtil.getUserLocalePath("common/errorTip", request);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
				logger.debug("新增升级计划失败！");
				model.addAttribute("system_message", updatePlan.getC_errmsg());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}
	
	
	//edit
	@RequestMapping(params = "method=editPlan", method=RequestMethod.GET)
	public String editPlanSetup(HttpServletRequest request, ModelMap model)
			throws Exception {

		Integer planId = Integer.parseInt(request.getParameter("planid"));
		String planName = packService.getPlanName(planId);
		String updateTime = request.getParameter("updatetime");
		Integer termType = Integer.parseInt(request.getParameter("termtype"));
		String softNo = request.getParameter("softNo");
		
		UpdatePlan updatePlan = new UpdatePlan();
		updatePlan.setPlanId(planId);
		updatePlan.setPlanName(planName);
		updatePlan.setUpdateDate(updateTime);
		updatePlan.setTermType(termType);
		updatePlan.setSoftNo(softNo);
		
	    model.addAttribute("updatePlan",updatePlan);
	    
	    List<SimpleSoftPack> packvers = packService.getPackVersForTermType(termType); 
	    model.addAttribute("packvers",packvers);
	    return LocaleUtil.getUserLocalePath("oms/tmversion/editPlan", request); 
	}
	
	
	@RequestMapping(params = "method=editPlan", method=RequestMethod.POST)
	public String editPlan(HttpServletRequest request, ModelMap model, @ModelAttribute("updatePlan") UpdatePlan updatePlan,
			@ModelAttribute("softPackageForm") SoftwarePackageForm packForm)
			throws Exception {
		
		try {
			
			try {
				
				updatePlanService.updatePlan(updatePlan);
				
				if (updatePlan.getC_errcode()==0) {
				
					logger.debug("修改升级计划成功");
				model.addAttribute("reservedHrefURL","updatePlan.do?method=updatePlanList");
				 return LocaleUtil.getUserLocalePath("common/successTip", request);
				} else {
					model.addAttribute("system_message", updatePlan.getC_errmsg());
					 return LocaleUtil.getUserLocalePath("common/errorTip", request);
				}
			} catch (Exception e) {
				e.printStackTrace();
				logger.debug("修改升级计划失败");
				model.addAttribute("system_message", updatePlan.getC_errmsg());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}
	
	
	//edit upate time
	@RequestMapping(params = "method=changeupdatetime", method=RequestMethod.GET)
	public String editUpdateTimeSetup(HttpServletRequest request, ModelMap model)
			throws Exception {

		Integer planId = Integer.parseInt(request.getParameter("planid"));
		String planName = packService.getPlanName(planId);
		String updateTime = request.getParameter("updatetime");
		
		UpdatePlan updatePlan = new UpdatePlan();
		updatePlan.setPlanId(planId);
		updatePlan.setPlanName(planName);
		updatePlan.setUpdateDate(updateTime);
		
	    model.addAttribute("updatePlan",updatePlan);
	    return LocaleUtil.getUserLocalePath("oms/tmversion/editUpdateTime", request);
	}
	
	
	@RequestMapping(params = "method=changeupdatetime", method=RequestMethod.POST)
	public String editUpdateTime(HttpServletRequest request, ModelMap model, @ModelAttribute("updatePlan") UpdatePlan updatePlan,
			@ModelAttribute("softPackageForm") SoftwarePackageForm packForm)
			throws Exception {
		
		try {
			
			try {
				
				if (updatePlan.getTimeType()==1) {
					updatePlanService.updateUpdateTime(updatePlan);
				} else {
					updatePlanService.updateUpdateTimeToNow(updatePlan);
				}
				logger.debug("修改更改时间成功！");
				model.addAttribute("reservedHrefURL","updatePlan.do?method=updatePlanList");
				return LocaleUtil.getUserLocalePath("common/successTip", request);
			} catch (Exception e) {
				e.printStackTrace();
				logger.debug("修改更改时间失败！");
				model.addAttribute("system_message", e.getMessage());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
             
	}
	
	//execute
	@RequestMapping(params = "method=executeplan", method=RequestMethod.GET)
	public String executePlanSetup(HttpServletRequest request, ModelMap model)
			throws Exception {

		Integer planId = Integer.parseInt(request.getParameter("planid"));
		String planName = packService.getPlanName(planId);
		String updateDate = packService.getUpdateTime(planId);
		
		UpdatePlan updatePlan = new UpdatePlan();
		updatePlan.setPlanId(planId);
		updatePlan.setPlanName(planName);
		updatePlan.setUpdateDate(updateDate);

	    model.addAttribute("updatePlan",updatePlan);
	    return LocaleUtil.getUserLocalePath("oms/tmversion/executePlan", request);
	}
	
	
	@RequestMapping(params = "method=executeplan", method=RequestMethod.POST)
	public String executePlan(HttpServletRequest request, ModelMap model, @ModelAttribute("updatePlan") UpdatePlan updatePlan,
			@ModelAttribute("softPackageForm") SoftwarePackageForm packForm)
			throws Exception {
		
		try {
			
			try {
				updatePlanService.updatePlanStatus(updatePlan);
				logger.debug("升级计划执行成功！");
				model.addAttribute("reservedHrefURL","updatePlan.do?method=updatePlanList");
				return LocaleUtil.getUserLocalePath("common/successTip", request);
			} catch (Exception e) {
				e.printStackTrace();
				logger.debug("升级计划执行失败！");
				model.addAttribute("system_message", e.getMessage());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}
	
	@ResponseBody
	@RequestMapping(params = "method=getUpdateDate")
	public String updateDate(HttpServletRequest request){
		String updateDate = packService.getUpdateTime(Integer.parseInt(request.getParameter("planId")));
		return updateDate;
	}
	
	@ResponseBody
	@RequestMapping(params = "method=executeplanByCode")
	public String executeplanByCode(HttpServletRequest request)
			throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		try {
			
			UpdatePlan updatePlan = new UpdatePlan();
			updatePlan.setPlanId(Integer.valueOf(request.getParameter("planid")));
			updatePlan.setPlanStatus(Integer.valueOf(request.getParameter("planStatus")));
			try {
				
				updatePlanService.updatePlanStatus(updatePlan);
				logger.debug("升级计划执行成功！！");
				map.put("reservedSuccessMsg", "");
				return JSONArray.toJSONString(map);
			} catch (Exception e) {
				e.printStackTrace();
				logger.debug("升级计划执行失败！！");
				map.put("reservedSuccessMsg", URLEncoder.encode("升级计划执行失败！", "utf-8"));
				return JSONArray.toJSONString(map);
			}
		} catch (Exception e) {
			e.printStackTrace();
			
			map.put("reservedSuccessMsg", URLEncoder.encode("升级计划执行失败！", "utf-8"));
			return JSONArray.toJSONString(map);
		}
	}
	
	//cancel 
	@RequestMapping(params = "method=cancelplan", method=RequestMethod.GET)
	public String cancelPlanSetup(HttpServletRequest request, ModelMap model)
			throws Exception {

		Integer planId = Integer.parseInt(request.getParameter("planid"));
		String planName = packService.getPlanName(planId);
		
		UpdatePlan updatePlan = new UpdatePlan();
		updatePlan.setPlanId(planId);
		updatePlan.setPlanName(planName);
		
	    model.addAttribute("updatePlan",updatePlan);
	    return LocaleUtil.getUserLocalePath("oms/tmversion/cancelPlan", request);
	}
	
	
	@RequestMapping(params = "method=cancelplan", method=RequestMethod.POST)
	public String cancelPlan(HttpServletRequest request, ModelMap model, @ModelAttribute("updatePlan") UpdatePlan updatePlan,
			@ModelAttribute("softPackageForm") SoftwarePackageForm packForm)
			throws Exception {
		
		try {
			HttpSession session = request.getSession();
			User user = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			try {
				
				updatePlanService.updatePlanStatus(updatePlan);
				logger.debug("升级计划取消成功！！");
				model.addAttribute("reservedHrefURL","updatePlan.do?method=updatePlanList");
				return "common/success";
				
			} catch (Exception e) {
				e.printStackTrace();
				logger.debug("升级计划取消失败！！");
				model.addAttribute("system_message", e.getMessage());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}
	
	@ResponseBody
	@RequestMapping(params = "method=cancelplanByCode")
	public String cancelplanByCode(HttpServletRequest request)
			throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		try {
			
			UpdatePlan updatePlan = new UpdatePlan();
			updatePlan.setPlanId(Integer.valueOf(request.getParameter("planid")));
			updatePlan.setPlanStatus(Integer.valueOf(request.getParameter("planStatus")));
			try {
				
				updatePlanService.updatePlanStatus(updatePlan);
				logger.debug("升级计划取消成功！！");
				map.put("reservedSuccessMsg", "");
				return JSONArray.toJSONString(map);
			} catch (Exception e) {
				e.printStackTrace();
				logger.debug("升级计划取消失败！！");
				map.put("reservedSuccessMsg", URLEncoder.encode(" 升级计划取消失败！", "utf-8"));
				return JSONArray.toJSONString(map);
			}
		} catch (Exception e) {
			e.printStackTrace();
			map.put("reservedSuccessMsg", URLEncoder.encode(" 升级计划取消失败！", "utf-8"));
			return JSONArray.toJSONString(map);
		}
	}
	
	//view progress
	@RequestMapping(params = "method=viewprogress", method=RequestMethod.GET)
	public String viewPlanProgress(HttpServletRequest request, ModelMap model)
			throws Exception {

		Integer planId = Integer.parseInt(request.getParameter("planid"));
		String planName = packService.getPlanName(planId);
		
		UpdatePlan updatePlan = new UpdatePlan();
		updatePlan.setPlanId(planId);
		updatePlan.setPlanName(planName);
		
		List<PlanTermProgress> terms = updatePlanService.selectPlanTermProgress(updatePlan);
	    model.addAttribute("updatePlan",updatePlan);
	    model.addAttribute("terms",terms);
	    return LocaleUtil.getUserLocalePath("oms/tmversion/planProgress", request);
	}
	
	@ResponseBody
	@RequestMapping(params="method=ifRepeat")
	public String isRepeatPlanName(HttpServletRequest request) throws UnsupportedEncodingException{
		String flag = "0";//不重复，1为重复
		String planName = AjaxCharsetUtil.getDecodeString(request, "planName", true);
		String oPlanName = AjaxCharsetUtil.getDecodeString(request, "oPlanName", true);
		Map<String, String> map = new HashMap<String, String>();
		map.put("planName", planName);
		map.put("oPlanName", oPlanName);
		if (planName!=null && !planName.isEmpty()) {
			Integer count = updatePlanService.ifExistPlanName(map);
			if (count.intValue()>0)
				flag = "1";
		}
		return flag;
	}
	
	@ResponseBody
	@RequestMapping(params="method=isCorrectTerminalNo")
	public String isCorrectTerminalNo(HttpServletRequest request){
		String flag = "0";//无效，1为有效
		String termType = request.getParameter("termType").trim();
		String termNo = request.getParameter("termNo").trim();
		Map<String, String> map = new HashMap<String, String>();
		map.put("termType", termType);
		map.put("termNo", termNo);
		if(!termType.isEmpty() && !termNo.isEmpty()) {
			Integer count  = updatePlanService.isCorrectTerminalNo(map);
			if (count.intValue()>0)
				flag = "1";
		}
		return flag;
	}
}
