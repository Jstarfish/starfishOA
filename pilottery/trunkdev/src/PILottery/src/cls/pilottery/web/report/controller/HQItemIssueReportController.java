package cls.pilottery.web.report.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.web.report.form.HQItemIssueReportForm;
import cls.pilottery.web.report.model.HQItemIssueReportVo;
import cls.pilottery.web.report.service.HQItemIssueReportService;
import cls.pilottery.web.warehouses.model.WarehouseInfo;

@Controller
@RequestMapping("hqItemIssueReport")
public class HQItemIssueReportController {

	@Autowired
	private HQItemIssueReportService hqItemIssueReportService;
	
	@RequestMapping(params="method=initHQItemIssueReport")
	public String initHQItemIssueReport(HttpServletRequest request, ModelMap model, 
			@ModelAttribute("hqItemIssueReportForm") HQItemIssueReportForm hqItemIssueReportForm) throws Exception
	{
		List<WarehouseInfo> hqWarehouseList = hqItemIssueReportService.getAllWarehouseUnderHQ();
		
		if (isNullOrEmpty(hqItemIssueReportForm.getStartDate()) && isNullOrEmpty(hqItemIssueReportForm.getEndDate()))
		{
			Calendar calendar = Calendar.getInstance();
			String today = (new SimpleDateFormat("yyyy-MM-dd")).format(calendar.getTime());
			hqItemIssueReportForm.setStartDate(today);
			hqItemIssueReportForm.setEndDate(today);
		}
		else if (isNullOrEmpty(hqItemIssueReportForm.getStartDate()) && !isNullOrEmpty(hqItemIssueReportForm.getEndDate()))
		{
			hqItemIssueReportForm.setStartDate(hqItemIssueReportForm.getEndDate());
		}
		else if (!isNullOrEmpty(hqItemIssueReportForm.getStartDate()) && isNullOrEmpty(hqItemIssueReportForm.getEndDate()))
		{
			hqItemIssueReportForm.setEndDate(hqItemIssueReportForm.getStartDate());
		}
		else {}
		
		List<HQItemIssueReportVo> reportVoList = this.hqItemIssueReportService.getHQItemIssueReportList(hqItemIssueReportForm);
		
		model.addAttribute("reportVoList", reportVoList);
		model.addAttribute("hqWarehouseList", hqWarehouseList);
		model.addAttribute("hqItemIssueReportForm", hqItemIssueReportForm);
		
		return "report/hqItemIssueReport";
	}
	
	private boolean isNullOrEmpty(String s)
	{
		return s == null || s.isEmpty();
	}
}
