package cls.pilottery.oms.lottery.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.lottery.form.ReconciliationForm;
import cls.pilottery.oms.lottery.form.SaleGamepayinfoForm;
import cls.pilottery.oms.lottery.model.ReconciliationVo;
import cls.pilottery.oms.lottery.service.ExpirydateService;
import cls.pilottery.oms.lottery.vo.SaleGamepayinfoVo;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("expirydate")
public class ExpirydateController {
	@Autowired
	private ExpirydateService expirydateService;

	/**
	 * 列表查询 数据分页处理
	 */
	@RequestMapping(params = "method=list")
	public String expirydateQurylist(HttpServletRequest request, ModelMap model, SaleGamepayinfoForm salegamepayinfoForm) {
		// User user = UserSession.getUser(request);
		User user = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		// salegamepayinfoForm.setAreaCode(new Long(user.getAreaCode()));
		salegamepayinfoForm.setAreaCode(user.getInstitutionCode());

		Integer count = this.expirydateService.getSaleGamepaycount(salegamepayinfoForm);
		List<SaleGamepayinfoVo> salegamepayinfolist = new ArrayList<SaleGamepayinfoVo>();
		int pageIndex = PageUtil.getPageIndex(request);
		// int pageSize = DisplayTagParams.DEFAULT_PAGE_SIZE_MAX;
		if (count != null && count.intValue() != 0) {
			salegamepayinfoForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			salegamepayinfoForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			salegamepayinfolist = this.expirydateService.getSaleGameList(salegamepayinfoForm);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", salegamepayinfolist);
		model.addAttribute("salegamepayinfoForm", salegamepayinfoForm);
		if (salegamepayinfoForm.getStartpayTime() != null) {
			model.addAttribute("startpayTime", salegamepayinfoForm.getStartpayTime().substring(0, 10));
		}
		if (salegamepayinfoForm.getEndpayTime() != null) {
			model.addAttribute("endpayTime", salegamepayinfoForm.getEndpayTime().substring(0, 10));
		}
		return LocaleUtil.getUserLocalePath("oms/expirydate/expirydatelist", request);
	}

	/**
	 *用户对账查询
	 * 
	 * @param request
	 * @param model
	 * @param reconciliationForm
	 * @return
	 */
	@RequestMapping(params = "method=reconciliationQuery")
	public String reconciliationQuery(HttpServletRequest request, ModelMap model, ReconciliationForm reconciliationForm) {
		Integer count = this.expirydateService.getReconciliationCount(reconciliationForm);
		List<ReconciliationVo> reconList = new ArrayList<ReconciliationVo>();
		int pageIndex = PageUtil.getPageIndex(request);
		if (count != null && count.intValue() != 0) {
			reconciliationForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
			reconciliationForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
			reconList = this.expirydateService.getReconciliationList(reconciliationForm);
		}
		model.addAttribute("pageDataList", reconList);
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("reconciliationForm", reconciliationForm);

		return LocaleUtil.getUserLocalePath("oms/expirydate/reconciliationlist", request);
	}
}
