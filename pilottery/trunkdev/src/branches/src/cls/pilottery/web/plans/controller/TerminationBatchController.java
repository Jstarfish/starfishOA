package cls.pilottery.web.plans.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.payout.service.PayoutService;
import cls.pilottery.web.plans.form.PlanForm;
import cls.pilottery.web.plans.form.TicketsNum;
import cls.pilottery.web.plans.model.BatchPublisher;
import cls.pilottery.web.plans.model.BatchTermination;
import cls.pilottery.web.plans.service.PlanService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("/termination")
public class TerminationBatchController {

	Logger logger = Logger.getLogger(TerminationBatchController.class);

	@Autowired
	private PlanService planService;

	@Autowired
	private PayoutService service;

	public PlanService getPlanService() {

		return planService;
	}

	public void setPlanService(PlanService planService) {

		this.planService = planService;
	}

	@RequestMapping(params = "method=initBathTermination")
	public String initTermimnateBatch(HttpServletRequest request , ModelMap model) throws Exception {

		String insCode = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION))
				.getInstitutionCode();
		PlanForm planForm = new PlanForm();
		planForm.setInsCode(insCode);
		Integer count = planService.getBatchCount(planForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<BatchPublisher> batchList = new ArrayList<BatchPublisher>();
		if (count != null && count.intValue() != 0) {
			planForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			planForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			batchList = planService.getBatchList(planForm);
			Map<Integer, String> local = LocaleUtil.getUserLocaleEnum("batchStatus", request);
			for (BatchPublisher batch : batchList) {
				batch.setStatusen(local.get((int) batch.getStatus()));
			}
		}
		model.addAttribute("batchList", batchList);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		return LocaleUtil.getUserLocalePath("inventory/batchTerminate/listBatch", request);
	}

	@RequestMapping(params = "method=detailsBatch")
	public String detailsBatch(HttpServletRequest request , ModelMap model) throws Exception {

		String planCode = request.getParameter("planCode");
		String batchNo = request.getParameter("batchNo");
		PlanForm form = new PlanForm();
		form.setPlanCodeQuery(planCode);
		form.setBatchNoQuery(batchNo);
		TicketsNum tickets = planService.getTicket(form);
		model.addAttribute("tickets", tickets);
		return LocaleUtil.getUserLocalePath("inventory/batchTerminate/detailsBatch", request);
	}
	@RequestMapping(params = "method=detailsBatchPrint")
	public String detailsBatchPrint(HttpServletRequest request , ModelMap model) throws Exception {
		
		String planCode = request.getParameter("planCode");
		String batchNo = request.getParameter("batchNo");
		int completed=service.isCompleted(planCode,batchNo);
		if(completed!=0){
			model.addAttribute("system_message", "The batch receipt has not completed.");
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		String planName = request.getParameter("planName");
		planName=URLDecoder.decode(URLEncoder.encode(planName, "ISO-8859-1"), "UTF-8");
		PlanForm form = new PlanForm();
		form.setPlanCodeQuery(planCode);
		form.setBatchNoQuery(batchNo);
		TicketsNum tickets = planService.getTicket(form);
		model.addAttribute("tickets", tickets);
		model.addAttribute("planCode", planCode);
		model.addAttribute("planName", planName);
		model.addAttribute("batchNo", batchNo);
		return LocaleUtil.getUserLocalePath("inventory/batchTerminate/detailsBatchPrint", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=liandong")
	public List<String> getFirstCode(String planCode) {

		return planService.getBatchOnWork(planCode);
	}

	@ResponseBody
	@RequestMapping(params = "method=liandong1")
	public TicketsNum getSecend(HttpServletRequest request) {

		PlanForm form = new PlanForm();
		String code = request.getParameter("planCode");
		String no = request.getParameter("batchNo");
		form.setPlanCodeQuery(code);
		form.setBatchNoQuery(no);
		TicketsNum tickets = planService.getTicket(form);
		return tickets;
	}

	@ResponseBody
	@RequestMapping(params = "method=initTerBatch")
	public String initTerBatch(HttpServletRequest request) {

		String planCode = request.getParameter("planCode");
		String batchCode = request.getParameter("batchCode");
		BatchPublisher form = new BatchPublisher();
		form.setBatchNo(batchCode);
		form.setPlanCode(planCode);
		int isWork = planService.isWorking(form);
		if (isWork == 1) {
			return "error";
		}
		return "success";
	}

	@RequestMapping(params = "method=terBatch")
	public String batchTermination(HttpServletRequest request,ModelMap model) throws Exception {

		String planCode = request.getParameter("planCode");
		String batchCode = request.getParameter("batchCode");
		String planName = request.getParameter("planName");
		planName=URLDecoder.decode(URLEncoder.encode(planName, "ISO-8859-1"), "UTF-8");
		long userId = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getId();
		BatchPublisher publisher = planService.getDetailBatchTermination(planCode, batchCode, userId);
		if (publisher.getErrorCode() == 0) {
			model.addAttribute("url", "termination.do?method=print&planCode="+planCode+"&planName="+planName+"&batchNo="+batchCode);
			return "inventory/batchTerminate/success";
		}
		logger.error("errormsgs" + publisher.getErrorMessage());
		model.addAttribute("system_message", publisher.getErrorMessage());
		return LocaleUtil.getUserLocalePath("common/errorTip", request);
	}

	@RequestMapping(params = "method=print")
	public String print(HttpServletRequest request , ModelMap model) throws UnsupportedEncodingException {

		String planCode = request.getParameter("planCode");
		String batchCode = request.getParameter("batchNo");
		String planName = request.getParameter("planName");
		//底层在调用getParameter时会偷偷做一次ISO-8859-1解码。。
		planName=URLDecoder.decode(URLEncoder.encode(planName, "ISO-8859-1"), "UTF-8");
		System.out.println();
		System.out.println(planName);
		System.out.println();
		BatchPublisher publisher = new BatchPublisher();
		publisher.setPlanName(planName);
		publisher.setPlanCode(planCode);
		publisher.setBatchNo(batchCode);
		long userId = ((User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION)).getId();
		String username = service.getUsername(userId);
		BatchTermination batch = planService.infoBatchTermination(publisher);
		model.addAttribute("username", username);
		model.addAttribute("publisher", publisher);
		model.addAttribute("batch", batch);
		model.addAttribute("date", new Date());
		return LocaleUtil.getUserLocalePath("inventory/batchTerminate/print", request);
	}
	
}
