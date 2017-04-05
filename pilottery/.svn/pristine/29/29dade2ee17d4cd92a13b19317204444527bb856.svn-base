package cls.pilottery.web.warehouses.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.utils.LocaleUtil;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.institutions.model.InfOrgs;
import cls.pilottery.web.system.model.User;
import cls.pilottery.web.warehouses.form.NewWarehouseForm;
import cls.pilottery.web.warehouses.form.UserSessionForm;
import cls.pilottery.web.warehouses.form.WarehouseDeleteForm;
import cls.pilottery.web.warehouses.form.WarehouseQueryForm;
import cls.pilottery.web.warehouses.model.WarehouseInfo;
import cls.pilottery.web.warehouses.model.WarehouseManager;
import cls.pilottery.web.warehouses.service.WarehouseService;

/**
 * @ClassName WarehouseController
 * @Description 
 * @author Wang Qingxiang
 * @date 2015-09-16
 */

@Controller
@RequestMapping("/warehouses")
public class WarehouseController {
    static Logger logger = Logger.getLogger(WarehouseController.class);
    
    @Autowired
    private WarehouseService warehouseService;
    
    //仓库信息列表查询
    @RequestMapping(params="method=listWarehouses")
    public String listWarehouses(HttpServletRequest request, ModelMap model, @ModelAttribute("warehouseQueryForm") WarehouseQueryForm warehouseQueryForm) throws Exception {
        
    	//获得当前登录用户的所属机构
    	User currentUser = (User)request.getSession().getAttribute("current_user");
    	if (currentUser == null) {
    		warehouseQueryForm.setSessionOrgCode("00");
    	} else {
    		warehouseQueryForm.setSessionOrgCode(currentUser.getInstitutionCode());
    	}
    	
        //查询块所属部门下拉框
        List<InfOrgs> institutionList = new ArrayList<InfOrgs>();
        UserSessionForm userSessionForm = new UserSessionForm();
        userSessionForm.setSessionOrgCode(warehouseQueryForm.getSessionOrgCode());
        institutionList = warehouseService.getAvailableInstitution(userSessionForm);
        model.addAttribute("institutionList", institutionList);
        
        Integer count = warehouseService.getWarehouseCount(warehouseQueryForm);
        int pageIndex = PageUtil.getPageIndex(request);
        List<WarehouseInfo> warehouseList = new ArrayList<WarehouseInfo>();
        
        if (count != null && count.intValue() != 0) {
            warehouseQueryForm.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
            warehouseQueryForm.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
            
            warehouseList = warehouseService.getWarehouseList(warehouseQueryForm);
        }
        
        model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
        model.addAttribute("pageDataList", warehouseList);
        model.addAttribute("warehouseQueryForm", warehouseQueryForm);
        
        return LocaleUtil.getUserLocalePath("inventory/warehouses/listWarehouses", request);
        //return "inventory/warehouses/listWarehouses";
    }
    
    //获得推荐的仓库编码
    @ResponseBody
    @RequestMapping(params="method=getRecommendedWarehouseCode")
    public String getRecommendedWarehouseCode(HttpServletRequest request, ModelMap model) throws Exception {
    	String orgCode = request.getParameter("orgCode");
    	String warehouseCode = warehouseService.getRecommendedWarehouseCode(orgCode);
    	return warehouseCode;
    }
    
    //由部门编码获得当前部门下的所有用户
    @ResponseBody
    @RequestMapping(params="method=getUserUnder")
    public List<User> getUserUnder(HttpServletRequest request, ModelMap model) throws Exception {
    	String orgCode = request.getParameter("orgCode");
    	return warehouseService.getUserUnder(orgCode);
    }
    
