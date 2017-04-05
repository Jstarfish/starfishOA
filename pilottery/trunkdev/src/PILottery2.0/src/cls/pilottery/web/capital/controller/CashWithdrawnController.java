package cls.pilottery.web.capital.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.capital.form.CashWithdrawnForm;
import cls.pilottery.web.capital.model.InstitutionAccount;
import cls.pilottery.web.capital.model.ResulstMessage;
import cls.pilottery.web.capital.model.withdrawnmodel.CashWithdrawn;
import cls.pilottery.web.capital.service.CashWithdrawnService;
import cls.pilottery.web.outlet.service.OutletTopUpsService;
import cls.pilottery.web.system.model.User;

/**
 * 部门提现
 */
@Controller
@RequestMapping("orgsWithdrawnRecords")
public class CashWithdrawnController {

	static Logger logger = Logger.getLogger(CashWithdrawnController.class);
	/**
	 * 部门提现列表
	 */
	@Autowired
	private CashWithdrawnService cashWithdrawnService;
	@Autowired
	private OutletTopUpsService outletTopUpsService;

	private Map<Integer,String> cashWithdrawnStatus = EnumConfigEN.cashWithdrawnStatus;
	
	@ModelAttribute("cashWithdrawnStatus")
	public Map<Integer,String> getCashWithdrawnStatus(HttpServletRequest request)
	{
	if(request != null)
			this.cashWithdrawnStatus =LocaleUtil.getUserLocaleEnum("cashWithdrawnStatus", request);
		
		return cashWithdrawnStatus;
	}
	
	@RequestMapping(params = "method=listRecords")
	public String listCashWithdrawn(HttpServletRequest request, Model model,
			CashWithdrawnForm cashWithdrawnForm) {
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		cashWithdrawnForm.setAoCode(currentUser.getInstitutionCode());
		Integer count = cashWithdrawnService
				.getInstitutionCashWithdrawnCount(cashWithdrawnForm);
		int pageIndex = PageUtil.getPageIndex(request);

		List<CashWithdrawn> list = new ArrayList<CashWithdrawn>();
		if (count != null && count.intValue() != 0) {
			cashWithdrawnForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			cashWithdrawnForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
					+ PageUtil.pageSize);
			cashWithdrawnForm.setAccountType(1);
			list = cashWithdrawnService.getInstitutionCashWithdrawnList(cashWithdrawnForm);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("cashWithdrawnForm", cashWithdrawnForm);

		return LocaleUtil.getUserLocalePath("capital/cashWithdrawn/listCashWithdrawn", request);
	}

	/*
	 * 撤销提现申请
	 */
	@ResponseBody
	@RequestMapping(params = "method=cancelWithdrawn", method = RequestMethod.GET)
	public String cancelWithdrawn(HttpServletRequest request) {
		String fundNo = request.getParameter("fundNo");
		// note: 这里的result只是为了返回值
		String result = null;
		try {
			// 修改状态为2(已取消)
			cashWithdrawnService.modifyWithdrawnStatus(fundNo, 2);
		} catch (Exception e) {
			logger.error("撤销提现申请出现异常,异常信息:" + e.getMessage(), e);
			result = "Cancel Failed : System Error！";
		}
		return result;
	}

	/* 删除提现申请 */
	@ResponseBody
	@RequestMapping(params = "method=deleteWithdrawn")
	public ResulstMessage deleteWithdrawn(HttpServletRequest request,
			ModelMap model) {
		String fundNo = request.getParameter("fundNo");
		ResulstMessage resulst = new ResulstMessage();
		try {
			cashWithdrawnService.deleteWithdrawn(fundNo);
		} catch (Exception e) {
			logger.error("删除提现申请出现异常,异常信息:" + e.getMessage(), e);
			resulst.setMessage("failed");
		}
		return resulst;
	}

	/* 提现申请初始化*/
	@RequestMapping(params = "method=addWithdrawnInit")
	public String addWithdrawnInit(HttpServletRequest request, ModelMap model)
			throws Exception {
		HttpSession session=request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		
		InstitutionAccount institutionAccountList = new InstitutionAccount();
		institutionAccountList = cashWithdrawnService.getInstitutionAccountList(currentUser.getInstitutionCode());
		model.addAttribute("institutionAccountList", institutionAccountList);
		return LocaleUtil.getUserLocalePath("capital/cashWithdrawn/addCashWithdrawn", request);
	}

	/**
	 * 部门 代理商的提现 申请
	 */
	@RequestMapping(params = "method=addWithdrawn", method = RequestMethod.POST)
	public String addWithdrawn(HttpSession session, HttpServletRequest request,
			ModelMap model, CashWithdrawnForm cashWithdrawnForm)
			throws Exception {
		User currentUser = (User) session
				.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		cashWithdrawnForm.setApplyAdmin(currentUser.getId());
		cashWithdrawnForm.setAoCode(currentUser.getInstitutionCode());
		try {
			String orgCode = request.getParameter("orgCode");
			String orgName = request.getParameter("orgName");
			String applyAmount = request.getParameter("applyAmount");
			//cashWithdrawnForm.setAoCode(orgCode);
			cashWithdrawnForm.setAoName(orgName);
			cashWithdrawnForm.setApplyAmount(Long.parseLong(applyAmount));
			cashWithdrawnForm.setAccountType(1);
			// note:根据联动获取到的账户余额  得到 账户表的AccNO的值 再insert（之前没有取得AccNo的值）
			String accNo=cashWithdrawnService.getAccNoByOrgCode(orgCode);
			//Long bno = cashWithdrawnForm.getAccountBalance();
			cashWithdrawnForm.setAccNo(accNo);
			// 采用相同的sql 项目起不来，两个提现申请采用同一个service
			outletTopUpsService.forOutletCashWithdrawn(cashWithdrawnForm);
			return LocaleUtil.getUserLocalePath("common/successTip", request);
		} catch (Exception e) {
			//model.addAttribute("system_message", e.getMessage());
			logger.error("部门代理商提现申请功能发生异常！" + e);
			e.printStackTrace();
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
	}
}
