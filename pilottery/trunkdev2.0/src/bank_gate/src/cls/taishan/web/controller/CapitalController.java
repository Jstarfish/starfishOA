package cls.taishan.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.taishan.common.utils.LocaleUtil;
import cls.taishan.web.model.Account;
import cls.taishan.web.model.TradeRecord;
import cls.taishan.web.service.CapitalService;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/capital")
public class CapitalController {

	@Autowired
	private CapitalService capitalService;

	@RequestMapping(params = "method=initAccountList")
	private String initAccountList(HttpServletRequest request, ModelMap model) {
		return LocaleUtil.getUserLocalePath("capital/accountList", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=listAccount")
	public Object listAccount(HttpServletRequest request, ModelMap model, Account form) {
		List<Account> account = capitalService.getAccountList(form);
		return account;
	}

	@RequestMapping(params = "method=initTopupList")
	private String initTopupList(HttpServletRequest request, ModelMap model) {
		return LocaleUtil.getUserLocalePath("capital/topUpList", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=topupList")
	public Object topupList(HttpServletRequest request, ModelMap model, TradeRecord form) {
		form.setTradeType(1);
		List<TradeRecord> account = capitalService.getTradeRecordList(form);
		return account;
	}

	@RequestMapping(params = "method=topUpDetail")
	public String topUpDetail(HttpServletRequest request, ModelMap model, String tradeFlow) {
		TradeRecord form = new TradeRecord();
		try {
			if (tradeFlow != null) {
				form.setTradeFlow(tradeFlow);
				List<TradeRecord> topUpDetail = capitalService.getTradeRecordList(form);
				model.addAttribute("topUpDetail", topUpDetail);
			}
		} catch (Exception e) {
			log.error("充值列表详情出错");
		}
		return LocaleUtil.getUserLocalePath("capital/topUpDetail", request);
	}

	@RequestMapping(params = "method=initWithdrawList")
	private String initWithdrawList(HttpServletRequest request, ModelMap model) {
		return LocaleUtil.getUserLocalePath("capital/withdrawList", request);
	}

	@ResponseBody
	@RequestMapping(params = "method=WithdrawList")
	public Object withdrawList(HttpServletRequest request, ModelMap model, TradeRecord form) {
		form.setTradeType(2);
		List<TradeRecord> account = capitalService.getTradeRecordList(form);
		return account;
	}

	@RequestMapping(params = "method=withdrawDetail")
	public String withdrawDetail(HttpServletRequest request, ModelMap model, String tradeFlow) {
		TradeRecord form = new TradeRecord();
		try {
			if (tradeFlow != null) {
				form.setTradeFlow(tradeFlow);
				List<TradeRecord> topUpDetail = capitalService.getTradeRecordList(form);
				model.addAttribute("topUpDetail", topUpDetail);
			}
		} catch (Exception e) {
			log.error("提现列表详情出错");
		}
		return LocaleUtil.getUserLocalePath("capital/withdrawDetail", request);
	}

}
