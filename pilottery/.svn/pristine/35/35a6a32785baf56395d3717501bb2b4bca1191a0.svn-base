package cls.pilottery.oms.monitor.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.monitor.form.LogForm;
import cls.pilottery.oms.monitor.model.TaishanLog;
import cls.pilottery.oms.monitor.service.MLogService;

@Controller
@RequestMapping("taishanLog")
public class LogController {

	static Logger log = Logger.getLogger(LogController.class);
	@Autowired
	private MLogService logService;

	@RequestMapping(params = "method=listLog")
	public String listLog(HttpServletRequest request, ModelMap model, LogForm logForm) {
		try {

			List<TaishanLog> list = null;
			Integer count = logService.getLogCount(logForm);
			int pageIndex = PageUtil.getPageIndex(request);
			if (count != null && count.intValue() > 0) {
				logForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				logForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = logService.getLogList(logForm);
			}
			model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
			model.addAttribute("pageDataList", list);
			model.addAttribute("form", logForm);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("结算日志发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("oms/monitor/taishanLogList", request);
	}
}
