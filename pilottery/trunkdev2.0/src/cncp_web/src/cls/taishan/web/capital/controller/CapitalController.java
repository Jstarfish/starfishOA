package cls.taishan.web.capital.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.taishan.common.constants.SysConstants;
import cls.taishan.common.entity.BasePageResult;
import cls.taishan.common.utils.LocaleUtil;
import cls.taishan.system.model.User;
import cls.taishan.web.capital.form.CapitalForm;
import cls.taishan.web.capital.form.TransactionForm;
import cls.taishan.web.capital.model.Capital;
import cls.taishan.web.capital.model.Transactions;
import cls.taishan.web.capital.service.CapitalService;
import cls.taishan.web.dealer.model.Dealer;
import lombok.extern.log4j.Log4j;

/**
 * @Description:渠道资金管理 (只包含交易查询和充值)
 * @author:star
 * @time:2016年9月23日 下午4:09:26
 */
@Log4j
@Controller
@RequestMapping("/capital")
public class CapitalController {

	@Autowired
	private CapitalService capitalService;

	// 资金交易查询
	@RequestMapping(params = "method=initQueryFundTransaction")
	public String initQueryFundTransaction(HttpServletRequest request, ModelMap model) {
		List<Dealer> dealerList = capitalService.getDealerList();
		//获取当前时间和前一个月时间
		Date date = new Date();
		Calendar cld = Calendar.getInstance();
		String endDate = (new SimpleDateFormat("yyyy-MM-dd")).format(date);
		cld.add(Calendar.MONTH, -1);
		String startDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
		model.addAttribute("dealerList", dealerList);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		return LocaleUtil.getUserLocalePath("capital/fundTransaction", request);
		
	}

	@ResponseBody
	@RequestMapping(params = "method=queryFundTransaction")
	public Object queryFundTransaction(HttpServletRequest request, ModelMap model, TransactionForm form) {
		int totalCount = capitalService.getTransactionsCount(form);
		BasePageResult<Transactions> result = new BasePageResult<Transactions>();
		if (totalCount > 0) {
			form.setBeginNum(((form.getPageindex() - 1) * form.getPageSize()));
			form.setEndNum((form.getPageindex() * form.getPageSize()));
		} else {
			form.setBeginNum(0);
			form.setEndNum(0);
		}
		List<Transactions> transaction = capitalService.getFundTransaction(form);
		result.setResult(transaction);
		result.setTotalCount(totalCount);
		
		return result;
	}

	// 充值记录
	@RequestMapping(params = "method=initTopUpList")
	public String initTopUpList(HttpServletRequest request, ModelMap model) {
		List<Dealer> dealerList = capitalService.getDealerList();
		//获取当前时间和前一个月时间
		Date date = new Date();
		Calendar cld = Calendar.getInstance();
		String endDate = (new SimpleDateFormat("yyyy-MM-dd")).format(date);
		cld.add(Calendar.MONTH, -1);
		String startDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
		model.addAttribute("dealerList", dealerList);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		return LocaleUtil.getUserLocalePath("capital/topUpList", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=queryTopUpRecords")
	public Object topUpList(HttpServletRequest request, ModelMap model, CapitalForm form) {
		List<Capital> topUpList = capitalService.getTopUpList(form);
		return topUpList;
	}

	// 进行充值
	@RequestMapping(params = "method=initTopUp")
	public String initTopUp(HttpServletRequest request, ModelMap model) {
		List<Dealer> usableDealerList = capitalService.getUsableDealerList();
		model.addAttribute("usableDealerList", usableDealerList);
		return LocaleUtil.getUserLocalePath("capital/topUp", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=getDealerNameByCode")
	public String getDealerNameByCode(HttpServletRequest request) {
		String dealerCode = request.getParameter("dealerCode");
		String dealerName = this.capitalService.getDealerNameByCode(dealerCode);
		return dealerName;
	}

	@ResponseBody
	@RequestMapping(params = "method=getDealerInfoByCode")
	public Object getDealerInfoByCode(HttpServletRequest request) {
		String dealerCode = request.getParameter("dealerCode");
		Capital dealerInfo = this.capitalService.getDealerInfoByCode(dealerCode);
		return dealerInfo;
	}

	// @ResponseBody
	@RequestMapping(params = "method=topup")
	public String topup(HttpServletRequest request, ModelMap model, CapitalForm form) {
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String userId = String.valueOf(currentUser.getId());
		form.setOperAdmin(Integer.parseInt(userId));
		form.setSecretKey(SysConstants.CAPITAL_SECURITY_KEY);
		capitalService.topUp(form);
		log.debug("充值存储过程执行结果，Error Code:"+form.getProcErrorCode()+" ,Error Message:"+form.getProcErrorMsg());
		model.addAttribute("fundNo", form.getFundNo());
		if (form.getProcErrorCode() != 0) {
			try {
				throw new Exception(form.getProcErrorMsg());
			} catch (Exception e) {
				log.error("充值错误！",e);
				model.addAttribute("systemErrorMsg",e.getMessage());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		}
		return LocaleUtil.getUserLocalePath("capital/topupSuccess", request);
	}

	@RequestMapping(params = "method=printCertificate")
	public String printCertificate(HttpServletRequest request, ModelMap model) {
		String fundNo = request.getParameter("fundNo");
		Capital topUpInfo = capitalService.getTopUpInfo(fundNo);
		model.addAttribute("topUpInfo", topUpInfo);
		model.addAttribute("date", new Date());
		return LocaleUtil.getUserLocalePath("capital/topupCertificate", request);
	}
	
}