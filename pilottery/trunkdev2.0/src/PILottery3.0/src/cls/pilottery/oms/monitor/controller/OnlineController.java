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
import cls.pilottery.oms.monitor.form.TerminalOnlineForm;
import cls.pilottery.oms.monitor.model.TerminalOnline;
import cls.pilottery.oms.monitor.service.OnlineService;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.institutions.service.InstitutionsService;
import cls.pilottery.web.system.model.User;
import jxl.common.Logger;
/**
 * @Description:终端机在线时长监控
 * @author:star
 * @time:2016年7月29日 下午1:57:45
 */
@Controller
@RequestMapping("/onlineStatistics")
public class OnlineController {
	
	static Logger log = Logger.getLogger(OnlineController.class);
	@Autowired
	private OnlineService onlineService; 
	
	@Autowired
	private InstitutionsService institutionsService;
	
	@RequestMapping(params="method=listOnlineRecords")
	public String listOnlineRecord(HttpServletRequest request,ModelMap model,TerminalOnlineForm form){
		try {
			User currentUser = (User) request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCuserOrg(currentUser.getInstitutionCode());
			if (form == null || StringUtils.isEmpty(form.getBeginDate())) {
				Calendar cld = Calendar.getInstance();
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
			}
			/*if(form == null || StringUtils.isEmpty(form.getOnlineTime())){
				form.setOnlineTime("4");
			}*/
			
			List<TerminalOnline> list = null;
			Integer count = onlineService.getOnlineCount(form);
			int pageIndex = PageUtil.getPageIndex(request);
			if(count != null && count.intValue() > 0){
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = onlineService.getOnlineList(form);
			}
			
			List<InfOrgs> orgList = institutionsService.getAllInstitutionsInfo();
			model.addAttribute("orgList", orgList);
			model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
			model.addAttribute("pageDateList", list);
			model.addAttribute("form", form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("终端机在线监  控页面发生异常",e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("oms/monitor/onlineMonitor", request);
	}

}
