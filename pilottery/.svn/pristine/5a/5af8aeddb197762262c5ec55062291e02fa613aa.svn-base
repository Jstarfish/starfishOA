package cls.pilottery.web.marketManager.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.web.marketManager.form.DamegeGoodForm;
import cls.pilottery.web.marketManager.model.GamePlanModel;
import cls.pilottery.web.marketManager.model.InventoryTreeModel;
import cls.pilottery.web.marketManager.service.DamegeGoodService;
import cls.pilottery.web.sales.controller.OrderController;
import cls.pilottery.web.system.model.User;

import com.alibaba.fastjson.JSONObject;

@Controller
@RequestMapping("damegeGood")
public class DamegeGoodController {
	Logger log = Logger.getLogger(DamegeGoodController.class);
	@Autowired
	private DamegeGoodService damegeGoodService;
	
	@RequestMapping(params = "method=initDamageGood")
	public String initDamageGood(HttpServletRequest request, ModelMap model,DamegeGoodForm form){
		User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		List<GamePlanModel> planList = damegeGoodService.getPlanListByUser(currentUser.getId().intValue());
		
		model.addAttribute("planList", planList);
		
		return "marketManager/damagedGoods/damageGoods";
	}
	
	@ResponseBody
	@RequestMapping(params = "method=getBatchListByPlan")
	public String getBatchListByPlan(HttpServletRequest request, ModelMap model,DamegeGoodForm form){
		String planCode = request.getParameter("planCode");
		User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		form.setPlanCode(planCode);
		form.setCurrentUserId(currentUser.getId().intValue());
		List<GamePlanModel> batchList = damegeGoodService.getBatchListByPlan(form);
		
		String result = JSONObject.toJSONString(batchList);
		return result;
	}
	
	@ResponseBody
	@RequestMapping(params = "method=getTreeByBatch")
	public String getTreeByBatch(HttpServletRequest request, ModelMap model,DamegeGoodForm form){
		User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
		form.setCurrentUserId(currentUser.getId().intValue());
		List<InventoryTreeModel> batchList = damegeGoodService.getTreeByBatch(form);
		
		String result = JSONObject.toJSONString(batchList);
		return result;
	}
	
	@RequestMapping(params = "method=damageGoods")
	public String damageGoods(HttpServletRequest request, ModelMap model,DamegeGoodForm form){
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			damegeGoodService.saveDamageGoods(form);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message",e.getMessage());
			log.error("损坏登记保存出现异常！", e);
			return "_common/errorTip";
		}
		
		return "marketManager/damagedGoods/damageSuccessTip";
	}
	
}
