package cls.pilottery.web.marketManager.controller;

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
import cls.pilottery.web.marketManager.entity.AccountBalance;
import cls.pilottery.web.marketManager.service.AccountBalanceService;
import cls.pilottery.web.system.model.User;

/**
 * 部门的账户余额查询
 * @author jhx
 *
 */
@Controller
@RequestMapping("/marketManagerBalance")
public class AccountBalanceController {
	
	static Logger logger = Logger.getLogger(AccountBalanceController.class);
	
	@Autowired
	private  AccountBalanceService balanceService;
	
	/**
	 * 部门资金余额查询
	 */
	@RequestMapping(params = "method=queryAccountBalance")
	public String listManagerAccounts(HttpServletRequest request,
			ModelMap model, AccountBalance accountBalanceModel) {
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		/*if(currentUser.getId()!=null){
		}*/
		Long maketAdmin=currentUser.getId();
		AccountBalance balance = balanceService.getMarketAccountInfo(maketAdmin);
		model.addAttribute("balance", balance);
		return LocaleUtil.getUserLocalePath("marketManager/accountBalance/listAccountBalance", request);
	}

}
