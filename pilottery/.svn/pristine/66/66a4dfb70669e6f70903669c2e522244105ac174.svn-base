package cls.pilottery.web.marketManager.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import cls.pilottery.common.constants.SysConstants;
import cls.pilottery.common.utils.PageUtil;
import cls.pilottery.web.marketManager.entity.ReturnDeliveryOrder;
import cls.pilottery.web.marketManager.form.ReturnDeliveryForm;
import cls.pilottery.web.marketManager.service.ReturnDeliveryService;
import cls.pilottery.web.sales.model.PlanModel;
import cls.pilottery.web.sales.service.OrderService;
import cls.pilottery.web.system.model.User;
/**
 * 还货单
 * @author Administrator
 *
 */
@Controller
@RequestMapping("returnDelivery")
public class ReturnDeliveryController {
	Logger log = Logger.getLogger(ReturnDeliveryController.class);
	
	@Autowired
	private OrderService orderService;
	@Autowired
	private ReturnDeliveryService returnDeliveryService;
	
	@RequestMapping(params = "method=listReturnDeliveries")
	public String listReturnDelivery(HttpServletRequest request, ModelMap model,ReturnDeliveryForm form) {
		List<ReturnDeliveryOrder> list = null;
		int count = 0 ;
		try {
			User currentUser = (User)request.getSession().getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			form.setCurrentUserId(currentUser.getId().intValue());
			form.setCuserOrg(currentUser.getInstitutionCode());
			int pageIndex = PageUtil.getPageIndex(request);
			count = returnDeliveryService.getReturnDeliveryCount(form);
			if (count > 0) {
				form.setBeginNum((pageIndex - 1) * PageUtil.pageSize);
				form.setEndNum((pageIndex - 1) * PageUtil.pageSize + PageUtil.pageSize);
				list = returnDeliveryService.getReturnDeliveryList(form);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("查询还货单列表功能发生异常！", e);
			return "_common/errorTip";
		}
		model.addAttribute("pageStr", PageUtil.getPageStr(request, count));
		model.addAttribute("pageDataList", list);
		model.addAttribute("form",form);
		return "marketManager/returnDelivery/listReturnDelivery";
	}
	
	@RequestMapping(params = "method=initReturnDeliveryAdd")
	public String initReturnDeliveryAdd(HttpServletRequest request, ModelMap model) {
		try {
			List<PlanModel> planList = orderService.getPlanList();
			model.addAttribute("planList",planList);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化还货单新增页面发生异常！", e);
			return "common/errorTip";
		}
		model.addAttribute("oper",1);
		return "marketManager/returnDelivery/addReturnDelivery";
	}
	
	@RequestMapping(params = "method=saveReturnDelivery")
	public String saveReturnDelivery(HttpSession session, ModelMap model,ReturnDeliveryOrder order) {
		try {
			User currentUser = (User)session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			order.setMarketManagerAdmin(currentUser.getId().intValue());
			returnDeliveryService.saveReturnDelivery(order);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("保存还货单功能发生异常！", e);
			return "common/errorTip";
		}
		return "common/successTip";
	}
	
	@ResponseBody
	@RequestMapping(params="method=cancelReturnDelivery")
	public String cancelReturnDelivery(HttpServletRequest request){
		String queryNo=request.getParameter("queryNo");
		String result = null;
		try{
			//修改订单状态为2(已撤销)
			int updateCount = returnDeliveryService.modifyReturnDeliveryStatus(queryNo,2);
			if(updateCount !=1){
				log.warn("撤销还货单出现异常,还货单编号:"+queryNo+",撤销记录数:"+updateCount);
				result="Cancel Failed!";
			}
		}catch(Exception e){
			log.error("撤销还货单出现异常,异常信息:"+e.getMessage());
			result = "Cancel Failed : System Error！";
		}
		return result;
	}

	@RequestMapping(params = "method=returnDeliveryDetail")
	public String returnDeliveryDetail(HttpServletRequest request, ModelMap model) {
		ReturnDeliveryOrder order = null;
		try {
			String queryNo = request.getParameter("queryNo");
			order = returnDeliveryService.getReturnDeliveryDetail(queryNo);
			List<PlanModel> planList = orderService.getPlanList();
			model.addAttribute("planList",planList);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("查询还货单详情发生异常！", e);
			return "common/errorTip";
		}
		model.addAttribute("order",order);
		return "marketManager/returnDelivery/returnDeliveryDetail";
	}
	
	@RequestMapping(params = "method=initReturnDeliveryEdit")
	public String initReturnDeliveryEdit(HttpServletRequest request, ModelMap model) {
		ReturnDeliveryOrder order = null;
		try {
			String queryNo = request.getParameter("queryNo");
			order = returnDeliveryService.getReturnDeliveryDetail(queryNo);
			List<PlanModel> planList = orderService.getPlanList();
			model.addAttribute("planList",planList);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化还货单修改页面发生异常！", e);
			return "common/errorTip";
		}
		model.addAttribute("order",order);
		return "marketManager/returnDelivery/editReturnDelivery";
	}
	
	
	@RequestMapping(params = "method=updateReturnDelivery")
	public String updateReturnDelivery(HttpSession session, ModelMap model,ReturnDeliveryOrder order) {
		try {
			User currentUser = (User)session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			order.setMarketManagerAdmin(currentUser.getId().shortValue());
			returnDeliveryService.updateReturnDelivery(order);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("修改还货单功能发生异常！", e);
			return "common/errorTip";
		}
		return "common/successTip";
	}
	
	/*
	 * 初始化还货单审批页面
	 */
	@RequestMapping(params = "method=initAproveReturnDelivery")
	public String initAproveReturnDelivery(HttpServletRequest request, ModelMap model) {
		ReturnDeliveryOrder order = null;
		try {
			String queryNo = request.getParameter("queryNo");
			order = returnDeliveryService.getReturnDeliveryDetail(queryNo);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("初始化还货单审批页面发生异常！", e);
			return "common/errorTip";
		}
		model.addAttribute("order",order);
		return "sales/stockTransfer/approveStockTransfer";
	}
	
	@RequestMapping(params = "method=approveReturnDelivery")
	public String approveReturnDelivery(HttpServletRequest request,HttpSession session, ModelMap model,ReturnDeliveryOrder order) {
		try {
			User currentUser = (User)session.getAttribute(SysConstants.CURR_LOGIN_USER_SESSION);
			order.setMarketManagerAdmin(currentUser.getId().shortValue());
			String apprlveStatus = request.getParameter("approveStatus");
			if("1".equals(apprlveStatus)){
				order.setStatus(7);
			}else{
				order.setStatus(8);
			}
			returnDeliveryService.updateReturnDeliveryAproval(order);
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("system_message", e.getMessage());
			log.error("修改还货单功能发生异常！", e);
			return "common/errorTip";
		}
		return "common/successTip";
	}
}
