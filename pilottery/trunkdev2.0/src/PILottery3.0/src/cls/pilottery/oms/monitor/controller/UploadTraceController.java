package cls.pilottery.oms.monitor.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.oms.monitor.form.UploadTraceForm;
import cls.pilottery.oms.monitor.model.UploadTrace;
import cls.pilottery.oms.monitor.service.UploadTraceService;

@Controller
@RequestMapping("/trace")
public class UploadTraceController {

	static Logger log = Logger.getLogger(UploadTraceController.class);

	private Map<Integer, String> reqestTypes = EnumConfigEN.reqestTypes;

	@ModelAttribute("reqestTypes")
	public Map<Integer, String> getmaporgType(HttpServletRequest request) {
		if (request != null)
			this.reqestTypes = LocaleUtil.getUserLocaleEnum("reqestTypes", request);

		return reqestTypes;
	}

	@Autowired
	private UploadTraceService uploadTraceService;

	@RequestMapping(params = "method=listTrace")
	public String getTraceList(HttpServletRequest request, Model model, UploadTraceForm form) {
		try {
			List<UploadTrace> list = null;
			Integer count = uploadTraceService.getTraceCount(form);
			int pageIndex = PageUtil.getPageIndex(request);
			if (count != null && count.intValue() > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = uploadTraceService.getTraceList(form);
			}
			model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
			model.addAttribute("pageDataList", list);
			model.addAttribute("form", form);

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("上传日志列表发生异常了！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("oms/monitor/uploadTraceList", request);
	}

	@RequestMapping(params = "method=toAddPage")
	public String toAddPage(HttpServletRequest request, ModelMap model) {

		try {
			UploadTraceForm addForm = new UploadTraceForm();
			model.addAttribute("addForm", addForm);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return LocaleUtil.getUserLocalePath("oms/monitor/addTrace", request);
	}

	@RequestMapping(params = "method=addTrace")
	public String addTrace(HttpServletRequest request, ModelMap model, UploadTraceForm uploadTraceForm) {

		try {
			uploadTraceService.saveTrace(uploadTraceForm);

		} catch (Exception e) {
			log.error("上传日志功能发生异常！" + e);
			e.printStackTrace();
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}
}
