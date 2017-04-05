package cls.pilottery.web.capital.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.web.capital.model.balancemodel.Balance;
import cls.pilottery.web.capital.service.BalanceService;
import cls.pilottery.web.system.model.User;

/**
 * 部门的账户余额查询
 * @author jhx
 *
 */
@Controller
@RequestMapping("/accountBalance")
public class BalanceAccount {
	
	static Logger logger = Logger.getLogger(BalanceAccount.class);
	
	@Autowired
	private  BalanceService balanceService;
	
	/**
	 * 部门资金余额查询
	 */
	@RequestMapping(params = "method=listAccountBalance")
	public String listManagerAccounts(HttpServletRequest request,
			ModelMap model, Balance balanceModel) {
		String orgCode ="";
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		if(currentUser.getInstitutionCode()!=null){
			orgCode=currentUser.getInstitutionCode();
		}
		Balance balance = balanceService.getAccountBalanceInfo(orgCode); 
		model.addAttribute("balance", balance);
		return LocaleUtil.getUserLocalePath("capital/accountBalance/listAccountBalance", request);
	}

}
