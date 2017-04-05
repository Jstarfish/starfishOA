package cls.pilottery.web.monitor.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.monitor.form.MonitorForm;
import cls.pilottery.web.monitor.model.AreasInfo;
import cls.pilottery.web.monitor.model.OrgSalesDrillDownModel;
import cls.pilottery.web.monitor.model.OrgSalesModel;
import cls.pilottery.web.monitor.model.RankingModel;
import cls.pilottery.web.monitor.model.SummaryStatisticsModel;
import cls.pilottery.web.monitor.service.MonitorService;
import cls.pilottery.web.plans.model.Plan;
import cls.pilottery.web.plans.service.PlanService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("/monitor")
public class MonitorController {
	static Logger logger = Logger.getLogger(MonitorController.class);
	
	@Autowired
	private MonitorService monitorService;
	@Autowired
	private PlanService planService;

	@ModelAttribute("planMap")
	public Map<String, String> getOrgsMap() {
		Map<String, String> planMap = new HashMap<String, String>();
		List<Plan> infPlanList = planService.getInfPlanList();
		for (Plan ifo : infPlanList) {
			planMap.put(ifo.getPlanCode(), ifo.getFullName());
		}
		return planMap;
	}
	
	// 3.1 游戏销量监控
	@RequestMapping(params = "method=salesRealTime")
	public String salesRealTime(HttpServletRequest request, ModelMap model)
			throws Exception {
		User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String planCode = request.getParameter("planCode");
		Map<String,List<Long>> chart =monitorService.getHoursSalesTrend(currentUser.getInstitutionCode(),planCode);
		String chartJson = JSONObject.toJSONString(chart);
		model.addAttribute("chart",chartJson);
		model.addAttribute("planCode",planCode);
		return "monitor/salesRealTime";
	}
	
	//3.2 部门监控统计
	@ResponseBody
	@RequestMapping(params="method=updateInstitutionSalesData")
	public Map<String, Object> updateInstitutionSalesData(HttpServletRequest request, ModelMap model) throws Exception
	{
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		
		Map<String,Object> dateMap = new HashMap<String,Object>();
		dateMap.put("startDate", startDate);
		dateMap.put("endDate", endDate);
		
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			dateMap.put("sessionOrgCode", "00");
		} else {
			dateMap.put("sessionOrgCode", currentUser.getInstitutionCode());
		}
		
		List<Object> sales = new ArrayList<Object>();
		List<Object> incomes = new ArrayList<Object>();
		List<String> categories = new ArrayList<String>();
		
		List<OrgSalesModel> dataList = monitorService.getDataForOrgSales(dateMap);
		for (int i = 0; i < dataList.size(); i++) {
			//categories
			categories.add(dataList.get(i).getOrgName());
			Map<String, Object> saleItem = new HashMap<String, Object>();
			Map<String, Object> incomeItem = new HashMap<String, Object>();
			
			//y
			saleItem.put("y", dataList.get(i).getSalesAmount());
			incomeItem.put("y", dataList.get(i).getIncome());
			
			//drilldown
			Map<String, Object> drilldownSales = new HashMap<String, Object>();
			Map<String, Object> drilldownIncome = new HashMap<String, Object>();
			
			//drilldown name
			drilldownSales.put("name", dataList.get(i).getOrgName());
			drilldownIncome.put("name", dataList.get(i).getOrgName());
			
			//call dao
			dateMap.put("orgCode", dataList.get(i).getOrgCode());
			List<OrgSalesDrillDownModel> drillList = monitorService.getDataForOrgSalesDrillDown(dateMap);
			
			//make drilldown raw data
			List<String> drillCategories = new ArrayList<String>();
			List<Long> drillSalesData = new ArrayList<Long>();
			List<Long> drillIncomeData = new ArrayList<Long>();
			for (int j = 0; j < drillList.size(); j++) {
				drillCategories.add(drillList.get(j).getFullName());
				drillSalesData.add(drillList.get(j).getSalesAmount());
				drillIncomeData.add(drillList.get(j).getIncome());
			}
			
			//drilldown categories
			drilldownSales.put("categories", drillCategories);
			drilldownIncome.put("categories", drillCategories);
			
			//drilldown data
			drilldownSales.put("data", drillSalesData);
			drilldownIncome.put("data", drillIncomeData);
			
			//attach drilldown data
			saleItem.put("drilldown", drilldownSales);
			incomeItem.put("drilldown", drilldownIncome);
			
			//attach item to data list
			sales.add(saleItem);
			incomes.add(incomeItem);
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("categories", categories);
		resultMap.put("sales", sales);
		resultMap.put("incomes", incomes);
		return resultMap;
	}
	
