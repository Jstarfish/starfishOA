package cls.pilottery.web.outlet.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.MD5Util;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.capital.form.CashWithdrawnForm;
import cls.pilottery.web.capital.model.ManagerAccountModel;
import cls.pilottery.web.capital.model.MarketManager;
import cls.pilottery.web.capital.model.OutletAccount;
import cls.pilottery.web.capital.service.ManagerAcctService;
import cls.pilottery.web.capital.service.OutletAcctService;
import cls.pilottery.web.outlet.form.OutletTopUpsForm;
import cls.pilottery.web.outlet.model.Agencys;
import cls.pilottery.web.outlet.model.OutletTopUps;
import cls.pilottery.web.outlet.service.OutletTopUpsService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("/outletInfo")
public class OutletInfoController {
	static Logger logger = Logger.getLogger(OutletInfoController.class);

	/**
	 * 站点信息查询列表  充值和提现功能
	 * 
	 */
	@Autowired
	private OutletTopUpsService outletTopUpsService;
	
	@Autowired
	private ManagerAcctService managerAcctService;

	/**
	 * 站点充值记录列表
	 */
	@RequestMapping(params = "method=listOutletInfo")
	public String listTopUps(HttpServletRequest request, ModelMap model,HttpSession session,
			OutletTopUpsForm outletTopUpsForm) {
		List<OutletTopUps> list = null;
		int count = 0;
		try{
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			outletTopUpsForm.setCurrentUserId(currentUser.getId().intValue());
			int pageIndex = PageUtil.getPageIndex(request);
			count = outletTopUpsService.getOutletTopUpsCount(outletTopUpsForm);
			if (count > 0) {
				outletTopUpsForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				outletTopUpsForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = outletTopUpsService.getOutletTopUpsList(outletTopUpsForm);
			}
		}catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			logger.error("查询站点信息列表功能发生异常！", e);
			return "common/errorTip";
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("outletTopUpsForm", outletTopUpsForm);
		return LocaleUtil.getUserLocalePath("outletService/outletInformation/listOutletTopUps", request);
		}

	/**
	 *  充值部门名称、编码级联
	 */
/*	@ResponseBody
	@RequestMapping(params = "method=getOrgsCode")
	public InfOrgs getOutletName(HttpServletRequest request){
		String orgCode=request.getParameter("orgCode");
		InfOrgs inforgsCode=this.outletTopUpsService.getOrgInfoByOrgCode(orgCode);
		return inforgsCode;
	}
	*/
	
	/**
	 * 充值准备
	 */
	@RequestMapping(params = "method=initOutletTopUps")
	public String initOutletTopUps(HttpServletRequest request, ModelMap model)
			throws Exception {
		HttpSession session = request.getSession();
		User currentUser = (User) session
				.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		ManagerAccountModel marketManager = new ManagerAccountModel();
		marketManager = managerAcctService.getManagerAcctInfo(currentUser
				.getId().toString());
		model.addAttribute("marketManager", marketManager);
		String agencyCode = request.getParameter("agencyCode");
		Agencys outletTopUpsForm = outletTopUpsService
				.getAgencyName(agencyCode);
		model.addAttribute("OutletTopUpsForm", outletTopUpsForm);
		List<OutletTopUps> OutletTopUpsForm2 = outletTopUpsService
				.getOutletTopUpsById(agencyCode);
		model.addAttribute("OutletTopUpsForm2", OutletTopUpsForm2);
		return LocaleUtil.getUserLocalePath("outletService/outletInformation/topUps", request);
	}
	
	/**
	 * 进行充值
	 */
	@RequestMapping(params = "method=OutletTopUps")
	public String topUps(HttpSession session, ModelMap model,HttpServletRequest request,
			OutletTopUpsForm outletTopUpsForm) throws Exception {
		User currentUser = (User) session
				.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		outletTopUpsForm.setMarketManagerId(currentUser.getId());
		// outletTopUpsForm.setMarketManagerId(Long.valueOf(122));
		outletTopUpsForm.setPassword(MD5Util.MD5Encode(outletTopUpsForm
				.getPassword()));
		outletTopUpsService.forOutletTopup(outletTopUpsForm);
		model.addAttribute("url", "outletInfo.do?method=certificate&fundId="
				+ outletTopUpsForm.getFundId());
		if (outletTopUpsForm.getC_errcode() != 0) {
			try {
				throw new Exception(outletTopUpsForm.getC_errmsg());
			} catch (Exception e) {
				model.addAttribute("system_message", e.getMessage());
				logger.error("站点充值功能发生异常！" + e);
				e.printStackTrace();
				return "common/errorTip";
			}
		}
		return LocaleUtil.getUserLocalePath("outletService/outletInformation/success", request);
		//return "outletService/outletInformation/success";
	}
	
	// 打印凭证 获取信息
	@RequestMapping(params = "method=certificate")
	public String certificate(HttpServletRequest request, ModelMap model,
			String fundId) {
		OutletTopUps topUpsInfo = outletTopUpsService
				.getOutletTopUpsByPk(fundId);
		model.addAttribute("topUpsInfo", topUpsInfo);
		model.addAttribute("date", new Date());
		return LocaleUtil.getUserLocalePath("outletService/outletInformation/certificate", request);
	}

	/**
	 * 提现申请准备
	 */
	@RequestMapping(params = "method=initOutletWithdrawn")
	public String initOutletWithdrawn(HttpServletRequest request, ModelMap model)
			throws Exception {
		String agencyCode = request.getParameter("agencyCode");
		Agencys outletWithdrawnForm = outletTopUpsService
				.getAgencyName(agencyCode);
		OutletAccount outletWithdrawnForm1 = outletTopUpsService
				.getAgencyBalance(agencyCode);
		model.addAttribute("outletWithdrawnForm", outletWithdrawnForm);
		model.addAttribute("outletWithdrawnForm1", outletWithdrawnForm1);
		// model.addAttribute("agencyCode", agencyCode);
		return LocaleUtil.getUserLocalePath("outletService/outletInformation/withdrawn", request);
	}
		
	/**
	 * 提现 申请
	 */
	@RequestMapping(params = "method=OutletCashWithdrawn")
	public String CashWithdrawn(HttpSession session, ModelMap model,
			CashWithdrawnForm cashWithdrawnForm) throws Exception {
		User currentUser = (User) session
				.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		cashWithdrawnForm.setApplyAdmin(currentUser.getId());
		try {
			cashWithdrawnForm.setAccountType(2);
			outletTopUpsService.forOutletCashWithdrawn(cashWithdrawnForm);
			return "common/successTip";
		} catch (Exception e) {
			model.addAttribute("system_message", e.getMessage());
			logger.error("站点提现申请功能发生异常！" + e);
			e.printStackTrace();
			return "common/errorTip";
		}
	}
}

