package cls.pilottery.oms.monitor.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.monitor.form.TerminalCheckForm;
import cls.pilottery.oms.monitor.model.TerminalCheck;
import cls.pilottery.oms.monitor.service.CheckService;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.institutions.service.InstitutionsService;
import cls.pilottery.web.outlet.service.OutletService;
import cls.pilottery.web.system.model.User;
import jxl.common.Logger;

@Controller
@RequestMapping("/terminalCheck")
public class TerminalCheckController {

	static Logger log = Logger.getLogger(TerminalCheckController.class);
	
	@Autowired
	private CheckService checkService;

	@Autowired
	private InstitutionsService institutionsService;
	
	@RequestMapping(params = "method=listCheckRecords")
	public String listCheckRecords(HttpServletRequest request, ModelMap model, TerminalCheckForm form) {
		try {
			User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCuserOrg(currentUser.getInstitutionCode());
			if (form == null || StringUtils.isEmpty(form.getBeginDate())) {
				Calendar cld = Calendar.getInstance();
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
			}
			List<TerminalCheck> list = null;
			Integer count = checkService.getCheckCount(form);
			int pageIndex = PageUtil.getPageIndex(request);
			if (count != null && count.intValue() > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = checkService.getCheckList(form);
			}
			List<InfOrgs> orgList = institutionsService.getAllInstitutionsInfo();
			model.addAttribute("orgList", orgList);
			model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
			model.addAttribute("pageDataList", list);
			model.addAttribute("form", form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("巡检页面发生异常", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("oms/monitor/terminalCheck", request);
	}
}