    //添加仓库
    @RequestMapping(params="method=addWarehouseInit")
    public String addWarehouseInit(HttpServletRequest request, ModelMap model) throws Exception {
    	
    	//获得当前登录用户的所属机构
    	UserSessionForm userSessionForm = new UserSessionForm();
    	User currentUser = (User)request.getSession().getAttribute("current_user");
    	if (currentUser == null) {
    		userSessionForm.setSessionOrgCode("00");
    	} else {
    		userSessionForm.setSessionOrgCode(currentUser.getInstitutionCode());
    	}
    	
        //查询块所属部门下拉框
        List<InfOrgs> institutionList = new ArrayList<InfOrgs>();
        institutionList = warehouseService.getAvailableInstitution(userSessionForm);
        model.addAttribute("institutionList", institutionList);
    	
        return LocaleUtil.getUserLocalePath("inventory/warehouses/addWarehouse", request);
        //return "inventory/warehouses/addWarehouse";
    }
    
    //添加仓库（提交）
    @RequestMapping(params="method=addWarehouse")
    public String addWarehouse(HttpServletRequest request, ModelMap model, @ModelAttribute("newWarehouseForm") NewWarehouseForm newWarehouseForm) throws Exception {
    	
    	//从Session中获得当前用户信息
    	User currentUser = (User)request.getSession().getAttribute("current_user");
    	if (currentUser == null) {
    		newWarehouseForm.setCreateAdmin(0);
    	} else {
    		newWarehouseForm.setCreateAdmin((Integer)currentUser.getId().intValue());
    	}
    	
    	//调用存储过程
    	try {
    		logger.info("warehouseCode:" + newWarehouseForm.getWarehouseCode() +
    				    ",warehouseName:" + newWarehouseForm.getWarehouseName() +
    				    ",institutionCode" + newWarehouseForm.getInstitutionCode() +
    				    ",warehouseAddress" + newWarehouseForm.getWarehouseAddress() + 
    				    ",contactPhone" + newWarehouseForm.getContactPhone() + 
    				    ",contactPerson" + newWarehouseForm.getContactPerson() +
    				    ",createAdmin" + newWarehouseForm.getCreateAdmin() + 
    				    ",warehouseManager" + newWarehouseForm.getWarehouseManager());
    		warehouseService.addWarehouse(newWarehouseForm);
    		if (newWarehouseForm.getC_errcode().intValue() == 0) {
    			return LocaleUtil.getUserLocalePath("common/successTip", request);
    			//return "common/successTip";
    		} else {
    			logger.error("errmsgs:" + newWarehouseForm.getC_errmsg());
    			model.addAttribute("system_message", newWarehouseForm.getC_errmsg());
    			return LocaleUtil.getUserLocalePath("common/errorTip", request);
    			//return "common/errorTip";
    		}
    	} catch (Exception e) {
    		logger.error("errmsgs: " + e.getMessage());
    		model.addAttribute("system_message", e.getMessage());
    		return LocaleUtil.getUserLocalePath("common/errorTip", request);
    		//return "common/errorTip";
    	}
    }
    
    //仓库详细信息
    @RequestMapping(params="method=warehouseDetails")
    public String warehouseDetails(HttpServletRequest request, ModelMap model) throws Exception {
    	
    	String curWarehouseCode = request.getParameter("curWarehouseCode");
    	
    	WarehouseInfo details = warehouseService.getWarehouseDetails(curWarehouseCode);
    	model.addAttribute("details", details);
    	
    	UserSessionForm userSessionForm = new UserSessionForm();
    	userSessionForm.setWarehouseCode(curWarehouseCode);
    	
    	List<WarehouseManager> managers = warehouseService.getWarehouseManagers(userSessionForm);
    	model.addAttribute("managers", managers);
    	
    	return LocaleUtil.getUserLocalePath("inventory/warehouses/warehouseDetails", request);
    	//return "inventory/warehouses/warehouseDetails";
    }
    
