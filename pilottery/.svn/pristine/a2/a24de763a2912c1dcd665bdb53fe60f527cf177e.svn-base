package cls.pilottery.oms.monitor.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.monitor.form.EventsForm;
import cls.pilottery.oms.monitor.model.Events;
import cls.pilottery.oms.monitor.service.EventsService;

/**
 * 事件控制台监控
 */
@Controller
@RequestMapping("event")
public class SystemEventController {
	static Logger log = Logger.getLogger(SystemEventController.class);

	@Autowired
	private EventsService eventsService;

	long latestId = 0;

	@RequestMapping(params = "method=listEvents")
	public String listEvents(HttpServletRequest request, ModelMap model, EventsForm form) {

		try {
			if(form==null || StringUtils.isEmpty(form.getBeginDate())){
				Calendar cld = Calendar.getInstance(); 
				String defaultDate = (new SimpleDateFormat("yyyy-MM-dd")).format(cld.getTime());
				form.setBeginDate(defaultDate);
				form.setEndDate(defaultDate);
			}
			
			List<Events> list = null;
			Integer count = eventsService.getEventsCount(form);
			int pageIndex = PageUtil.getPageIndex(request);
			if (count != null && count.intValue() > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = eventsService.getEventsList(form);
			}
			model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
			model.addAttribute("pageDataList", list);
			model.addAttribute("form", form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("事件监控页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		
		return LocaleUtil.getUserLocalePath("oms/monitor/eventsList", request);
	}
}
