package cls.pilottery.web.capital.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.capital.form.CashWithdrawnForm;
import cls.pilottery.web.capital.model.withdrawnmodel.CashWithdrawn;
import cls.pilottery.web.capital.service.CashWithdrawnService;
import cls.pilottery.web.system.model.User;

/**
 * 提现审批
 * 
 * @author jhx
 * 
 */
@Controller
@RequestMapping("cashWithdrawn")
public class ApprovalController {
	private Map<Integer,String> approveAccountType = EnumConfigEN.approveAccountType;
	private Map<Integer,String> cashWithdrawnStatus = EnumConfigEN.cashWithdrawnStatus;

	static Logger logger = Logger.getLogger(ApprovalController.class);
	@Autowired
	private CashWithdrawnService cashWithdrawnService;
	/*
	 * 准备数据-枚举定义
	 */
	@ModelAttribute("approveAccountType")
	public Map<Integer,String> getApproveAccountType(HttpServletRequest request)
	{	
		if(request != null)
		this.approveAccountType =LocaleUtil.getUserLocaleEnum("approveAccountType", request);
		return approveAccountType;
	}
	@ModelAttribute("cashWithdrawnStatus")
	public Map<Integer,String> getApproveType(HttpServletRequest request)
	{	
		if(request != null)
			this.cashWithdrawnStatus =LocaleUtil.getUserLocaleEnum("cashWithdrawnStatus", request);
		return cashWithdrawnStatus;
	}
	/**
	 * 部门和站点所有的提现审批列表和查询
	 */
	@RequestMapping(params = "method=listCashWithdrawn")
	public String listCashWithdrawn(HttpServletRequest request, Model model,
			CashWithdrawnForm newCashWithdrawnForm) {
		//获取当前登录用户的部门编码
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		newCashWithdrawnForm.setAoCode(currentUser.getInstitutionCode());
		Integer count = cashWithdrawnService
				.getCashWithdrawnCount(newCashWithdrawnForm);
		int pageIndex = PageUtil.getPageIndex(request);
		List<CashWithdrawn> list = new ArrayList<CashWithdrawn>();
		if (count != null && count.intValue() != 0) {
			newCashWithdrawnForm.setBeginNum((pageIndex - 1)
					* PageUtil.pageSize);
			newCashWithdrawnForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
					+ PageUtil.pageSize);
			list = cashWithdrawnService
					.getCashWithdrawnList(newCashWithdrawnForm);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("newCashWithdrawnForm", newCashWithdrawnForm);
		return LocaleUtil.getUserLocalePath("capital/cashWithdrawnApproval/listAllCashWithdrawn", request);
	}

	/* 审批初始化 */
	@RequestMapping(params = "method=initApproveWithdrawn")
	public String initApproveWithdrawn(HttpServletRequest request,
			ModelMap model, String fundNo) {
		CashWithdrawn withdrawnInfo = cashWithdrawnService
				.getCashWithdrawnInfoById(fundNo);
		model.addAttribute("withdrawnInfo", withdrawnInfo);
		return LocaleUtil.getUserLocalePath("capital/cashWithdrawnApproval/approval", request);
	}

	/* 进行审批 */
	@RequestMapping(params = "method=approveWithdrawn")
	public String approveWithdrawn(HttpServletRequest request, ModelMap model,
			CashWithdrawnForm cashWithdrawnForm) {
		int checkResult = cashWithdrawnForm.getCheckResult();
		User currentUser = (User) request.getSession().getAttribute(
				SysConstants.CURR_LOGIN_USER_SESSION);
		cashWithdrawnForm.setCheckAdminId(currentUser.getId().intValue());
		cashWithdrawnForm.setApplyMemo("1");
		if(checkResult==1){
			try {
				cashWithdrawnService.approveWithdrawn(cashWithdrawnForm);
				model.addAttribute("url",
				"cashWithdrawn.do?method=withdrawnCertificate&fundNo="
									+ cashWithdrawnForm.getFundNo());
					if (cashWithdrawnForm.getC_errcode() != 0) {
							throw new Exception(cashWithdrawnForm.getC_errmsg());
					}
			} catch (Exception e) {
				model.addAttribute("system_message", e.getMessage());
				logger.error("提现审批功能发生异常！" + e);
				e.printStackTrace();
				return "common/errorTip";
			}
			return LocaleUtil.getUserLocalePath("capital/cashWithdrawnApproval/success", request);
		}
		else{
			cashWithdrawnService.refuseWithdrawn(cashWithdrawnForm);
			return "common/successTip";
		}
	}

	/* 根据提现编号获取 提现信息 */
	/*
	 * @ResponseBody
	 * 
	 * @RequestMapping(params = "method=getCashWithdrawnInfoById") public
	 * CashWithdrawn getCashWithdrawnInfoById(HttpServletRequest request){
	 * String fundNo=request.getParameter("fundNo"); return
	 * this.cashWithdrawnService.getCashWithdrawnInfoById(fundNo); }
	 */

	/* 提现确认初始化 */
	@RequestMapping(params = "method=initConfirm")
	public String initConfirm(HttpServletRequest request, ModelMap model,
			String fundNo) {
		CashWithdrawn withdrawnInfo = cashWithdrawnService
				.getCashWithdrawnInfoById(fundNo);
		System.out.println(withdrawnInfo);
		model.addAttribute("withdrawnInfo", withdrawnInfo);
		return LocaleUtil.getUserLocalePath("capital/cashWithdrawnApproval/confirmWithdrawn", request);
	}

	/* 确认提现喽 */
	@RequestMapping(params = "method=confirm")
	public String confirm(HttpServletRequest request, ModelMap model,
			CashWithdrawnForm cashWithdrawnForm) throws Exception {
		User currentUser = (User) request.getSession().getAttribute(
				SysConstants.CURR_LOGIN_USER_SESSION);
		try {
			cashWithdrawnForm.setCheckAdminId(currentUser.getId().intValue());
			cashWithdrawnService.updateWithdrawnAproval(cashWithdrawnForm);
			return "common/successTip";
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			logger.error("部门和代理商的提现申请功能发生异常！" + e);
			e.printStackTrace();
			return "common/errorTip";
		}
	}

	/* 打印凭证 */
	@RequestMapping(params = "method=withdrawnCertificate")
	public String withdrawnCertificate(HttpServletRequest request,
			ModelMap model, String fundNo) throws Exception {
		CashWithdrawn withdrawnInfos = cashWithdrawnService
				.getCashWithdrawnInfoById(fundNo);
		model.addAttribute("withdrawnInfos", withdrawnInfos);
		model.addAttribute("date", new Date());
		return LocaleUtil.getUserLocalePath("capital/cashWithdrawnApproval/withdrawnCertificate", request);
	}

}
