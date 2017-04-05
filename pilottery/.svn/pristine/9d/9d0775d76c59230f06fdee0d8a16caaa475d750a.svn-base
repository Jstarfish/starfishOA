package cls.pilottery.web.capital.controller;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.capital.form.NewRepaymentForm;
import cls.pilottery.web.capital.form.RepaymentQueryForm;
import cls.pilottery.web.capital.model.MarketManagerAccount;
import cls.pilottery.web.capital.model.RepaymentRecord;
import cls.pilottery.web.capital.service.RepaymentService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("/repayment")
public class RepaymentController {
	static Logger logger = Logger.getLogger(RepaymentController.class);
	
	@Autowired
	private RepaymentService repaymentService;
	
	@RequestMapping(params="method=listRepayment")
	public String listRepaymentRecords(HttpServletRequest request, ModelMap model, @ModelAttribute("repaymentQueryForm") RepaymentQueryForm repaymentQueryForm) throws Exception
	{
		//获得当前用户Session信息
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			repaymentQueryForm.setSessionOrgCode("00");
		} else {
			repaymentQueryForm.setSessionOrgCode(currentUser.getInstitutionCode());
		}
		
		Integer count = repaymentService.getRepaymentCount(repaymentQueryForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<RepaymentRecord> repaymentList = new ArrayList<RepaymentRecord>();
		
		if (count != null && count.intValue() != 0) {
			repaymentQueryForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			repaymentQueryForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			repaymentList = repaymentService.getRepaymentList(repaymentQueryForm);
		}
		
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("repaymentList", repaymentList);
		model.addAttribute("repaymentQueryForm", repaymentQueryForm);
		
		return LocaleUtil.getUserLocalePath("capital/repayments/listRepayment", request);
		//return "capital/repayments/listRepayment";
	}
	
	@RequestMapping(params="method=addRepaymentInit")
	public String addRepaymentInit(HttpServletRequest request, ModelMap model) throws Exception
	{
		//从Session中获得当前用户信息
		String orgCode = "";
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			orgCode = "00";
		} else {
			orgCode = currentUser.getInstitutionCode();
		}
		
		List<MarketManagerAccount> marketManagerAccountList = new ArrayList<MarketManagerAccount>();
		marketManagerAccountList = repaymentService.getMarketManagerAccountList(orgCode);
		model.addAttribute("marketManagerAccountList", marketManagerAccountList);
		
		return LocaleUtil.getUserLocalePath("capital/repayments/addRepayment", request);
		//return "capital/repayments/addRepayment";
	}
	
	@RequestMapping(params="method=addRepayment")
	public String addRepayment(HttpServletRequest request, ModelMap model, @ModelAttribute("newRepaymentForm") NewRepaymentForm newRepaymentForm) throws Exception
	{
		//从Session中获得当前用户id
    	User currentUser = (User)request.getSession().getAttribute("current_user");
    	if (currentUser == null) {
    		newRepaymentForm.setOperatorCode(0);
    	} else {
    		newRepaymentForm.setOperatorCode((Integer)currentUser.getId().intValue());
    	}
		
    	//调用存储过程
		try {
			logger.info("marketManagerCode:" + newRepaymentForm.getMarketManagerCode() +
					    "operatorCode:" + newRepaymentForm.getOperatorCode() +
					    "repaymentAmount" + newRepaymentForm.getRepaymentAmount());
			repaymentService.addRepayment(newRepaymentForm);
			if (newRepaymentForm.getC_errcode().intValue() == 0)
			{
				logger.info("repaymentFlowNumber:" + newRepaymentForm.getRepaymentFlowNumber() + 
						    "balanceBeforeRepayment:" + newRepaymentForm.getBalanceBeforeRepayment() +
						    "balanceAfterRepayment:" + newRepaymentForm.getBalanceAfterRepayment());
				return LocaleUtil.getUserLocalePath("common/successTip", request);
				//return "common/successTip";
			}
			else
			{
				logger.error("errmsgs:" + newRepaymentForm.getC_errmsg());
				model.addAttribute("system_message", newRepaymentForm.getC_errmsg());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
				//return "common/errorTip";
			}
		} catch (Exception e) {
			logger.error("errmsgs:" + e.getMessage());
			model.addAttribute("system_message", e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
			//return "common/errorTip";
		}
	}
	
	@RequestMapping(params="method=printRepaymentCertificate")
	public String printRepaymentCertificate(HttpServletRequest request, ModelMap model) throws Exception
	{
		//获得当前用户Session信息
		StringBuilder operator = new StringBuilder();
		User currentUser = (User)request.getSession().getAttribute("current_user");
		if (currentUser == null) {
			operator.append("Null User");
		} else {
			operator.append(currentUser.getRealName());
    	}
		model.addAttribute("operator", operator);
		
		String repaymentDate = request.getParameter("repaymentDate");
		model.addAttribute("repaymentDate", repaymentDate);
		
		String marketManagerCode = request.getParameter("marketManagerCode");
		model.addAttribute("marketManagerCode", marketManagerCode);
		
		String marketManagerName = request.getParameter("marketManagerName");
		marketManagerName = URLDecoder.decode(URLEncoder.encode(marketManagerName, "ISO-8859-1"), "UTF-8");
		model.addAttribute("marketManagerName", marketManagerName);
		
		String balanceBeforeRepayment = request.getParameter("balanceBeforeRepayment");
		model.addAttribute("balanceBeforeRepayment", balanceBeforeRepayment);
		
		String repaymentAmount = request.getParameter("repaymentAmount");
		model.addAttribute("repaymentAmount", repaymentAmount);
		
		String balanceAfterRepayment = request.getParameter("balanceAfterRepayment");
		model.addAttribute("balanceAfterRepayment", balanceAfterRepayment);
		
		Date date = new Date();
		model.addAttribute("date", date);
		
		return LocaleUtil.getUserLocalePath("capital/repayments/printRepaymentCertificate", request);
		//return "capital/repayments/printRepaymentCertificate";
	}
}
