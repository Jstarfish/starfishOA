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
import cls.taishan.web.capital.form.CapitalForm;
import cls.taishan.web.capital.model.Capital;
import cls.taishan.web.capital.service.CapitalService;
import cls.taishan.web.dealer.model.Dealer;
import lombok.extern.log4j.Log4j;

/**
 * @Description:调账管理
 * @author:star
 * @time:2016年10月8日 下午5:29:44
 */
@Log4j
@Controller
@RequestMapping("/adjustment")
public class AdjustmentController {

	@Autowired
	private CapitalService capitalService;

	@RequestMapping(params = "method=initAdjustmentList")
	public String initAdjustmentList(HttpServletRequest request, ModelMap model) {
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
		return LocaleUtil.getUserLocalePath("capital/adjustmentList", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=adjustmentList")
	public Object AdjustmentList(HttpServletRequest request, ModelMap model, CapitalForm form) {
		List<Capital> adjustmentList = capitalService.getAdjuetmentList(form);
		return adjustmentList;
	}
	
	@RequestMapping(params="method=initAdjustment")
	public String initAdjustment(HttpServletRequest request, ModelMap model){
		List<Dealer> usableDealerList = capitalService.getUsableDealerList();
		model.addAttribute("usableDealerList", usableDealerList);
		return LocaleUtil.getUserLocalePath("capital/adjustment", request);
	}
	
	@RequestMapping(params="method=adjustment")
	public String adjustment(HttpServletRequest request, ModelMap model, CapitalForm form){
		try {
			form.setSecretKey(SysConstants.CAPITAL_SECURITY_KEY);
			HttpSession session = request.getSession();
			User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			String userId = String.valueOf(currentUser.getId());
			form.setOperAdmin(Integer.parseInt(userId));
			capitalService.adjustAccount(form);
			log.debug("调账存储过程执行结果，Error Code:"+form.getProcErrorCode()+" ,Error Message:"+form.getProcErrorMsg());
			model.addAttribute("fundNo", form.getFundNo());
			if(form.getProcErrorCode() != 0){
				model.addAttribute("systemErrorMsg", form.getProcErrorMsg());
				return LocaleUtil.getUserLocalePath("common/errorTip", request);
			}
		} catch (Exception e) {
			log.error("调账错误！",e);
			model.addAttribute("systemErrorMsg",e.getMessage());
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("capital/adjustmentSuccess", request);
	}
	
	/*@RequestMapping(params="method=adjustmentSuccess")
	public String adjustmentSuccess(HttpServletRequest request,ModelMap model){
		String fundNo = request.getParameter("fundNo");
		model.addAttribute("fundNo",fundNo);
		return "capital/adjustmentSuccess";
	}*/
	
	@RequestMapping(params="method=printCertificate")
	public String printCertificate(HttpServletRequest request,ModelMap model){
		String fundNo = request.getParameter("fundNo");
		Capital adjustmentInfo = capitalService.getAdjustmentInfo(fundNo);
		model.addAttribute("adjustmentInfo", adjustmentInfo);
		model.addAttribute("date", new Date());
		return LocaleUtil.getUserLocalePath("capital/adjustmentCertificate", request);
	}

}