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
import cls.pilottery.web.report.form.SaleReportForm;
import cls.pilottery.web.report.model.PayoutReportModel;
import cls.pilottery.web.report.service.PayoutReportService;
import cls.pilottery.web.sales.model.PlanModel;
import cls.pilottery.web.sales.service.OrderService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("report")
public class PayoutReportController {

	Logger log = Logger.getLogger(PayoutReportController.class);

	@Autowired
	private OrderService orderService;

	@Autowired
	private PayoutReportService payoutReportService;

	@RequestMapping(params = "method=initPayoutReports")
	public String initGameSalesReport(HttpServletRequest request , ModelMap model , SaleReportForm form) {
		
		try {
			Calendar cld = Calendar.getInstance();
			String insCode = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getInstitutionCode();
			String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
			form.setBeginDate(defaultDate);
			form.setEndDate(defaultDate);
			List<PlanModel> planList = orderService.getPlanListByOrg(insCode);
			model.addAttribute("planList", planList);
			model.addAttribute("form", form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化兑奖报表页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("report/payoutReport", request);
	}

	@RequestMapping(params = "method=getPayoutReport")
	public String getGameSalesReport(HttpServletRequest request , ModelMap model , SaleReportForm form) {

		String insCode = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getInstitutionCode();
		form.setCuserOrg(insCode);
		List<PayoutReportModel> list = null;
		List<PlanModel> planList = null;
		PayoutReportModel payout=null;
		try {
			planList = orderService.getPlanListByOrg(insCode);
			list = payoutReportService.getPayoutList(form);
			payout=payoutReportService.getPayout(form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("查询兑奖列表功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("_common/errorTip", request);
		}
		model.addAttribute("sum", payout);
		model.addAttribute("planList", planList);
		model.addAttribute("pageDataList", list);
		model.addAttribute("form", form);
		return LocaleUtil.getUserLocalePath("report/payoutReport", request);
	}
}
