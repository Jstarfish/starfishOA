package cls.pilottery.web.marketManager.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.marketManager.form.RepaymentRecordForm;
import cls.pilottery.web.marketManager.model.InventoryModel;
import cls.pilottery.web.marketManager.model.RepaymentRecordModel;
import cls.pilottery.web.marketManager.service.RepaymentRecordService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("repaymentRecord")
public class RepaymentRecordController {
	Logger log = Logger.getLogger(RepaymentRecordController.class);
	
	@Autowired
	private RepaymentRecordService repaymentRecordService;
	
	@RequestMapping(params = "method=listRepaymentRecords")
	public String listRepaymentRecords(HttpServletRequest request, ModelMap model,RepaymentRecordForm form) {
		List<RepaymentRecordModel> list = null;
		int count = 0 ;
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			int pageIndex = PageUtil.getPageIndex(request);
			count = repaymentRecordService.getRepaymentRecordCount(form);
			if (count > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = repaymentRecordService.getRepaymentRecordList(form);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("查询还款记录发生异常！", e);
			return "_common/errorTip";
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("form",form);
		return LocaleUtil.getUserLocalePath("marketManager/repayments/listRepaymentRecords", request);
	}
	
	/*
	 * 市场管理员在手库存查询
	 */
	@RequestMapping(params = "method=listInventory")
	public String listInventory(HttpServletRequest request, ModelMap model) {
		List<InventoryModel> list = null;
		InventoryModel total = null;
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			list = repaymentRecordService.getInventoryList(currentUser.getId().intValue());
			total = repaymentRecordService.getInventorySum(currentUser.getId().intValue());
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("市场管理员在手库存查询发生异常！", e);
			return "_common/errorTip";
		}
		model.addAttribute("pageDataList", list);
		model.addAttribute("total", total);
		return LocaleUtil.getUserLocalePath("marketManager/Inventory/InventoryList", request);
	}

}