    //修改仓库信息（页面）
    @RequestMapping(params="method=modifyWarehouseInit")
    public String modifyWarehouseInit(HttpServletRequest request, ModelMap model) throws Exception {
    	
    	String curWarehouseCode = request.getParameter("curWarehouseCode");
    	
    	WarehouseInfo details = warehouseService.getWarehouseDetails(curWarehouseCode);
    	model.addAttribute("details", details);
    	
    	List<User> availableDirectors = warehouseService.getAvailableDirector(curWarehouseCode);
    	model.addAttribute("availableDirectors", availableDirectors);
    	
    	List<User> availableManagers = warehouseService.getAvailableManager(curWarehouseCode);
    	model.addAttribute("availableManagers", availableManagers);
    	
    	return LocaleUtil.getUserLocalePath("inventory/warehouses/modifyWarehouse", request);
    	//return "inventory/warehouses/modifyWarehouse";
    }
    
    //修改仓库信息（提交）
    @RequestMapping(params="method=modifyWarehouse")
    public String modifyWarehouse(HttpServletRequest request, ModelMap model, @ModelAttribute("newWarehouseForm") NewWarehouseForm newWarehouseForm) throws Exception {
    	
    	//调用存储过程
    	try {
    		logger.info("warehouseCode:" + newWarehouseForm.getWarehouseCode() +
    				    ",warehouseName:" + newWarehouseForm.getWarehouseName() +
    				    ",institutionCode" + newWarehouseForm.getInstitutionCode() +
    				    ",warehouseAddress" + newWarehouseForm.getWarehouseAddress() + 
    				    ",contactPhone" + newWarehouseForm.getContactPhone() + 
    				    ",contactPerson" + newWarehouseForm.getContactPerson() +
    				    ",warehouseManager" + newWarehouseForm.getWarehouseManager());
    		warehouseService.modifyWarehouse(newWarehouseForm);
    		if (newWarehouseForm.getC_errcode().intValue() == 0) {
    			return LocaleUtil.getUserLocalePath("common/successTip", request);
    			//return "common/successTip";
    		} else {
    			logger.error("errmsgs:" + newWarehouseForm.getC_errmsg());
    			model.addAttribute("system_message", newWarehouseForm.getC_errmsg());
    			return LocaleUtil.getUserLocalePath("common/errorTip", request);
    			//return "common/errorTip";
    		}
    	} catch (Exception e) {
    		logger.error("errmsgs: " + e.getMessage());
    		model.addAttribute("system_message", e.getMessage());
    		return LocaleUtil.getUserLocalePath("common/errorTip", request);
    		//return "common/errorTip";
    	}
    }
    
    //删除仓库
    @ResponseBody
    @RequestMapping(params="method=deleteWarehouse")
    public Map<String, String> deleteWarehouse(HttpServletRequest request, ModelMap model, WarehouseDeleteForm warehouseDeleteForm) throws Exception {
    	
    	//从Session中获得当前用户id
    	User currentUser = (User)request.getSession().getAttribute("current_user");
    	if (currentUser != null) {
    		warehouseDeleteForm.setOperator(currentUser.getId().intValue());
    	}
    	else {
    		warehouseDeleteForm.setOperator(0);
    	}
    	
    	Map<String, String> json = new HashMap<String, String>();
    	try {
    		logger.info("warehouseCode:" + warehouseDeleteForm.getWarehouseCode() +
				    ",operator:" + warehouseDeleteForm.getOperator());
    		warehouseService.deleteWarehouse(warehouseDeleteForm);
    		if (warehouseDeleteForm.getC_errcode().intValue() == 0)
    		{
    			json.put("message", "");
    		}
    		else
    		{
    			logger.error("errmsgs: " + warehouseDeleteForm.getC_errmsg());
    			json.put("message", warehouseDeleteForm.getC_errmsg());
    		}
    	} catch (Exception e) {
    		logger.error("errmsgs" + e.getMessage());
    		json.put("message", "Delete Failed: "+e.getMessage());
    	}
    	
    	return json;
    }
}
