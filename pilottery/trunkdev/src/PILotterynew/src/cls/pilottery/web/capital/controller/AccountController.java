package cls.pilottery.web.capital.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.capital.form.InstitutionAcctForm;
import cls.pilottery.web.capital.form.ManagerAcctForm;
import cls.pilottery.web.capital.form.OutletAcctForm;
import cls.pilottery.web.capital.form.OutletAdjustForm;
import cls.pilottery.web.capital.model.InstitutionAccount;
import cls.pilottery.web.capital.model.InstitutionAccountExt;
import cls.pilottery.web.capital.model.InstitutionAccountModel;
import cls.pilottery.web.capital.model.ManagerAccount;
import cls.pilottery.web.capital.model.ManagerAccountModel;
import cls.pilottery.web.capital.model.OutletAccount;
import cls.pilottery.web.capital.model.OutletAccountExt;
import cls.pilottery.web.capital.model.OutletAccountModel;
import cls.pilottery.web.capital.service.InstitutionAcctService;
import cls.pilottery.web.capital.service.ManagerAcctService;
import cls.pilottery.web.capital.service.OutletAcctService;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.institutions.service.InstitutionsService;
import cls.pilottery.web.marketManager.model.InventoryModel;
import cls.pilottery.web.marketManager.service.RepaymentRecordService;
import cls.pilottery.web.system.model.User;

import com.alibaba.fastjson.JSONArray;

/**
 * 站点、代理商、市场管理员账户的管理Controller
 * @author jhx
 */

@Controller
@RequestMapping("/account")
public class AccountController {
	static Logger logger = Logger.getLogger(AccountController.class);

	/**
	 * 站点账户管理
	 */
	@Autowired
	private OutletAcctService outletAcctService;
	@Autowired
	private InstitutionsService institutionsService;
	@Autowired
	private RepaymentRecordService repaymentRecordService;

	/**
	 * 站点账户管理列表和查询
	 */
	@RequestMapping(params = "method=listOutletAccounts")
	public String listOutletAccounts(HttpServletRequest request,
			ModelMap model, OutletAcctForm outletAcctForm) {
		
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		if(currentUser.getId() != 0){
			outletAcctForm.setOrgCode(currentUser.getInstitutionCode());
		}
		
		Integer count = outletAcctService.getOutletAcctCount(outletAcctForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<OutletAccount> list = new ArrayList<OutletAccount>();
		if (count != null && count.intValue() != 0) {
			outletAcctForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			outletAcctForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
					+ PageUtil.pageSize);
			list = outletAcctService.getOutletAcctList(outletAcctForm);
		}
		List<InfOrgs> orgList = institutionsService.getAllInstitutionsInfo();
		
		model.addAttribute("orgList", orgList);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("outletAcctForm", outletAcctForm);

		return LocaleUtil.getUserLocalePath("capital/outletAccounts/listOutletAccounts", request);
	}

	/**
	 * 初始化站点账户修改页面
	 */
	
