package cls.taishan.demo.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.taishan.common.entity.BasePageResult;
import cls.taishan.demo.form.DemoForm;
import cls.taishan.demo.model.DemoOrgInfo;
import cls.taishan.demo.model.DemoUser;
import cls.taishan.demo.service.DemoService;

@Controller
@RequestMapping("/demo")
public class DemoController {
	@Autowired
	private DemoService userService;
	
	@RequestMapping(params = "method=initUserList")
	public String initUserList(HttpServletRequest request , ModelMap model , DemoForm userForm) {
		List<DemoOrgInfo> orgList = userService.getOrgList();
		model.addAttribute("orgList",orgList);
		return "demo/userList";
	}
	
	@ResponseBody
	@RequestMapping(params = "method=listUsers")
	public Object listUsers(DemoForm form) {
		List<DemoUser> user = userService.getUserList(form);
		return user;
	}
	
	@RequestMapping(params = "method=editUser")
	public String editUser(HttpServletRequest request, ModelMap model, int userId) {
		DemoUser user = userService.getUserById(userId);
		
		List<DemoOrgInfo> orgList = userService.getOrgList();
		model.addAttribute("orgList",orgList);
		model.addAttribute("user",user);
		return "demo/editUser";
	}
	
	@ResponseBody
	@RequestMapping(params = "method=updateUser")
	public String updateUser(HttpServletRequest request, ModelMap model, DemoUser user) {
		userService.updateUser(user);
		
		return "success";
	}
	
	@RequestMapping(params = "method=addUser")
	public String addUser(HttpServletRequest request, ModelMap model) {
		List<DemoOrgInfo> orgList = userService.getOrgList();
		model.addAttribute("orgList",orgList);
		return "demo/addUser";
	}
	
	@ResponseBody
	@RequestMapping(params = "method=saveUser")
	public String saveUser(HttpServletRequest request, ModelMap model, DemoUser user) {
		//userService.saveUser(user); 实现省略……
		
		return "error";
	}
	
	@ResponseBody
	@RequestMapping(params = "method=deleteUser")
	public String deleteUser(HttpServletRequest request, ModelMap model, int userId) {
		try {
			//userService.deleteUser(userId);
			System.out.println(userId);
		} catch (Exception e) {
			e.printStackTrace();
			return e.getMessage();
		}
		return "success";
	}
	
	@RequestMapping(params = "method=initUserList2")
	public String initUserList2(HttpServletRequest request , ModelMap model , DemoForm userForm) {
		List<DemoOrgInfo> orgList = userService.getOrgList();
		model.addAttribute("orgList",orgList);
		
		return "demo/userList2";
	}
	
	@ResponseBody
	@RequestMapping(params = "method=listUsers2")
	public Object listUsers2(DemoForm form) {
		int totalCount = userService.getTotalCount(form);
		if(totalCount > 0){
			BasePageResult<DemoUser> result = new BasePageResult<DemoUser>();
			
			form.setBeginNum(((form.getPageindex()-1)*form.getPageSize()));
			form.setEndNum((form.getPageindex()*form.getPageSize()));
			List<DemoUser> user = userService.getUserList2(form);
			result.setTotalCount(totalCount);
			result.setResult(user);
			return result;
		}
		return null;
	}
	
	@RequestMapping(params = "method=userDetail")
	public String userDetail(HttpServletRequest request , ModelMap model , int userId) {
		DemoUser user = userService.getUserById(userId);
		model.addAttribute("user",user);
		return "demo/userDetail";
	}
	
}
