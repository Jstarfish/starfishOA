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
import cls.taishan.common.utils.LocaleUtil;
import cls.taishan.system.model.User;
import cls.taishan.system.model.UserLanguage;
import cls.taishan.web.capital.form.CapitalForm;
import cls.taishan.web.capital.model.Capital;
import cls.taishan.web.capital.service.CapitalService;
import cls.taishan.web.dealer.model.Dealer;
import lombok.extern.log4j.Log4j;

/**
 * @Description:提现管理
 * @author:star
 * @time:2016年10月8日 下午4:43:03
 */
@Log4j
@Controller
@RequestMapping("/withdraw")
public class WithdrawController {

	@Autowired
	private CapitalService capitalService;

	@RequestMapping(params = "method=initWithdrawList")
	public String initWithdrawList(HttpServletRequest request, ModelMap model) {
		List<Dealer> dealerList = capitalService.getDealerList();
		model.addAttribute("dealerList", dealerList);
		//获取当前时间和前一个月时间
		Date date = new Date();
		Calendar cld = Calendar.getInstance();
		String endDate = (new SimpleDateFormat("yyyy-MM-dd")).format(date);
		cld.add(Calendar.MONTH, -1);
		String startDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
		model.addAttribute("dealerList", dealerList);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		return LocaleUtil.getUserLocalePath("capital/withdrawList", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=withdrawList")
	public Object withdrawList(HttpServletRequest request, ModelMap model, CapitalForm form) {
		List<Capital> withdrawList = capitalService.getWithdrawList(form);
		return withdrawList;
	}

	@RequestMapping(params = "method=initWithdraw")
	public String initWithdraw(HttpServletRequest request, ModelMap model) {
		List<Dealer> usableDealerList = capitalService.getUsableDealerList();
		model.addAttribute("usableDealerList", usableDealerList);
		return LocaleUtil.getUserLocalePath("capital/withdraw", request);
	}
	
	//@ResponseBody
	@RequestMapping(params="method=withdraw")
	public String withdraw(HttpServletRequest request,ModelMap model,CapitalForm form){
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		String userId = String.valueOf(currentUser.getId());
		form.setOperAdmin(Integer.parseInt(userId));
		String operaAmount = request.getParameter("operAmount");
		String beforeAccountBalance = request.getParameter("beforeAccountBalance");
		if(Long.valueOf(beforeAccountBalance)<Long.valueOf(operaAmount)){
			//return "-1";
			UserLanguage lg = currentUser.getUserLang();
			if(lg == UserLanguage.ZH){
				model.addAttribute("systemErrorMsg","提现金额不能大于账户余额");
			}else if(lg == UserLanguage.EN){
				model.addAttribute("systemErrorMsg","The cash withdrawn cannot be larger than the current account balance");
			}
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		form.setSecretKey(SysConstants.CAPITAL_SECURITY_KEY);
		capitalService.withdraw(form);
		model.addAttribute("fundNo", form.getFundNo());
		log.debug("充值存储过程执行结果，Error Code:"+form.getProcErrorCode()+" ,Error Message:"+form.getProcErrorMsg());
		if (form.getProcErrorCode() != 0) {
			try {
				throw new Exception(form.getProcErrorMsg());
			} catch (Exception e) {
				log.error("提现错误！",e);
				model.addAttribute("systemErrorMsg",e.getMessage());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		}
		//return "success"+form.getFundNo();
		return LocaleUtil.getUserLocalePath("capital/withdrawSuccess", request);
	}
	
	@RequestMapping(params="method=withdrawSuccess")
	public String withdrawSuccess(HttpServletRequest request,ModelMap model){
		String fundNo = request.getParameter("fundNo");
		model.addAttribute("fundNo",fundNo);
		return LocaleUtil.getUserLocalePath("capital/withdrawSuccess", request);
	}
	
	@RequestMapping(params="method=printCertificate")
	public String printCertificate(HttpServletRequest request,ModelMap model){
		String fundNo = request.getParameter("fundNo");
		Capital withdrawInfo = capitalService.getWithdrawInfo(fundNo);
		model.addAttribute("withdrawInfo", withdrawInfo);
		model.addAttribute("date", new Date());
		return LocaleUtil.getUserLocalePath("capital/withdrawCertificate", request);
	}

}