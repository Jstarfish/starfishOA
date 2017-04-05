package cls.taishan.system.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.taishan.common.utils.LocaleUtil;
import cls.taishan.system.form.InstitutionForm;
import cls.taishan.system.model.Institution;
import cls.taishan.system.model.User;
import cls.taishan.system.service.InstitutionService;
@RequestMapping("institution")
@Controller
public class InstitutionController {
	
	@Autowired
	private InstitutionService institutionService;
	
	@RequestMapping(params="method=initInstitutionList")
	public String initInstitutionList(HttpServletRequest request,ModelMap model){
		return LocaleUtil.getUserLocalePath("system/institution/institutionList", request);
	}
	
	@ResponseBody
	@RequestMapping(params="method=listInstitution")
	public Object listInstitution(InstitutionForm form){
		List<Institution> institution = institutionService.getInstitutionList(form);
		return institution;
	}
	
	@RequestMapping(params="method=addOrg")
	public String addOrg(HttpServletRequest request,ModelMap model){
		List<User> userList = this.institutionService.getUser();
		model.addAttribute("userList", userList);
		return LocaleUtil.getUserLocalePath("system/institution/addInstitutuion", request);
	}
	
	@ResponseBody
	@RequestMapping(params="method=saveInstitution")
	public String saveAddInstitution(HttpServletRequest request,ModelMap model,Institution institution){
		try {
			String orgCode = institutionService.getOrgCode(institution.getOrgCode());
			if(orgCode != null){
				return "exist";
			}
			institutionService.saveInstitution(institution);
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
	
	@RequestMapping(params="method=editInstitution")
	public String editOrg(HttpServletRequest request,ModelMap model,String orgCode){
		List<User> userList = this.institutionService.getUser();
		Institution orgInfo = this.institutionService.getOrgInfoByCode(orgCode);
		model.addAttribute("userList", userList);
		model.addAttribute("orgInfo", orgInfo);
		return LocaleUtil.getUserLocalePath("system/institution/editInstitution", request);
	}
	
	
	@ResponseBody
	@RequestMapping(params="method=updateOrg")
	public String updateOrg(HttpServletRequest request,ModelMap model,Institution institution){
		try {
			institutionService.updateOrg(institution);
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
	
	@ResponseBody
	@RequestMapping(params="method=deleteOrg")
	public String deleteOrg(HttpServletRequest request,ModelMap model,String orgCode){
		try {
			institutionService.deleteOrg(orgCode);
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
	
}