	@RequestMapping(params = "method=editOutletAccount")
	public String editOutletAccounts(HttpServletRequest request, ModelMap model) {
		String agencyCode = request.getParameter("agencyCode");
		List<OutletAccountModel> OutletAccts = new ArrayList<OutletAccountModel>();
		OutletAccts = outletAcctService.getOutletAcctInfo(agencyCode);
		if(OutletAccts.size()==0){
			OutletAccts = outletAcctService.getOutletAcctInfo2(agencyCode);
		}
		model.addAttribute("OutletAccts", OutletAccts);
		return LocaleUtil.getUserLocalePath("capital/outletAccounts/editOutletAccount", request);
	}

	
	/**
	 * 执行修改站点账户信息
	 */
	@RequestMapping(params = "method=modifyOutletAcct")
	public String modifyOutletAccount(HttpServletRequest request,
			ModelMap model, OutletAccountExt outlet) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			if (outlet == null)
				throw new Exception("Invalid Paramter.");
			if (outlet.getOutletCommRate() != null) {
				outletAcctService.updateAccountComm(outlet);
				if (outlet.getC_errcode() != 0)
					throw new Exception(LocaleUtil.getUserLocaleErrorMsg(outlet.getC_errmsg(), request));
			} else {
				map.put("agencyCode", outlet.getAgencyCode());
				map.put("creditLimit", outlet.getCreditLimit());
				outletAcctService.updateAccountLimit(map);
			}
		} catch (Exception e) {
			request.setAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}

	/*
	 * 删除账户信息
	 */
	@ResponseBody
	@RequestMapping(params = "method=deleteOutletAcct")
	public String deleteOutletAccount(HttpServletRequest request) {
		Map<String, String> map = new HashMap<String, String>();
		String agencyCode = request.getParameter("agencyCode");
		try {
			int staus = this.outletAcctService.deleteupdeSatus(agencyCode);
			if (staus == 1) {
				map.put("reservedSuccessMsg", "");
			} else {
				map.put("reservedSuccessMsg", "Delete failed");
			}
		} catch (Exception e) {
			logger.error("errmsgs" + e.getMessage());
			map.put("reservedSuccessMsg", "Delete failed");
		}
		return JSONArray.toJSONString(map);
	}

	/***************************** ————代理商账户管理 ———— *****************************************/

	@Autowired
	private InstitutionAcctService institutionAcctService;

	/**
	 * 代理商账户管理列表和查询代理商账户
	 */
	@RequestMapping(params = "method=listInstitutionAccounts")
	public String InsitutionAccounts(HttpServletRequest request,
			ModelMap model, InstitutionAcctForm institutionAcctForm) {

		HttpSession session = request.getSession();
		User currentUser = (User) session
				.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String code = currentUser.getInstitutionCode();
		if (code.equals("00") == true) {
			Integer count = institutionAcctService
					.getInstitutionAcctCount(institutionAcctForm);
			int pageIndex = PageUtil.getPageIndex(request);
			List<InstitutionAccount> list = new ArrayList<InstitutionAccount>();
			if (count != null && count.intValue() != 0) {
				institutionAcctForm.setBeginNum((pageIndex - 1)
						* PageUtil.pageSize);
				institutionAcctForm.setEndNum((pageIndex - 1)
						* PageUtil.pageSize + PageUtil.pageSize);

				list = institutionAcctService
						.getInstitutionAcctList(institutionAcctForm);
			}
			model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
			model.addAttribute("pageDataList", list);
			model.addAttribute("institutionAcctForm", institutionAcctForm);
			return LocaleUtil.getUserLocalePath("capital/institutionAccounts/listInstitutionAccounts", request);
		} else {
			return LocaleUtil.getUserLocalePath("capital/institutionAccounts/noPermissionsTip", request);
		}
	}

	/**
	 * 初始化代理商账户修改
	 */
	@RequestMapping(params = "method=editInstitutionAccount")
	public String initOutletAcctsEdit(HttpServletRequest request, ModelMap model) {
		String orgCode = request.getParameter("orgCode");
		List<InstitutionAccountModel> OrgAccts = new ArrayList<InstitutionAccountModel>();
		OrgAccts = institutionAcctService.getInstitutionAcctInfo(orgCode);
		if (OrgAccts.size() == 0) {
			OrgAccts = institutionAcctService.getInstitutionAcctInfo2(orgCode);
		} 
		model.addAttribute("OrgAccts", OrgAccts);
		return LocaleUtil.getUserLocalePath("capital/institutionAccounts/editInstitutionAccount", request);
	}

	/**
	 * 执行修改代理商账户信息
	 */
	@RequestMapping(params = "method=modifyInstitutionAcct")
	public String modifyOutletAccount(HttpServletRequest request,
			ModelMap model, InstitutionAccountExt ext) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			if (ext == null)
				throw new Exception("Invalid Paramter.");
			if (ext.getiCommRateList() != null) {
				institutionAcctService.updateCommRate(ext);
				if (ext.getErrCode() != 0)
					throw new Exception(ext.getErrMessage());
			}
			else {
				map.put("orgCode", ext.getOrgCode());
				map.put("creditLimit", ext.getCreditLimit());
				institutionAcctService.updateInstitutionLimit(map);
			}
		} catch (Exception e) {
			request.setAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}

	/**
	 * 删除代理商账户信息
	 */
	@ResponseBody
	@RequestMapping(params = "method=deleteInstitutionAcct")
	public String deleteInstitutionAcct(HttpServletRequest request) {
		Map<String, String> map = new HashMap<String, String>();
		String orgCode = request.getParameter("orgCode");
		try {
			int staus = this.institutionAcctService.deleteupdeSatus(orgCode);
			if (staus == 1) {
				map.put("reservedSuccessMsg", "");
			} else {
				map.put("reservedSuccessMsg", "Delete failed");
			}
		} catch (Exception e) {
			logger.error("errmsgs" + e.getMessage());
			map.put("reservedSuccessMsg", "Delete failed");
		}
		return JSONArray.toJSONString(map);
	}

	
	/*****************************————市场管理员账户管理 ————***************************************/

	@Autowired
	private ManagerAcctService managerAcctService;

	/**
	 * 市场管理员账户管理列表和查询
	 */
	@RequestMapping(params = "method=listMarketManagersAccounts")
	public String listManagerAccounts(HttpServletRequest request,
			ModelMap model, ManagerAcctForm managerAcctForm) {
		
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		//managerAcctForm.setAdminOrg(currentUser.getInstitutionCode());
		if(currentUser.getId() != 0){
			managerAcctForm.setAdminOrg(currentUser.getInstitutionCode());
		}
		
		Integer count = managerAcctService.getManagerAcctCount(managerAcctForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<ManagerAccount> list = new ArrayList<ManagerAccount>();
		if (count != null && count.intValue() != 0) {
			managerAcctForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			managerAcctForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
					+ PageUtil.pageSize);

			list = managerAcctService.getManagerAcctList(managerAcctForm);
		}
		
		List<InfOrgs> orgList = institutionsService.getAllInstitutionsInfo();
		model.addAttribute("orgList", orgList);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("managerAcctForm", managerAcctForm);

		return LocaleUtil.getUserLocalePath("capital/marketManagerAccounts/listManagersAccounts", request);
	}

	/**
	 * 初始化市场管理员账户修改
	 */
	@RequestMapping(params = "method=editMangerAccount")
	public String initManagerAcctsEdit(HttpServletRequest request,
			ModelMap model) {
		String marketAdmin = request.getParameter("marketAdmin");
		// List<GamePlans> gamePlansList = outletAcctService.getGamePlans();
		ManagerAccountModel managerAccts = managerAcctService
				.getManagerAcctInfo(marketAdmin);

		model.addAttribute("managerAccts", managerAccts);
		return LocaleUtil.getUserLocalePath("capital/marketManagerAccounts/editManagerAccount", request);
	}

	/**
	 * 执行修改市场管理员账户信息
	 */
	@RequestMapping(params = "method=modifyManagerAcct")
	public String modifyMangerAccount(HttpServletRequest request,
			ModelMap model, ManagerAccount managerAccount) {
		try {
			// note: MD5加密
			managerAccount.setTransPass(MD5Util.MD5Encode(managerAccount.getTransPass()));
			managerAcctService.updateManagerAccount(managerAccount);
		} catch (Exception e) {
			request.setAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}

	/**
	 * 删除代理商账户信息
	 */
	@ResponseBody
	@RequestMapping(params = "method=delteManagerAcct")
	public String deleteManagerAcct(HttpServletRequest request) {
		Map<String, String> map = new HashMap<String, String>();
		String marketAdmin = request.getParameter("marketAdmin");
		try {
			int staus = this.managerAcctService.deleteupdeSatus(marketAdmin);
			if (staus == 1) {
				map.put("reservedSuccessMsg", "");
			} else {
				map.put("reservedSuccessMsg", "Delete failed");
			}
		} catch (Exception e) {
			logger.error("errmsgs" + e.getMessage());
			map.put("reservedSuccessMsg", "Delete failed");
		}
		return JSONArray.toJSONString(map);
	}
	
	@RequestMapping(params = "method=getInventoryDetail")
	public String getInventoryDetail(HttpServletRequest request, ModelMap model) {
		String marketAdmin = request.getParameter("marketAdmin");
		
		List<InventoryModel> list = null;
		InventoryModel total = null;
		try {
			list = repaymentRecordService.getInventoryList(Integer.parseInt(marketAdmin));
			total = repaymentRecordService.getInventorySum(Integer.parseInt(marketAdmin));
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			logger.error("市场管理员在手库存查询发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("total", total);
		model.addAttribute("list", list);
		return LocaleUtil.getUserLocalePath("capital/marketManagerAccounts/mmInventoryDetail", request);
	}
	
	
	/**
	 * 站点账户查询
	 */
	@RequestMapping(params = "method=getOutletInfo")
	public String getOutletInfo(HttpServletRequest request,ModelMap model, OutletAcctForm form) {
		String init = request.getParameter("init");
		if(StringUtils.isEmpty(init)){
			return LocaleUtil.getUserLocalePath("capital/outletAdjustment/listOutlets", request);
		}
		
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		if(!currentUser.getInstitutionCode().equals("00")){
			form.setOrgCode(currentUser.getInstitutionCode());
		}
		
		Integer count = outletAcctService.getOutletAcctCount(form);
		int pageIndex = PageUtil.getPageIndex(request);
		List<OutletAccount> list = new ArrayList<OutletAccount>();
		if (count != null && count.intValue() != 0) {
			form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = outletAcctService.getOutletAcctList(form);
		}
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("form", form);

		return LocaleUtil.getUserLocalePath("capital/outletAdjustment/listOutlets", request);
	}

	/**
	 * 初始化站点账户修改页面
	 */
	
	@RequestMapping(params = "method=initOutletAccount")
	public String adjustOuletAccount(HttpServletRequest request, ModelMap model) {
		String agencyCode = request.getParameter("agencyCode");
		OutletAccountModel outlet = outletAcctService.getOutletAccountForAdjust(agencyCode);
		model.addAttribute("outlet", outlet);
		return LocaleUtil.getUserLocalePath("capital/outletAdjustment/outletAdjustment", request);
	}
	
	@RequestMapping(params = "method=adjustOutletAccount")
	public String adjustOutletAccount(HttpServletRequest request,ModelMap model,OutletAdjustForm form) {
		try {
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCrtUserId(currentUser.getId()+":adjust");
			logger.debug("执行存储过程：p_agency_fund_change_manual");
			logger.debug(form);
			
			outletAcctService.adjustOutletAccount(form);
			logger.debug("存储过程p_agency_fund_change_manual执行完成");
			logger.debug("Error Code:"+form.getC_errcode());
			logger.debug("Error Msg:"+form.getC_errmsg());
			if(form!=null && form.getC_errcode()!=0){
				logger.debug("存储过程p_agency_fund_change_manual执行错误");
				request.setAttribute("system_message", LocaleUtil.getUserLocaleErrorMsg(form.getC_errmsg(), request));
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}

}
