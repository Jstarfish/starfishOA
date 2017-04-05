package cls.pilottery.web.outlet.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.outlet.form.OutletCashWithdrawnForm;
import cls.pilottery.web.outlet.service.OutletCashWithdrawnService;
import cls.pilottery.web.system.model.User;

@Controller
@RequestMapping("/withdrawnRecords")
public class WithdrawnRecordsController {
	static Logger logger = Logger.getLogger(WithdrawnRecordsController.class);
	@Autowired
	private OutletCashWithdrawnService outletCashWithdrawnService;
	
	private Map<Integer,String> applyStatus = EnumConfigEN.cashWithdrawnStatus;
	/*
	 * 准备数据-枚举定义
	 */
	@ModelAttribute("applyStatus")
	public Map<Integer,String> getmaporgType(HttpServletRequest request)
	{
		if(request != null)
			this.applyStatus =LocaleUtil.getUserLocaleEnum("cashWithdrawnStatus", request);
		
		return applyStatus;
	}
	/**
	 * 站点提现记录列表
	 */
	@RequestMapping(params = "method=listWithdrawnRecords")
	public String listWithdrawnRecords(HttpServletRequest request,
			ModelMap model, OutletCashWithdrawnForm outletCashWithdrawnForm) {
		List<OutletCashWithdrawnForm> list = null;
		int count = 0;
		try {
			User currentUser = (User) request.getSession().getAttribute(
					SysConstants.CURR_LOGIN_USER_SESSION);
			outletCashWithdrawnForm.setCurrentUserId(currentUser.getId()
					.intValue());
			int pageIndex = PageUtil.getPageIndex(request);
			count = outletCashWithdrawnService
					.getCashWithdrawnCount(outletCashWithdrawnForm);
			if (count > 0) {
				outletCashWithdrawnForm.setBeginNum((pageIndex - 1)
						* PageUtil.pageSize);
				outletCashWithdrawnForm.setEndNum((pageIndex - 1)
						* PageUtil.pageSize + PageUtil.pageSize);
				list = outletCashWithdrawnService.getCashWithdrawnList(outletCashWithdrawnForm);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			logger.error("站点提现记录功能发生异常！", e);
			return "common/errorTip";
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("cashWithdrawnForm", outletCashWithdrawnForm);
		return LocaleUtil.getUserLocalePath("outletService/listCashWithdrawn", request);
	}
}
