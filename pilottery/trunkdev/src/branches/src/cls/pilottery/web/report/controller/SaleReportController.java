package cls.pilottery.web.report.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.web.plans.service.PlanService;
import cls.pilottery.web.report.form.SaleReportForm;
import cls.pilottery.web.report.model.InstitutionModel;
import cls.pilottery.web.report.model.InventoryModel;
import cls.pilottery.web.report.model.SalesReportModel;
import cls.pilottery.web.report.model.WarehouseModel;
import cls.pilottery.web.report.service.SaleReportService;
import cls.pilottery.web.sales.model.PlanModel;
import cls.pilottery.web.sales.service.OrderService;
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
			return "common/errorTip";
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
			return "_common/errorTip";
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
			return "common/errorTip";
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
			return "_common/errorTip";
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
			return "common/errorTip";
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
			return "_common/errorTip";
		}
		model.addAttribute("pageDataList", list);
		model.addAttribute("form",form);
		return LocaleUtil.getUserLocalePath("report/inventoryReport", request);
	}
	
}
