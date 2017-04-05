package cls.pilottery.web.system.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.system.form.SysParameterForm;
import cls.pilottery.web.system.model.SysParameter;
import cls.pilottery.web.system.service.SysParameterService;

@Controller
@RequestMapping("/sysParameter")
public class sysParameterController {
	
	Logger logger = Logger.getLogger(sysParameterController.class);
	
	@Autowired
	private SysParameterService sysParameterService;
	
	@RequestMapping(params = "method=sysParameterList")
	public String sysParameterList(HttpServletRequest request , ModelMap model,SysParameterForm form) {
		List<SysParameter> list = null;
		int count = 0;
		try {
			int pageIndex = PageUtil.getPageIndex(request);
			count = sysParameterService.getSysParameterCount(form);
			if (count > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = sysParameterService.getParameterList(form);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			logger.error("查询系统参数列表功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("form", form);
		return LocaleUtil.getUserLocalePath("system/sysParameterList", request);
	}
	
	@RequestMapping(params="method=editSysParameter")
	public String editSysParameter(HttpServletRequest request,ModelMap model){
		SysParameter sysParameter = null;
		try {
			String id = request.getParameter("id");
			sysParameter = sysParameterService.getParameterDetail(id);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			logger.error("初始化系统参数修改页面发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		model.addAttribute("sysParameter", sysParameter);
	
		return LocaleUtil.getUserLocalePath("system/editSysParameter", request);
	}

	@RequestMapping(params="method=updateSysParameter")
	public String updateSysParameter(HttpServletRequest request,ModelMap model,SysParameter sysParameter){
		try {
			sysParameterService.updateSysParameter(sysParameter);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			logger.error("更新系统参数功能发生异常！", e);
			return LocaleUtil.getUserLocalePath("common/errorTip", request);
		}
		return LocaleUtil.getUserLocalePath("common/successTip", request);
	}
	
	

}
