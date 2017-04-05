package cls.pilottery.web.capital.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.capital.form.TopUpsForm;
import cls.pilottery.web.capital.model.InstitutionAccount;
import cls.pilottery.web.capital.model.ResulstMessage;
import cls.pilottery.web.capital.model.paymodel.TopUps;
import cls.pilottery.web.capital.service.TopUpsService;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.institutions.service.InstitutionsService;
import cls.pilottery.web.system.model.User;

/**
 * 部门资金充值
 * @author jhx
 */

@Controller
@RequestMapping("/topUps")
public class TopUpController {
	static Logger logger = Logger.getLogger(TopUpController.class);

	@Autowired
	private TopUpsService topUpsService;

	@Autowired
	private InstitutionsService institutionsService;

	/**
	 * 数据准备: 部门map
	 */
	@ModelAttribute("orgsMap")
	public Map<String, String> getOrgsMap() {
		Map<String, String> orgsMap = new HashMap<String, String>();
		List<InfOrgs> infOrgsList = institutionsService.getInfOrgsList();
		for (InfOrgs ifo : infOrgsList) {
			orgsMap.put(ifo.getOrgCode(), ifo.getOrgName());
		}
		return orgsMap;
	}

	/**
	 * 充值记录列表和查询
	 */
	@RequestMapping(params = "method=listTopUps")
	public String listTopUps(HttpServletRequest request, ModelMap model,
			TopUpsForm topUpsForm) {
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		topUpsForm.setAoCode(currentUser.getInstitutionCode());
		Integer count = topUpsService.getTopUpsCount(topUpsForm);
		int pageIndex = PageUtil.getPageIndex(request);

		List<TopUps> list = new ArrayList<TopUps>();
		if (count != null && count.intValue() != 0) {
			topUpsForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			topUpsForm.setEndNum((pageIndex - 1) * PageUtil.pageSize
					+ PageUtil.pageSize);
			list = topUpsService.getTopUpsList(topUpsForm);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("topUpsForm", topUpsForm);
		return LocaleUtil.getUserLocalePath("capital/topUps/listTopUps", request);
	}

	/**
	 * 充值部门名称、编码级联
	 */
	@ResponseBody
	@RequestMapping(params = "method=getOrgsCode")
	public ResulstMessage getOrgsCode(HttpServletRequest request) {
		ResulstMessage message =new ResulstMessage();
		String orgCode = request.getParameter("orgCode");
		InfOrgs inforgsCode = this.topUpsService.getOrgInfoByOrgCode(orgCode);
		if(inforgsCode!=null){
			message.setOrgCode(inforgsCode.getOrgCode());
		}
		
		InstitutionAccount inforgsBalance = this.topUpsService.getOrgBalanceByOrgCode(orgCode);
		if(inforgsBalance!=null){
			message.setAccountBalance(inforgsBalance.getAccountBalance());
		}
		return message;
	}

	/**
	 * 充值部门名称、余额级联
	 */
	@ResponseBody
	@RequestMapping(params = "method=getOrgsBalance")
	public InstitutionAccount getOrgsBalance(HttpServletRequest request) {
		String orgCode = request.getParameter("orgCode");
		InstitutionAccount inforgsBalance = this.topUpsService
				.getOrgBalanceByOrgCode(orgCode);
		return inforgsBalance;
	}

	/**
	 * 充值准备
	 */
	@RequestMapping(params = "method=initTopUps")
	public String initTopUps(HttpServletRequest request, ModelMap model)
			throws Exception {
		TopUpsForm topUpsForm = new TopUpsForm();
		model.addAttribute("topUpsForm", topUpsForm);
		return LocaleUtil.getUserLocalePath("capital/topUps/topUps", request);
	}

	/**
	 * 进行充值
	 */
	@RequestMapping(params = "method=topUps")
	public String topUps(HttpServletRequest request,HttpSession session, ModelMap model,
			TopUpsForm topUpsForm) throws Exception {

		User currentUser = (User) session
				.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		topUpsForm.setOperAdmin(currentUser.getId());

		topUpsService.insititutionTopUps(topUpsForm);
		model.addAttribute("url", "topUps.do?method=certificate&fundNo="
				+ topUpsForm.getFundNo());
		if (topUpsForm.getC_errcode() != 0) {
			try {
				throw new Exception(topUpsForm.getC_errmsg());
			} catch (Exception e) {
				model.addAttribute("system_message", e.getMessage());
				logger.error("部门充值功能发生异常！" + e);
				e.printStackTrace();
				return "common/errorTip";
			}
		}
		return LocaleUtil.getUserLocalePath("capital/topUps/success", request);
	}

	// 打印凭证 获取信息
	@RequestMapping(params = "method=certificate")
	public String bankReceipt(HttpServletRequest request, ModelMap model,
			String fundNo) {
		TopUps topUpsInfo = topUpsService.getTopUpsByPk(fundNo);
		model.addAttribute("topUpsInfo", topUpsInfo);
		model.addAttribute("date", new Date());
		return LocaleUtil.getUserLocalePath("capital/topUps/certificate", request);
	}
}