	@RequestMapping(params="method=institutionSales")
	public String institutionSales(HttpServletRequest request, ModelMap model) throws Exception
	{
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Calendar calendar = Calendar.getInstance();
		String endDate = dateFormat.format(calendar.getTime());
		calendar.add(Calendar.DATE, -30);
		String startDate = dateFormat.format(calendar.getTime());
		
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		return "monitor/institutionSales";
	}
	
	//3.3 游戏销售监控
	@RequestMapping(params="method=salesStatistics")
	public String salesStatistics(HttpServletRequest request, ModelMap model) throws Exception
	{
		return "monitor/salesStatistics";
	}
	@ResponseBody
	@RequestMapping(params="method=salesResponse")
	public Map<String, Object> salesByYearRes(HttpServletRequest request) throws Exception{
		String year = request.getParameter("year");
		User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String insCode=currentUser.getInstitutionCode();
		Map<String, Object> salePerByYear = monitorService.getSalePerByYear(year,insCode);
		return salePerByYear;
	}
	// 3.4 站点销售排行
	@RequestMapping(params = "method=outletRankings")
	public String outletRankings(HttpServletRequest request, ModelMap model,MonitorForm form) throws Exception {
		int count = 0;
		List<RankingModel> list = null;
		
		try {
			User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setOrgCode(currentUser.getInstitutionCode());
			int pageIndex = PageUtil.getPageIndex(request);
			count = monitorService.getOutletRankingCount(form);
			
			if (count > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = monitorService.getOutletRankingList(form);
			}
			
			List<AreasInfo> areasList =  monitorService.getAreasInfo(currentUser.getInstitutionCode());
			model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
			model.addAttribute("pageDataList", list);
			model.addAttribute("form",form);
			model.addAttribute("areasList",areasList);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message",e.getMessage());
			logger.error("查询站点排行发生异常！", e);
			return "_common/errorTip";
		}
		
		return "monitor/outletRankings";
	}

	
	// 3.5 监控统计图汇总
	@RequestMapping(params = "method=summaryStatistics")
	public String summaryStatistics(HttpServletRequest request, ModelMap model) throws Exception {
		User cu = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		Map<String, List<Long>> chart1 = monitorService.getHoursSaleForSummaryTotal(cu.getInstitutionCode());
		String chart1Json = JSONObject.toJSONString(chart1);
		model.addAttribute("chart1", chart1Json);
		
		Map<String, List<Long>> chart2 = monitorService.getHoursSaleForSummary(cu.getInstitutionCode());
		String chart2Json = JSONObject.toJSONString(chart2);
		model.addAttribute("chart2", chart2Json);
		
		List<SummaryStatisticsModel> chart3 = monitorService.getSalePerByGames(cu.getInstitutionCode());
		String chart3Json = JSONObject.toJSONString(chart3);
		model.addAttribute("chart3", chart3Json);

		List<SummaryStatisticsModel> chart4 = null;
		if (cu.getInstitutionCode().equals("00")) {
			chart4 = monitorService.getSalePerByInstitution();
		} else {
			chart4 = monitorService.getRankingByInstitution(cu.getInstitutionCode());
		}
		String chart4Json = JSONObject.toJSONString(chart4);
		model.addAttribute("chart4", chart4Json);
		model.addAttribute("orgCode",cu.getInstitutionCode());

		return "monitor/summaryStatistics";
	}
}
