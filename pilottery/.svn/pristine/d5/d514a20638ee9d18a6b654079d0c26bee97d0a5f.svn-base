package cls.pilottery.demo.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.demo.form.DemoForm;
import cls.pilottery.demo.model.User;
import cls.pilottery.demo.service.DemoService;

@Controller
@RequestMapping("demo")
public class DemoController {
	Logger log = Logger.getLogger(DemoController.class);
	
	@Autowired
	private DemoService demoService;
	
	@RequestMapping(params="method=demoList")
	public String getDemoList(HttpServletRequest request, ModelMap model,DemoForm demoForm) {
		
		try {
			List<User> list = new ArrayList<User>();
			int pageIndex = PageUtil.getPageIndex(request);
			Integer count = demoService.getUserCount(demoForm) ;
			if (count != null && count.intValue() != 0) {
				demoForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				demoForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);

				list = demoService.getUserList(demoForm);
			}
			 model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
			 model.addAttribute("pageDataList", list);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message",e.getMessage());
			log.error("查询demo列表功能发生异常！", e);
			return "_common/errorTip";
		}
		return "demo/demoList";
	}
	
	@RequestMapping(params="method=editDemo")
	public String editDemo(HttpServletRequest request, ModelMap model,DemoForm demoForm) {
		User user = demoService.getUserById(demoForm.getUserId());
		model.addAttribute("user",user);
		return "demo/editDemo";
	}
	
	@RequestMapping(params="method=newDemo")
	public String newDemo(HttpServletRequest request, ModelMap model,DemoForm demoForm) {
		return "demo/editDemo";
	}
	
	@RequestMapping(params="method=deleteDemo")
	@ResponseBody
	public String deleteUser(HttpServletRequest request, ModelMap model) {
		return "success";
	}
	
	@RequestMapping(params="method=saveDemo")
	public String saveDemo(HttpServletRequest request, ModelMap model) {
		try{
		
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message",e.getMessage());
			log.error("查询demo列表功能发生异常！", e);
			return "_common/errorTip";
		}
		//model.addAttribute("reservedHrefURL","demo.do?method=demoList");
		return "_common/successTip";
	}
	
}
