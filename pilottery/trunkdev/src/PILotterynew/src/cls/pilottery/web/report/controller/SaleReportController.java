package cls.pilottery.web.report.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.web.report.form.SaleReportForm;
import cls.pilottery.web.report.model.InstitutionFundVO;
import cls.pilottery.web.report.model.InstitutionModel;
import cls.pilottery.web.report.model.InventoryDaliyReportVo;
import cls.pilottery.web.report.model.InventoryModel;
import cls.pilottery.web.report.model.ManagerFundReportVO;
import cls.pilottery.web.report.model.OrgInventoryDaliyReportVo;
import cls.pilottery.web.report.model.OutletFundVO;
import cls.pilottery.web.report.model.OutletInventoryDaliyReportVo;
import cls.pilottery.web.report.model.SalesReportModel;
import cls.pilottery.web.report.model.WarehouseModel;
import cls.pilottery.web.report.service.SaleReportService;
import cls.pilottery.web.sales.model.PlanModel;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("saleReport")
public class SaleReportController {
	Logger log = Logger.getLogger(SaleReportController.class);
	
	@Autowired
	private SaleReportService saleReportService;
	
	@RequestMapping(params = "method=initGameSalesReport")
	public String initGameSalesReport(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			
			Calendar cld = Calendar.getInstance(); 
			//cld.add(Calendar.DATE, -1);
			String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
			form.setBeginDate(defaultDate);
			form.setEndDate(defaultDate);
			
			List<PlanModel> planList = saleReportService.getPlanList();
			model.addAttribute("planList",planList);
			model.addAttribute("form",form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化销售报表页面发生异常！", e);
			
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/gameSalesReport", request);
		
	}
	
	@RequestMapping(params="method=getGameSalesReport")
	public String getGameSalesReport(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		List<SalesReportModel> list = null;
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			
			list = saleReportService.getGameSalesList(form);
			SalesReportModel sum = saleReportService.getGameSalesSum(form);
			List<PlanModel> planList = saleReportService.getPlanList();
			model.addAttribute("planList",planList);
			model.addAttribute("sum",sum);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message",e.getMessage());
			log.error("查询订单列表功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("pageDataList", list);
		model.addAttribute("form",form);
		return LocaleUtil.getUserLocalePath("report/gameSalesReport", request);
		
	}
	
	@RequestMapping(params = "method=initInstitutionSalesReport")
	public String initInstitutionSalesReport(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			
			Calendar cld = Calendar.getInstance(); 
			//cld.add(Calendar.DATE, -1);
			String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
			form.setBeginDate(defaultDate);
			form.setEndDate(defaultDate);
			
			model.addAttribute("form",form);
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化销售报表页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/institutionSalesReport", request);
		
	}
	
	@RequestMapping(params="method=getInstitutionSalesReport")
	public String getInstitutionSalesReport(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		List<SalesReportModel> list = null;
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			
			list = saleReportService.getInstitutionSalesList(form);
			SalesReportModel sum = saleReportService.getInstitutionSalesSum(form);
			model.addAttribute("sum",sum);
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message",e.getMessage());
			log.error("查询订单列表功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("pageDataList", list);
		model.addAttribute("form",form);
		return LocaleUtil.getUserLocalePath("report/institutionSalesReport", request);
		
	}
	
	@RequestMapping(params = "method=initInventoryReports")
	public String initInventoryReports(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			
			Calendar cld = Calendar.getInstance(); 
			//cld.add(Calendar.DATE, -1);
			String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
			form.setBeginDate(defaultDate);
			form.setEndDate(defaultDate);
			
			List<PlanModel> planList = saleReportService.getPlanList();
			List<WarehouseModel> warehouseList = saleReportService.getWarehouseList(currentUser.getInstitutionCode());
			model.addAttribute("planList",planList);
			model.addAttribute("warehouseList",warehouseList);
			model.addAttribute("form",form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化销售报表页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/inventoryReport", request);
		
	}
	
	@RequestMapping(params="method=getInventoryReport")
	public String getInventoryReport(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		List<InventoryModel> list = null;
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			
			list = saleReportService.getInventoryList(form);
			//InventoryModel sum = saleReportService.getInventorySum(form);
			List<PlanModel> planList = saleReportService.getPlanList();
			List<WarehouseModel> warehouseList = saleReportService.getWarehouseList(currentUser.getInstitutionCode());
			model.addAttribute("planList",planList);
			model.addAttribute("warehouseList",warehouseList);
			//model.addAttribute("sum",sum);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message",e.getMessage());
			log.error("查询订单列表功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("pageDataList", list);
		model.addAttribute("form",form);
		return LocaleUtil.getUserLocalePath("report/inventoryReport", request);
		
	}
	
	@RequestMapping(params = "method=institutionFundReport")
	public String institutionFundReport(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				//cld.add(Calendar.DATE, -1);
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
			}
			
			List<InstitutionFundVO> list = saleReportService.getInstitutionFundList(form);
			model.addAttribute("list",list);
			if(list!=null &&list.size()> 0){
				InstitutionFundVO sum = saleReportService.getInstitutionFundListSum(form);
				model.addAttribute("sum",sum);
			}
			
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
			model.addAttribute("form",form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化销售报表页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/institutionFundReport", request);
	
	}
	@RequestMapping(params = "method=institutionFundReportUSD")
	public String institutionFundReportUSD(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				//cld.add(Calendar.DATE, -1);
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
			}
			
			List<InstitutionFundVO> list = saleReportService.getInstitutionFundUSDList(form);
			model.addAttribute("list",list);
			if(list!=null &&list.size()> 0){
				InstitutionFundVO sum = saleReportService.getInstitutionFundUSDListSum(form);
				model.addAttribute("sum",sum);
			}
			
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
			model.addAttribute("form",form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化销售报表页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/institutionFundReportUSD", request);
		
	}
	
	@RequestMapping(params = "method=outletFundReport")
	public String outletFundReport(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
			
			if(form == null || StringUtils.isEmpty(form.getCuserOrg())){
				if(!currentUser.getInstitutionCode().equals("00")){
					form.setCuserOrg(currentUser.getInstitutionCode());
				}
			}
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				cld.add(Calendar.DATE, -1);
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
				
				model.addAttribute("form",form);
				return LocaleUtil.getUserLocalePath("report/outletFundReport", request);
			}
			
			List<OutletFundVO> list = saleReportService.getOutletFundList(form);
			model.addAttribute("list",list);
			if(list!=null &&list.size()> 0){
				OutletFundVO sum = saleReportService.getOutletFundListSum(form);
				model.addAttribute("sum",sum);
			}
			
			model.addAttribute("form",form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化销售报表页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/outletFundReport", request);
	}
	@RequestMapping(params = "method=outletFundReportUSD")
	public String outletFundReportUSD(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
			
			if(form == null || StringUtils.isEmpty(form.getCuserOrg())){
				if(!currentUser.getInstitutionCode().equals("00")){
					form.setCuserOrg(currentUser.getInstitutionCode());
				}
			}
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				cld.add(Calendar.DATE, -1);
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
				
				model.addAttribute("form",form);
				return LocaleUtil.getUserLocalePath("report/outletFundReportUSD", request);
			}
			
			List<OutletFundVO> list = saleReportService.getOutletFundUSDList(form);
			model.addAttribute("list",list);
			if(list!=null &&list.size()> 0){
				OutletFundVO sum = saleReportService.getOutletFundUSDListSum(form);
				model.addAttribute("sum",sum);
			}
			
			model.addAttribute("form",form);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化销售报表页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		
		}
		return LocaleUtil.getUserLocalePath("report/outletFundReportUSD", request);
	}
	
	@RequestMapping(params = "method=outletsSalesReport")
	public String outletsSalesReport(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			
			Calendar cld = Calendar.getInstance(); 
			cld.add(Calendar.DATE, -1);
			String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
			form.setBeginDate(defaultDate);
			form.setEndDate(defaultDate);
			
			model.addAttribute("form",form);
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化销售报表页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/outletSalesReport", request);
	
	}
	@RequestMapping(params = "method=mmInventoryDaliyReport")
	public String mmInventoryDaliyReport(HttpServletRequest request, ModelMap model,SaleReportForm form){
		User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		form.setCurrentUserId(currentUser.getId().intValue());
		form.setCuserOrg(currentUser.getInstitutionCode());
		Calendar cld = Calendar.getInstance(); 
		cld.add(Calendar.DATE, -1);
		String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
		form.setBeginDate(defaultDate);
		form.setEndDate(defaultDate);
		model.addAttribute("form",form);
		 List<InventoryDaliyReportVo> listReport=this.saleReportService.getInventoryDaliyReportList(form);
		model.addAttribute("listreport",listReport);
		return LocaleUtil.getUserLocalePath("report/inventoryDaliyReport", request);
	
	}
	@RequestMapping(params = "method=querymmInventoryDaliyReport", method = RequestMethod.POST)
	public String querymmInventoryDaliyReport(HttpServletRequest request, ModelMap model,SaleReportForm form){
		User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		form.setCurrentUserId(currentUser.getId().intValue());
		form.setCuserOrg(currentUser.getInstitutionCode());
        List<InventoryDaliyReportVo> listReport=this.saleReportService.getInventoryDaliyReportList(form);
		model.addAttribute("form",form);
		model.addAttribute("listreport",listReport);
		return LocaleUtil.getUserLocalePath("report/inventoryDaliyReport", request);
	}
	
	/*
	 * 市场管理员资金日结报表
	 */
	@RequestMapping(params = "method=mmCapitalDaliyReport")
	public String mmCapitalDaliyReport(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		return LocaleUtil.getUserLocalePath("report/mmCapitalDaliyReport", request);
	}
	
	@RequestMapping(params = "method=querymmCapitalDaliyReport", method = RequestMethod.POST)
	public String querymmCapitalDaliyReport(HttpServletRequest request, ModelMap model,SaleReportForm form){
		User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		form.setCurrentUserId(currentUser.getId().intValue());
		form.setCuserOrg(currentUser.getInstitutionCode());
        List<ManagerFundReportVO> listReport=this.saleReportService.getMnanagerFundList(form);
		model.addAttribute("form",form);
		model.addAttribute("listreport",listReport);
		return LocaleUtil.getUserLocalePath("report/mmCapitalDaliyReport", request);
	}
	
	@RequestMapping(params = "method=outletInventoryDaliyReport")
	public String outletInventoryDaliyReport(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				cld.add(Calendar.DATE, -1);
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
				
				model.addAttribute("form",form);
				return LocaleUtil.getUserLocalePath("report/outletInventoryDaliyReport", request);
				
			}
			
			List<OutletInventoryDaliyReportVo> list = saleReportService.getOutletInventoryDaliyReport(form);
			model.addAttribute("list",list);
			model.addAttribute("form",form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化销售报表页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		
		}
		return LocaleUtil.getUserLocalePath("report/outletInventoryDaliyReport", request);
	
	}
	
	@RequestMapping(params = "method=institutionInventoryDaliyReport")
	public String institutionInventoryDaliyReport(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				cld.add(Calendar.DATE, -1);
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
				
				model.addAttribute("form",form);
				return LocaleUtil.getUserLocalePath("report/institutionInventoryDaliyReport", request);
			}
			
			List<OrgInventoryDaliyReportVo> list = saleReportService.getOrgInventoryDaliyReport(form);
			model.addAttribute("list",list);
			model.addAttribute("form",form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化销售报表页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/institutionInventoryDaliyReport", request);
	
	}
	
	@RequestMapping(params = "method=institutionPayableReport")
	public String institutionPayableReport(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				//cld.add(Calendar.DATE, -1);
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
			}
			
			List<InstitutionFundVO> list = saleReportService.getInstitutionPayableList(form);
			model.addAttribute("list",list);
			if(list!=null &&list.size()> 0){
				InstitutionFundVO sum = saleReportService.getInstitutionPayableListSum(form);
				model.addAttribute("sum",sum);
			}
			
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
			model.addAttribute("form",form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化销售报表页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/institutionPayableReport", request);
		
	}
	@RequestMapping(params = "method=institutionPayableReportUSD")
	public String institutionPayableReportUSD(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				//cld.add(Calendar.DATE, -1);
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
			}
			
			List<InstitutionFundVO> list = saleReportService.getInstitutionPayableUSDList(form);
			model.addAttribute("list",list);
			if(list!=null &&list.size()> 0){
				InstitutionFundVO sum = saleReportService.getInstitutionPayableUSDListSum(form);
				model.addAttribute("sum",sum);
			}
			
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
			model.addAttribute("form",form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化销售报表页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	
		return LocaleUtil.getUserLocalePath("report/institutionPayableReportUSD", request);
	}
	
	@RequestMapping(params = "method=agentFundReport")
	public String agentFundReport(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				//cld.add(Calendar.DATE, -1);
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
			}
			
			List<InstitutionFundVO> list = saleReportService.getAgentFundReport(form);
			model.addAttribute("list",list);
			if(list!=null &&list.size()> 0){
				InstitutionFundVO sum = saleReportService.getAgentFundReportSum(form);
				model.addAttribute("sum",sum);
			}
			
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
			model.addAttribute("form",form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化销售报表页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		
		return LocaleUtil.getUserLocalePath("report/fund/agentFundReport", request);
	}
	@RequestMapping(params = "method=agentFundReportUSD")
	public String agentFundReportUSD(HttpServletRequest request, ModelMap model,SaleReportForm form) {
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				//cld.add(Calendar.DATE, -1);
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
			}
			
			List<InstitutionFundVO> list = saleReportService.getAgentFundReportUSD(form);
			model.addAttribute("list",list);
			if(list!=null &&list.size()> 0){
				InstitutionFundVO sum = saleReportService.getAgentFundReportUSDSum(form);
				model.addAttribute("sum",sum);
			}
			
			List<InstitutionModel> institutionList = saleReportService.getInstitutionList(currentUser.getInstitutionCode());
			model.addAttribute("institutionList",institutionList);
			model.addAttribute("form",form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化销售报表页面发生异常！", e);
						return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/fund/agentFundReportUSD", request);
	}
}
