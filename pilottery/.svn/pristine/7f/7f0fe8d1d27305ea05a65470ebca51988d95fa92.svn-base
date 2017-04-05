package cls.pilottery.web.checkTickets.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.checkTickets.form.CheckInquiryForm;
import cls.pilottery.web.checkTickets.form.CheckStatisticForm;
import cls.pilottery.web.checkTickets.form.ScanTicketDataForm;
import cls.pilottery.web.checkTickets.model.CheckStatisticVo;
import cls.pilottery.web.checkTickets.model.CheckStatisticsInfo;
import cls.pilottery.web.checkTickets.model.GameBatchInfo;
import cls.pilottery.web.checkTickets.model.InquiryMain;
import cls.pilottery.web.checkTickets.model.InquirySecondary;
import cls.pilottery.web.checkTickets.service.CheckStatisticService;
import cls.pilottery.web.checkTickets.service.InquiryService;
import cls.pilottery.web.checkTickets.service.ScanTicketService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("/checktickets")
public class CheckTicketController {

	static Logger logger = Logger.getLogger(CheckTicketController.class);

	@Autowired
	private CheckStatisticService checkStatisticService;

	@Autowired
	private InquiryService inquiryService;

	@Autowired
	private ScanTicketService scanTicketService;

	@ResponseBody
	@RequestMapping(params = "method=getGameBatchInfo")
	public List<GameBatchInfo> getGameBatchInfo(HttpServletRequest request) {

		List<GameBatchInfo> listBatchInfo = this.scanTicketService.getGameBatchInfo();
		return listBatchInfo;
	}

	@RequestMapping(params = "method=scanTickets")
	public String scanTickets(HttpServletRequest request , ModelMap model) throws Exception {

		return "checkTickets/scanTickets";
	}
	@RequestMapping(params="method=submitTicketData")
	public String submitTicketData(HttpServletRequest request, ModelMap model, 
			@ModelAttribute("scanTicketDataForm") ScanTicketDataForm scanTicketDataForm) throws Exception
	{
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		scanTicketDataForm.setOper(currentUser.getId());
		this.scanTicketService.submitTicketData(scanTicketDataForm);
		if(scanTicketDataForm.getC_errcode()==0){
			String flow=scanTicketDataForm.getPayflow();
			List<InquirySecondary> scanDetail = inquiryService.getScanDetail(flow);
			List<InquirySecondary> scanMain = inquiryService.getInquiryByFlow(flow);
			Map<Integer, String> local = LocaleUtil.getUserLocaleEnum("oldTicket", request);
			for (InquirySecondary main : scanMain) {
				if (main.getTicketsNo() != null || main.getTicketsNo() != "") {
					main.setTicketsNo(main.getTicketsNo());
				}
				main.setPaidStatusEn(local.get(main.getPaidStatus()));
			}
			model.addAttribute("pageUp", scanDetail);
			model.addAttribute("pageDown", scanMain);
			return "checkTickets/inquiryCheckedTicketsDetail";
			
		}
		else{
			model.addAttribute("system_message",scanTicketDataForm.getC_errmsg());
			return "common/errorTip";
		}
	}
	@RequestMapping(params = "method=inquiryCheckedTickets")
	public String inquiryCheckedTickets(HttpServletRequest request , ModelMap model , CheckInquiryForm form)
			throws Exception {

		User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String orgCode = currentUser.getInstitutionCode();
		form.setOrgCode(orgCode);
		int count = inquiryService.getScanCount(form);
		int pageIndex = PageUtil.getPageIndex(request);
		List<InquiryMain> list = new ArrayList<InquiryMain>();
		if (count != 0) {
			form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			list = inquiryService.getScanList(form);
		}
		model.addAttribute("form", form);
		model.addAttribute("list", list);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		return "checkTickets/inquiryCheckedTickets";
	}

	@RequestMapping(params = "method=detailQuiry")
	public String detailQuiry(HttpServletRequest request , ModelMap model) throws Exception {

		String flow = request.getParameter("flow");
		List<InquirySecondary> scanDetail = inquiryService.getScanDetail(flow);
		List<InquirySecondary> scanMain = inquiryService.getInquiryByFlow(flow);
		Map<Integer, String> local = LocaleUtil.getUserLocaleEnum("oldTicket", request);
		for (InquirySecondary main : scanMain) {
			if (main.getTicketsNo() != null || main.getTicketsNo() != "") {
				main.setTicketsNo(main.getTicketsNo());
			}
			main.setPaidStatusEn(local.get(main.getPaidStatus()));
		}
		model.addAttribute("pageUp", scanDetail);
		model.addAttribute("pageDown", scanMain);
		return "checkTickets/inquiryCheckedTicketsDetail";
	}

	@RequestMapping(params = "method=statisticalReports")
	public String statisticalReports(HttpServletRequest request , ModelMap model , CheckStatisticForm form)
			throws Exception {

		User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String orgCode = currentUser.getInstitutionCode();
		Calendar cld = Calendar.getInstance();
		// cld.add(Calendar.DATE, -1);
		String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
		form.setBeginDate(defaultDate);
		form.setEndDate(defaultDate);
		form.setOrgCode(orgCode);
		model.addAttribute("form", form);
		model.addAttribute("orgCode", orgCode);
		List<CheckStatisticVo> listchek = this.checkStatisticService.getCheckStatisticList(form);
		model.addAttribute("listchek", listchek);
		return "checkTickets/statisticalReports";
	}

	@RequestMapping(params = "method=querystatisticalReports" , method = RequestMethod.POST)
	public String querystatisticalReports(HttpServletRequest request , ModelMap model , CheckStatisticForm form)
			throws Exception {

		User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String orgCode = currentUser.getInstitutionCode();
		form.setOrgCode(orgCode);
		List<CheckStatisticVo> listchek = this.checkStatisticService.getCheckStatisticList(form);
		model.addAttribute("form", form);
		model.addAttribute("orgCode", orgCode);
		model.addAttribute("listchek", listchek);
		return "checkTickets/statisticalReports";
	}

	@RequestMapping(params = "method=refusedRecords")
	public String refusedRecords(HttpServletRequest request , ModelMap model , CheckStatisticForm form) {

		User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String orgCode = currentUser.getInstitutionCode();
		form.setOrgCode(orgCode);
		List<CheckStatisticVo> listchek = this.checkStatisticService.getRefuseRecordsListInfo(form);
		model.addAttribute("listchek", listchek);
		return "checkTickets/refueseReports";
	}
	
	@RequestMapping(params = "method=getStatisticInfo")
	public String getStatisticInfo(HttpServletRequest request , ModelMap model) throws Exception {
		String flow = request.getParameter("flow");
		List<CheckStatisticsInfo> list = inquiryService.getStatisticInfo(flow);
		model.addAttribute("list", list);
		return "checkTickets/checkStatisticsDetail";
	}
}
