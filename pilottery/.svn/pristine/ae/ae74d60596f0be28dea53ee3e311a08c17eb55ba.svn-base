package cls.taishan.web.dealer.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.taishan.common.constants.RedisConstants;
import cls.taishan.common.constants.SysConstants;
import cls.taishan.common.service.RedisService;
import cls.taishan.common.utils.LocaleUtil;
import cls.taishan.web.dealer.form.DealerForm;
import cls.taishan.web.dealer.model.Dealer;
import cls.taishan.web.dealer.model.DealerAccount;
import cls.taishan.web.dealer.model.GamePermission;
import cls.taishan.web.dealer.model.PermissionArray;
import cls.taishan.web.dealer.model.Security;
import cls.taishan.web.dealer.service.DealerService;
import lombok.extern.log4j.Log4j;

/**
 * 
 * @Description:渠道账户管理
 * @author:star
 * @time:2016年9月23日 下午4:09:26
 */
@Log4j
@Controller
@RequestMapping("/dealer")
public class DealerController {

	@Autowired
	private DealerService dealerService;
	@Autowired
	private RedisService redisService;

	@RequestMapping(params = "method=initDealerList")
	public String initDealerList(HttpServletRequest request) {
		return LocaleUtil.getUserLocalePath("dealer/dealerList", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=listDealers")
	public Object listDealers(HttpServletRequest request, ModelMap model, DealerForm form) {
		List<Dealer> dealer = dealerService.getDealerList(form);
		return dealer;
	}

	// 渠道商账户详情
	@RequestMapping(params = "method=detailDealer")
	public String detailDealer(HttpServletRequest request, ModelMap model, String dealerCode) {
		Dealer dealer = dealerService.getDealerDetail(dealerCode);
		model.addAttribute("dealerDetail", dealer);
		return LocaleUtil.getUserLocalePath("dealer/dealerDetail", request);
	}

	// 修改渠道商账户信息
	@RequestMapping(params = "method=initEditDealer")
	public String initEditDealer(HttpServletRequest request, ModelMap model, String dealerCode) {
		DealerForm form = new DealerForm();
		List<Dealer> dealerForm = dealerService.getDealerList(form);
		Dealer dealer = dealerService.getDealerDetail(dealerCode);
		model.addAttribute("dealer", dealer);
		model.addAttribute("editForm", dealerForm);
		return LocaleUtil.getUserLocalePath("dealer/editDealer", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=updateDealer")
	public String updateDealer(HttpServletRequest request, ModelMap model, Dealer dealer) {
		try {
			dealerService.updateDealer(dealer);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("修改渠道账户信息出错",e);
			return "error";
		}
		return "success";
	}
	
	//暂停和恢复渠道
	@ResponseBody
	@RequestMapping(params = "method=changeDealerStatus")
	public String changeDealerStatus(HttpServletRequest request,ModelMap model,String dealerCode){
		try {
			//String dealerCode = request.getParameter("dealerCode");
			String statusParam = request.getParameter("dealerStatus");
			int dealerStatus = Integer.valueOf(statusParam);
			Dealer dealer = dealerService.getDealerDetail(dealerCode);
			dealer.setDealerStatus(dealerStatus);
			dealerService.changeDealerStatus(dealer);
		} catch (Exception e) {
			log.error("修改渠道账户状态异常",e);
			return "error";
		}
		return "success";
	}
	
	//设置游戏权限
	@RequestMapping(params="method=initSetGamePermissions")
	public String initSetGamePermissions(HttpServletRequest request,ModelMap model,String dealerCode){
		try {
			List<GamePermission> gamePermisson = new ArrayList<GamePermission>();
			gamePermisson = dealerService.getGamePermissions(dealerCode);
			model.addAttribute("gamePermission", gamePermisson);
		} catch (Exception e) {
			log.error("初始化游戏授权出错",e);
		}
		return LocaleUtil.getUserLocalePath("dealer/dealerPermissions", request);
	}
	
	@ResponseBody
	@RequestMapping(params="method=updateGamePermissions")
	public String updateGamePermissions(HttpServletRequest request,ModelMap model,PermissionArray guth){
		try {
			dealerService.updateGamePermissions(guth);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("游戏授权出错",e);
			return "error";
		}
		return "success";
	}
	
	//开通渠道账户
	@RequestMapping(params="method=initAddDealer")
	public String initAddDealer(ModelMap model,HttpServletRequest request){
		return LocaleUtil.getUserLocalePath("dealer/addDealer", request);
	}
	
	@ResponseBody
	@RequestMapping(params="method=addDealer")
	public String addDealer(HttpServletRequest request,ModelMap model,Dealer dealer){
		try {
			int num = dealerService.getIfExistDealer(dealer.getDealerCode());
			if (num !=0){
				return "exist";
			}
			dealerService.addDealer(dealer);
		} catch (Exception e) {
			log.error("新增渠道账户出错",e);
			return "error";
		}
		return "success";
	}
	
	@RequestMapping(params="method=initUpdateMsg")
	public String initUpdateMsg(HttpServletRequest request,ModelMap model,String dealerCode){
		Security security = dealerService.getSecurity(dealerCode);
		model.addAttribute("security", security);
		return LocaleUtil.getUserLocalePath("dealer/editMsg", request);
	}
	
	@ResponseBody
	@RequestMapping(params="method=updateMsg")
	public String updateMsg(HttpServletRequest request,ModelMap model,Security security){
		try {
			dealerService.updateMsg(security);
			redisService.set(RedisConstants.AGENCY_PUBLIC_KEY+security.getDealerCode(), security.getPublicKey());
			log.debug("缓存渠道商公钥到REDIS,渠道商编码："+security.getDealerCode());
		} catch (Exception e) {
			log.error("更新公钥出错",e);
			return "error";
		}
		return "success";
	}
	
	@RequestMapping(params="method=initCreditSetting")
	public String initCreditSetting(HttpServletRequest request,ModelMap model,String dealerCode){
		DealerAccount account = dealerService.getDealerCredit(dealerCode);
		model.addAttribute("account", account);
		return LocaleUtil.getUserLocalePath("dealer/creditSetting", request);
	}
	
	@ResponseBody
	@RequestMapping(params="method=updateDealerCredit")
	public String updateDealerCredit(HttpServletRequest request,ModelMap model,DealerAccount account){
		try {
			dealerService.updateDealerCredit(account);
		} catch (Exception e) {
			log.error("修改渠道商信用额度出错",e);
			return "error";
		}
		return "success";
	}
	
}
